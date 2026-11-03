import 'activity_feed_item_response.dart';

class PageActivityFeedResponse {
  final int totalElements;
  final int totalPages;
  final bool first;
  final bool last;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;
  final List<ActivityFeedItemResponse> content;

  PageActivityFeedResponse({
    required this.totalElements,
    required this.totalPages,
    required this.first,
    required this.last,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.empty,
    required this.content,
  });

  factory PageActivityFeedResponse.fromJson(Map<String, dynamic> json) {
    final rawContent = json['content'] as List? ?? [];
    final list = rawContent
        .whereType<Map>()
        .map((item) => ActivityFeedItemResponse.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    return PageActivityFeedResponse(
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      first: json['first'] ?? true,
      last: json['last'] ?? true,
      size: json['size'] ?? 0,
      number: json['number'] ?? 0,
      numberOfElements: json['numberOfElements'] ?? 0,
      empty: json['empty'] ?? list.isEmpty,
      content: list,
    );
  }

  factory PageActivityFeedResponse.fromList(List<ActivityFeedItemResponse> items) {
    return PageActivityFeedResponse(
      totalElements: items.length,
      totalPages: 1,
      first: true,
      last: true,
      size: items.length,
      number: 0,
      numberOfElements: items.length,
      empty: items.isEmpty,
      content: items,
    );
  }
}
