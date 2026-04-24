import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/dashboard/view/dashboard_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/dashboard/view/dashboard_navigation.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // Current carousel index

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load current version
      currentVersion = await getCurrentVersion();
      setState(() {});

      // Check for updates
      hasUpdate = await checkForUpdate();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App regained focus (user switched back)
      _handleAppResumed();
    }
  }

  @override
  void dispose() {
    // Remove observer to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _handleAppResumed() async {
    hasUpdate = await checkForUpdate();
  }

  int _currentCarouselIndex = 0;
  var hasUpdate = false;

  String status = "Idle";
  double progress = 0.0;
  bool isDownloading = false;

  // Add version tracking
  String currentVersion = "";
  String latestVersion = "";

  Future<String> getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version; // e.g. "1.2.3"
  }

  String stripBom(String input) {
    const bom = '\uFEFF';
    if (input.startsWith(bom)) {
      return input.substring(1);
    }
    return input;
  }

  Future<bool> checkForUpdate() async {
    setState(() => status = "Checking for update...");
    final response = await http.get(Uri.parse(AppUrl().update_json_url));
    if (response.statusCode == 200) {
      const prefix = 'ï»¿';
      var body = response.body;
      if (body.startsWith(prefix)) {
        body = body.substring(prefix.length);
      }
      var data = json.decode(body);
      log("data $data");
      latestVersion = data['latest_version'];
      final currentVer = await getCurrentVersion();
      if (isNewerVersion(latestVersion, currentVer)) {
        // Update available
        setState(() {});
        return true;
      }
    } else {
      log('Failed to fetch update info');
      return false;
    }
    setState(() {});
    return false;
  }

  bool isNewerVersion(String latest, String current) {
    final lv = latest.split('.').map(int.parse).toList();
    final cv = current.split('.').map(int.parse).toList();
    for (int i = 0; i < lv.length; i++) {
      if (lv[i] > cv[i]) return true;
      if (lv[i] < cv[i]) return false;
    }
    return false;
  }

  Future<String?> downloadInstaller(String url) async {
    try {
      setState(() {
        isDownloading = true;
        status = "Downloading update...";
        progress = 0.0;
      });

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/zivoro.exe';
      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();

      final contentLength = response.contentLength;
      int bytesReceived = 0;
      final file = File(filePath).openWrite();

      await for (var chunk in response) {
        bytesReceived += chunk.length;
        file.add(chunk);
        setState(() => progress = bytesReceived / contentLength);
      }

      await file.close();
      return filePath;
    } catch (e) {
      log("Download error: $e");
      setState(() => status = "Download failed");
      return null;
    } finally {
      setState(() => isDownloading = false);
    }
  }

  Future<void> installAndExit(String path) async {
    setState(() => status = "Installing...");
    try {
      await Process.start(path, []);
      exit(0); // Close app
    } catch (e) {
      log(e.toString());
      setState(() => status = "Installation failed");
    }
  }

  void handleUpdate() async {
    if (!hasUpdate) {
      setState(() => status = "You're up to date!");
      return;
    }

    if (Platform.isMacOS) {
      // On macOS we cannot silently install a DMG.
      // Open the download URL in the browser and guide the user.
      _showMacOSUpdateDialog();
      return;
    }

    // Windows: download the .exe installer and launch it
    final filePath = await downloadInstaller(AppUrl().setup_url);
    if (filePath != null) {
      setState(() => status = "Download complete. Installing...");
      await installAndExit(filePath);
    }
  }

  void _showMacOSUpdateDialog() {
    final downloadUrl = AppUrl().setup_url;
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.system_update, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Update Available — v$latestVersion'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A new version is ready to download.\n\nAfter downloading:',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text('1. Open the downloaded DMG file'),
                Text('2. Drag Zivoro to Applications'),
                Text('3. Run in terminal:'),
                SizedBox(height: 4),
                SelectableText(
                  'xattr -r -d com.apple.quarantine /Applications/jewellery_erp_frontend_tab_version.app',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Later'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download Now'),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final uri = Uri.parse(downloadUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyL):
            const SwitchToOverviewTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyP):
            const SwitchToPaymentTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyG):
            const SwitchToLedgerTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyH):
            const SwitchToPurchaseTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyR):
            const SwitchToPurchaseReturnTabIntent(),
      },
      child: FocusScope(
        autofocus: true,
        child: Scaffold(
          backgroundColor: grey1,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isDownloading) ...[
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(value: progress),
                ),
                const SizedBox(height: 4),
                Text(status),
              ],
              hasUpdate
                  ? SizedBox(
                    width: Get.width * 0.2,
                    child: FloatingActionButton.extended(
                      heroTag: 'checkUpdate',
                      onPressed: isDownloading ? null : handleUpdate,
                      icon: const Icon(Icons.system_update),
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Update Available'),
                          if (latestVersion.isNotEmpty)
                            Text(
                              'v$latestVersion',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
              const SizedBox(height: 12),
              // spacing between buttons
              SizedBox(
                width: Get.width * 0.2,
                child: FloatingActionButton(
                  onPressed: () {
                    showSuccessToast(message: 'Opening Help & Support');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.headset_mic_outlined),
                      SizedBox(width: 8.0),
                      Text(DashboardConstants.helpSupportButtonText),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  "assets/svgs/auth/background.svg",
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(header: 'Dashboard'),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text("Current Version: $currentVersion"),
                        const SizedBox(height: 10),
                        if (isDownloading)
                          LinearProgressIndicator(value: progress),
                        const SizedBox(height: 10),
                      ],
                    ),

                    // Version Display Section
                    if (currentVersion.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: secondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: secondaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: secondaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Version $currentVersion',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    Row(
                      children: [
                        Expanded(flex: 3, child: _buildCarouselSection()),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: DashboardConstants.carouselHeight,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Column(
                                children: [
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Ask Me Anything ..",
                                        hintStyle: TextStyle(color: whiteColor),
                                        fillColor: primaryColor,
                                        prefixIcon: Icon(
                                          Icons.image_outlined,
                                          color: whiteColor,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.send_outlined,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Daily Management Section
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        DashboardConstants.dailySectionTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildQuickActionsGrid(),

                    // Services Section
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            DashboardConstants.servicesSectionTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildServicesGrid(),

                    // Online Section
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        DashboardConstants.onlineSectionTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildOnlineGrid(),

                    // Bottom version display (alternative placement)
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Carousel Section
  Widget _buildCarouselSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: DashboardConstants.carouselHeight,
              aspectRatio: 16 / 9,
              viewportFraction: DashboardConstants.viewportFraction,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: DashboardConstants.autoPlayInterval,
              autoPlayAnimationDuration:
                  DashboardConstants.autoPlayAnimationDuration,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
              scrollDirection: Axis.horizontal,
            ),
            items: List.generate(DashboardConstants.carouselItemCount, (index) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(DashboardConstants.carouselItemCount, (
              index,
            ) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentCarouselIndex == index
                          ? secondaryColor
                          : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Daily Management Grid
  Widget _buildQuickActionsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: DashboardConstants.gridCrossAxisCount,
          childAspectRatio: DashboardConstants.gridChildAspectRatio,
          crossAxisSpacing: DashboardConstants.gridCrossAxisSpacing,
          mainAxisSpacing: DashboardConstants.gridMainAxisSpacing,
        ),
        itemCount: DashboardConstants.dailyActions.length,
        itemBuilder: (context, index) {
          final action = DashboardConstants.dailyActions[index];
          return _buildActionCardWithDropdown(
            icon: action['icon'],
            title: action['title'],
            color: secondaryColor,
            actionOptions: action['options'],
            cardType: DashboardConstants.dailyCardType,
          );
        },
      ),
    );
  }

  // Services Grid
  Widget _buildServicesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: DashboardConstants.gridCrossAxisCount,
          childAspectRatio: DashboardConstants.gridChildAspectRatio,
          crossAxisSpacing: DashboardConstants.gridCrossAxisSpacing,
          mainAxisSpacing: DashboardConstants.gridMainAxisSpacing,
        ),
        itemCount: DashboardConstants.servicesActions.length,
        itemBuilder: (context, index) {
          final service = DashboardConstants.servicesActions[index];
          return _buildActionCardWithDropdown(
            icon: service['icon'],
            title: service['title'],
            color: secondaryColor,
            actionOptions: service['options'],
            cardType: DashboardConstants.servicesCardType,
          );
        },
      ),
    );
  }

  // Online Grid
  Widget _buildOnlineGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: DashboardConstants.gridCrossAxisCount,
          childAspectRatio: DashboardConstants.gridChildAspectRatio,
          crossAxisSpacing: DashboardConstants.gridCrossAxisSpacing,
          mainAxisSpacing: DashboardConstants.gridMainAxisSpacing,
        ),
        itemCount: DashboardConstants.onlineActions.length,
        itemBuilder: (context, index) {
          final onlineItem = DashboardConstants.onlineActions[index];
          return _buildActionCardWithDropdown(
            icon: onlineItem['icon'],
            title: onlineItem['title'],
            color: secondaryColor,
            actionOptions: onlineItem['options'],
            cardType: DashboardConstants.onlineCardType,
          );
        },
      ),
    );
  }

  Widget _buildActionCardWithDropdown({
    required IconData icon,
    required String title,
    required Color color,
    required List<String> actionOptions,
    required String cardType,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Builder(
        builder: (BuildContext cardContext) {
          return InkWell(
            onTap: () {
              if (title == 'Reports') {
                showSuccessToast(message: 'Opening Reports Dashboard');
                DashboardNavigation.navigateToMenuItem('reports');
                return;
              }
              final RenderBox? renderBox =
                  cardContext.findRenderObject() as RenderBox?;
              if (renderBox == null) return;

              final position = renderBox.localToGlobal(Offset.zero);
              final size = renderBox.size;

              showMenu<String>(
                context: context,
                position: RelativeRect.fromLTRB(
                  position.dx,
                  position.dy + size.height,
                  position.dx + size.width,
                  position.dy +
                      size.height +
                      100, // Added extra space for proper positioning
                ),
                items:
                    actionOptions.map((String element) {
                      return PopupMenuItem<String>(
                        value: element,
                        height: 0,
                        child: SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                element,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (element != actionOptions.last)
                                CustomDashedLineWidget(width: Get.width),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ).then((String? value) {
                if (value != null) {
                  _handleActionOptionSelected(title, value, cardType);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Icon(icon, color: Colors.white, size: 38)],
                  ),
                  const SizedBox(height: 6),
                  CustomDashedLineWidget(width: Get.width),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleActionOptionSelected(
    String cardTitle,
    String option,
    String cardType,
  ) {
    log('Selected $option for $cardTitle in $cardType section');

    // First show a toast message for feedback
    showSuccessToast(
      message: DashboardConstants.getGenericActionMessage(option, cardTitle),
    );

    // Navigate based on card type using the navigation class
    switch (cardType) {
      case DashboardConstants.dailyCardType:
        DashboardNavigation.handleDailyAction(cardTitle, option);
        break;
      case DashboardConstants.servicesCardType:
        DashboardNavigation.handleServicesAction(cardTitle, option);
        break;
      case DashboardConstants.onlineCardType:
        DashboardNavigation.handleOnlineAction(cardTitle, option);
        break;
    }
  }
}
