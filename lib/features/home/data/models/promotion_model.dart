// lib/features/home/data/models/promotion_model.dart
class PromotionModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double? discountPrice;
  final DateTime validUntil;

  PromotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.discountPrice,
    required this.validUntil,
  });
}
