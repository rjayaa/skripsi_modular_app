// lib/features/home/data/models/news_model.dart
class NewsModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final DateTime publishDate;
  final String author;
  final String category;

  NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.publishDate,
    this.author = 'Admin',
    this.category = 'Updates',
  });
}
