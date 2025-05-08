import 'package:hive/hive.dart';
import '../models/product_model.dart';


class ReviewRepository {
  final Box<List> _box = Hive.box<List>('reviewsBox');

  List<CustomerReview> getReviews(String productId) {
    return (_box.get(productId)?.cast<CustomerReview>()) ?? [];
  }

  void addReview(String productId, CustomerReview review) {
    final current = getReviews(productId);
    current.add(review);
    _box.put(productId, current);
  }
}
