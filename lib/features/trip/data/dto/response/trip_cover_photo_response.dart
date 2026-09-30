class TripCoverPhotoResponse {
  final int? id;
  final String? originalFileName;
  final String? fileType;
  final int? fileSize;
  final String? filePath;
  final int? uploadedBy;
  final DateTime? createdAt;
  final String? url;

  TripCoverPhotoResponse({
    this.id,
    this.originalFileName,
    this.fileType,
    this.fileSize,
    this.filePath,
    this.uploadedBy,
    this.createdAt,
    this.url,
  });

  factory TripCoverPhotoResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return TripCoverPhotoResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(
        json['id']?.toString() ?? '',
      ),

      originalFileName:
      json['originalFileName']?.toString(),

      fileType:
      json['fileType']?.toString(),

      fileSize: json['fileSize'] is int
          ? json['fileSize']
          : int.tryParse(
        json['fileSize']?.toString() ?? '',
      ),

      filePath:
      json['filePath']?.toString(),

      uploadedBy: json['uploadedBy'] is int
          ? json['uploadedBy']
          : int.tryParse(
        json['uploadedBy']?.toString() ?? '',
      ),

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(
        json['createdAt'].toString(),
      )
          : null,

      url:
      json['url']?.toString(),
    );
  }
}