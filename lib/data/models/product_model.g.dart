// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      variants:
          (json['variants'] as List<dynamic>).map((e) => e as String).toList(),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => CustomerReview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      category: json['category'] as String,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'variants': instance.variants,
      'averageRating': instance.averageRating,
      'reviews': instance.reviews.map((e) => e.toJson()).toList(),
      'category': instance.category,
    };

CustomerReview _$CustomerReviewFromJson(Map<String, dynamic> json) =>
    CustomerReview(
      reviewerName: json['reviewerName'] as String,
      comment: json['comment'] as String,
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$CustomerReviewToJson(CustomerReview instance) =>
    <String, dynamic>{
      'reviewerName': instance.reviewerName,
      'comment': instance.comment,
      'rating': instance.rating,
    };
