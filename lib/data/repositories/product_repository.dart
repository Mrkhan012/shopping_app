import 'package:ecommerce/core/exceptions/custom_exceptions.dart';
import 'package:ecommerce/data/datasources/mock_data.dart';
import '../models/product_model.dart';

class ProductRepository {
  // Method to fetch all products
  List<ProductModel> getAllProducts() {
    try {
      if (sampleProducts.isEmpty) {
        throw CustomException('No products available.');
      }
      return sampleProducts;
    } catch (e) {
      throw CustomException('Failed to load products');
    }
  }
}
