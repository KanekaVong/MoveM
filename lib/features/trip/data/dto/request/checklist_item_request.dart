
class ChecklistItemRequest{

  final String itemName;

  ChecklistItemRequest({
    required this.itemName,
  });

  Map<String, dynamic> toJson() {
    return { 'itemName': itemName, };
  }
}