import 'package:json_annotation/json_annotation.dart';
part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> variants;
  final double averageRating;
  final List<CustomerReview> reviews;
  final String category;  // Add category field

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.variants,
    this.averageRating = 0.0,
    this.reviews = const [],
    required this.category,  // Add category in the constructor
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      variants: List<String>.from(json['variants'] ?? []),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((e) => CustomerReview.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      category: json['category'] as String, // Parse category
    );
  }

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class CustomerReview {
  final String reviewerName;
  final String comment;
  final double rating;

  CustomerReview({
    required this.reviewerName,
    required this.comment,
    required this.rating,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) =>
      _$CustomerReviewFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerReviewToJson(this);
}
