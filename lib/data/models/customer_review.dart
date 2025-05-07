import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class CustomerReview extends HiveObject {
  @HiveField(0)
  final String reviewerName;

  @HiveField(1)
  final String comment;

  @HiveField(2)
  final double rating;

  CustomerReview({
    required this.reviewerName,
    required this.comment,
    required this.rating,
  });
}
