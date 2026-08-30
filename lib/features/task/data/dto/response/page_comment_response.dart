import 'comment_response.dart';

class PageCommentResponse {
  final int totalElements;
  final int totalPages;
  final bool first;
  final bool last;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;
  final List<CommentResponse> content;

  PageCommentResponse({
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

  factory PageCommentResponse.fromJson(Map<String, dynamic> json) {
    var rawContent = json['content'] as List? ?? [];
    List<CommentResponse> list = rawContent
        .map((item) => CommentResponse.fromJson(item as Map<String, dynamic>))
        .toList();

    return PageCommentResponse(
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

  Map<String, dynamic> toJson() {
    return {
      'totalElements': totalElements,
      'totalPages': totalPages,
      'first': first,
      'last': last,
      'size': size,
      'number': number,
      'numberOfElements': numberOfElements,
      'empty': empty,
      'content': content.map((e) => e.toJson()).toList(),
    };
  }
}
