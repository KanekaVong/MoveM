class AttachmentResponse {
  final int id;
  final String originalFileName;
  final String? fileType;
  final int? fileSize;
  final String filePath;
  final int? uploadedBy;
  final String? createdAt;
  final String? url;

  AttachmentResponse({
    required this.id,
    required this.originalFileName,
    this.fileType,
    this.fileSize,
    required this.filePath,
    this.uploadedBy,
    this.createdAt,
    this.url,
  });

  factory AttachmentResponse.fromJson(Map<String, dynamic> json) {
    return AttachmentResponse(
      id: json['id'] ?? 0,
      originalFileName: json['originalFileName'] ?? '',
      fileType: json['fileType'],
      fileSize: json['fileSize'],
      filePath: json['filePath'] ?? '',
      uploadedBy: json['uploadedBy'],
      createdAt: json['createdAt'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalFileName': originalFileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'filePath': filePath,
      'uploadedBy': uploadedBy,
      'createdAt': createdAt,
      'url': url,
    };
  }
}
