import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/models/http_request_log.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/talker_controller.dart';
import 'dart:convert';

class CustomTalkerScreen extends StatefulWidget {
  const CustomTalkerScreen({super.key});

  @override
  State<CustomTalkerScreen> createState() => _CustomTalkerScreenState();
}

class _CustomTalkerScreenState extends State<CustomTalkerScreen> {
  final TalkerController talkerController = Get.find<TalkerController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<int> _expandedIndices = {};

  List<TalkerData> get _filteredLogs {
    final logs = talkerController.talker.history.toList().reversed.toList();
    if (_searchQuery.isEmpty) return logs;

    return logs.where((log) {
      final message = log.message?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();

      if (log is HttpRequestLog ||
          log is HttpResponseLog ||
          log is HttpErrorLog) {
        return message.contains(query);
      }
      return message.contains(query);
    }).toList();
  }

  void _toggleExpanded(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D30),
        title: const Text('Debug Logs', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export',
            onPressed: () => _exportLogs(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear',
            onPressed: () {
              talkerController.talker.cleanHistory();
              setState(() {
                _expandedIndices.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: const Color(0xFF2D2D30),
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search logs...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                        : null,
                filled: true,
                fillColor: const Color(0xFF3C3C3C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Logs list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLogs.length,
              itemBuilder: (context, index) {
                final log = _filteredLogs[index];
                final isExpanded = _expandedIndices.contains(index);

                if (log is HttpRequestLog) {
                  return _buildHttpRequestTile(log, index, isExpanded);
                } else if (log is HttpResponseLog) {
                  return _buildHttpResponseTile(log, index, isExpanded);
                } else if (log is HttpErrorLog) {
                  return _buildHttpErrorTile(log, index, isExpanded);
                } else {
                  return _buildGenericLogTile(log, index, isExpanded);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHttpRequestTile(HttpRequestLog log, int index, bool isExpanded) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: const Color(0xFF2D2D30),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                log.method,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              log.url,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: isExpanded ? null : 1,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '📤 Request',
              style: TextStyle(color: Colors.blue[300], fontSize: 12),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey,
            ),
            onTap: () => _toggleExpanded(index),
          ),
          if (isExpanded) _buildRequestDetails(log),
        ],
      ),
    );
  }

  Widget _buildHttpResponseTile(
    HttpResponseLog log,
    int index,
    bool isExpanded,
  ) {
    final isSuccess = log.statusCode >= 200 && log.statusCode < 300;
    final isClientError = log.statusCode >= 400 && log.statusCode < 500;
    final isServerError = log.statusCode >= 500;

    Color statusColor = Colors.green;
    if (isClientError) statusColor = Colors.orange;
    if (isServerError) statusColor = Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: const Color(0xFF2D2D30),
      child: Column(
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.statusCode.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.method,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              log.url,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: isExpanded ? null : 1,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: [
                Text(
                  isSuccess ? '✅ Response' : '❌ Response',
                  style: TextStyle(color: statusColor, fontSize: 12),
                ),
                if (log.duration != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '⏱️ ${log.duration!.inMilliseconds}ms',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ],
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey,
            ),
            onTap: () => _toggleExpanded(index),
          ),
          if (isExpanded) _buildResponseDetails(log),
        ],
      ),
    );
  }

  Widget _buildHttpErrorTile(HttpErrorLog log, int index, bool isExpanded) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: const Color(0xFF2D2D30),
      child: Column(
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.statusCode?.toString() ?? 'ERR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.method,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              log.url,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: isExpanded ? null : 1,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '⛔ ${log.errorMessage}',
              style: const TextStyle(color: Colors.red, fontSize: 12),
              maxLines: isExpanded ? null : 1,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey,
            ),
            onTap: () => _toggleExpanded(index),
          ),
          if (isExpanded) _buildErrorDetails(log),
        ],
      ),
    );
  }

  Widget _buildGenericLogTile(TalkerData log, int index, bool isExpanded) {
    Color logColor = Colors.grey;
    IconData logIcon = Icons.info_outline;

    if (log.logLevel == LogLevel.error || log.logLevel == LogLevel.critical) {
      logColor = Colors.red;
      logIcon = Icons.error_outline;
    } else if (log.logLevel == LogLevel.warning) {
      logColor = Colors.orange;
      logIcon = Icons.warning_amber;
    } else if (log.logLevel == LogLevel.info) {
      logColor = Colors.blue;
      logIcon = Icons.info_outline;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: const Color(0xFF2D2D30),
      child: ListTile(
        leading: Icon(logIcon, color: logColor),
        title: Text(
          log.displayMessage,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          maxLines: isExpanded ? null : 2,
          overflow: isExpanded ? null : TextOverflow.ellipsis,
        ),
        subtitle: Text(
          log.displayTime as String,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        onTap: () => _toggleExpanded(index),
      ),
    );
  }

  Widget _buildRequestDetails(HttpRequestLog log) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (log.curlCommand != null) ...[
            _buildSectionHeader('cURL Command', log.curlCommand!),
            const SizedBox(height: 16),
          ],
          _buildSectionHeader('Request Headers', log.headers),
          if (log.body != null) ...[
            const SizedBox(height: 16),
            _buildSectionHeader('Request Body', log.body),
          ],
        ],
      ),
    );
  }

  Widget _buildResponseDetails(HttpResponseLog log) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Response Headers', log.headers),
          if (log.body != null) ...[
            const SizedBox(height: 16),
            _buildSectionHeader('Response Body', log.body),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorDetails(HttpErrorLog log) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error Type: ${log.errorType}',
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Message: ${log.errorMessage}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          if (log.responseBody != null) ...[
            const SizedBox(height: 16),
            _buildSectionHeader('Error Response', log.responseBody),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, dynamic data) {
    final jsonString = _formatJson(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              color: Colors.grey,
              tooltip: 'Copy',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonString));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF252526),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: SelectableText(
            jsonString,
            style: const TextStyle(
              color: Color(0xFF9CDCFE),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  String _formatJson(dynamic data) {
    try {
      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (e) {
          return data;
        }
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  void _showFilterDialog() {
    // Implement filter dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Logs'),
            content: const Text('Filter functionality coming soon'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Future<void> _exportLogs() async {
    try {
      final jsonData = await talkerController.exportLogsAsJson();

      // For desktop, save to downloads
      Clipboard.setData(ClipboardData(text: jsonData));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logs copied to clipboard')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
