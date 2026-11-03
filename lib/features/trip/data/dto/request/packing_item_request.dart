class PackingItemRequest {
  final String itemName;

  PackingItemRequest({
    required this.itemName,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
    };
  }
}