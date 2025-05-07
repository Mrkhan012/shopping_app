import 'package:ecommerce/data/models/product_model.dart';
import 'package:ecommerce/data/repositories/review_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewRepositoryProvider = Provider((ref) => ReviewRepository());

final productReviewsProvider = StateNotifierProvider.family<ReviewNotifier, List<CustomerReview>, String>(
  (ref, productId) => ReviewNotifier(ref.watch(reviewRepositoryProvider), productId),
);

class ReviewNotifier extends StateNotifier<List<CustomerReview>> {
  final ReviewRepository repo;
  final String productId;

  ReviewNotifier(this.repo, this.productId) : super(repo.getReviews(productId));

  void addReview(CustomerReview review) {
    repo.addReview(productId, review);
    state = [...state, review];
  }
}
