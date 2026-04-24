class ImageData {
  final String path;
  final bool isFile;
  final bool isDeleted;
  final String? fileName;
  final String? fileType;
  final String? s3Key;

  ImageData({
    required this.path,
    required this.isFile,
    this.isDeleted = false,
    this.fileName,
    this.fileType,
    this.s3Key,
  });

  ImageData copyWith({bool? isDeleted}) {
    return ImageData(
      path: path,
      isFile: isFile,
      isDeleted: isDeleted ?? this.isDeleted,
      fileName: fileName,
      fileType: fileType,
      s3Key: s3Key,
    );
  }
}
