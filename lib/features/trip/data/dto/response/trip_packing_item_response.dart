class TripPackingItemResponse {
  final int? id;
  final String? itemName;
  final bool? isPacked;
  final DateTime? createdAt;

  TripPackingItemResponse({
    this.id,
    this.itemName,
    this.isPacked,
    this.createdAt,
  });

  factory TripPackingItemResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return TripPackingItemResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(
        json['id']?.toString() ?? '',
      ),

      itemName: json['itemName']?.toString(),

      isPacked: json['isPacked'],

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(
        json['createdAt'].toString(),
      )
          : null,
    );
  }
}