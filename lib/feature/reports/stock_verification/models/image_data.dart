class ImageData {
  final String path;
  final bool isFile;
  final String? fileName;
  final String? fileType;
  final bool isDeleted;
  final String? s3Key;

  ImageData({
    required this.path,
    required this.isFile,
    this.fileName,
    this.fileType,
    this.isDeleted = false,
    this.s3Key,
  });

  @override
  String toString() {
    return 'ImageData(path: $path, isFile: $isFile, fileName: $fileName, fileType: $fileType, isDeleted: $isDeleted, s3Key: $s3Key)';
  }

  ImageData copyWith({
    String? path,
    bool? isFile,
    String? fileName,
    String? fileType,
    bool? isDeleted,
    String? s3Key,
  }) {
    return ImageData(
      path: path ?? this.path,
      isFile: isFile ?? this.isFile,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      isDeleted: isDeleted ?? this.isDeleted,
      s3Key: s3Key ?? this.s3Key,
    );
  }
}
