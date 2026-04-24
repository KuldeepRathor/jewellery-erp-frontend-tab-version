import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileDownloadUtil {
  /// Downloads and saves a file with the given data
  ///
  /// Parameters:
  /// - fileData: The binary data of the file to save
  /// - fileNamePrefix: Prefix for the generated filename (e.g., 'stock_and_value_report')
  /// - fileExtension: File extension (e.g., 'csv', 'pdf')
  ///
  /// Returns true if download was successful, false otherwise
  static Future<bool> downloadFile({
    required List<int> fileData,
    required String fileNamePrefix,
    required String fileExtension,
  }) async {
    try {
      // For Desktop platforms (Windows, macOS, Linux)
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Get directory from user
        String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory == null) return false;

        // Generate filename with timestamp
        final fileName =
            '${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

        // Create platform-specific file path
        final filePath = Platform.isWindows
            ? '$selectedDirectory\\$fileName'
            : '$selectedDirectory/$fileName';

        // Write the file
        File file = File(filePath);
        await file.writeAsBytes(fileData);

        // Open file location based on platform
        await _openFileLocation(filePath, selectedDirectory);

        return true;
      }
      // For mobile platforms
      else {
        // This is a placeholder for mobile implementation
        throw UnimplementedError('Mobile file download not yet implemented');
      }
    } catch (e) {
      log('Error downloading file: $e');
      return false;
    }
  }

  /// Opens the file location in the system file explorer
  static Future<void> _openFileLocation(
      String filePath, String directory) async {
    try {
      if (Platform.isWindows) {
        await Process.run('explorer', ['/select,', filePath]);
      } else if (Platform.isMacOS) {
        await Process.run('open', ['-R', filePath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [directory]);
      }
    } catch (e) {
      log('Error opening file location: $e');
    }
  }
}
