import 'package:ecommerce/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
// Filter State
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final priceRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(100, 10000));
final sortOrderProvider = StateProvider<String?>((ref) => null);

// Derived Filtered Products
final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final products = ref.watch(productListProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final priceRange = ref.watch(priceRangeProvider);
  final sortOrder = ref.watch(sortOrderProvider);

  var result = products.where((product) {
    final matchQuery = product.name.toLowerCase().contains(query);
    final matchCategory = category == null || category == 'All' || product.category == category;
    final matchPrice = product.price >= priceRange.start && product.price <= priceRange.end;
    return matchQuery && matchCategory && matchPrice;
  }).toList();

  if (sortOrder == 'asc') {
    result.sort((a, b) => a.price.compareTo(b.price));
  } else if (sortOrder == 'desc') {
    result.sort((a, b) => b.price.compareTo(a.price));
  }

  return result;
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Make this FutureProvider if getAllProducts is async
final productListProvider = Provider<List<ProductModel>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getAllProducts(); 
});
