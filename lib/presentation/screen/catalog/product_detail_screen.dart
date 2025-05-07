import 'package:ecommerce/core/utils/app_text_styles.dart';
import 'package:ecommerce/core/utils/colros.dart';
import 'package:ecommerce/presentation/providers/review_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/product_model.dart';
import '../../providers/product_providers.dart';
import '../../providers/cart_provider.dart';
class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late String selectedVariant;
final _reviewController = TextEditingController();
double _rating = 5.0;

@override
void dispose() {
  _reviewController.dispose();
  super.dispose();
}
  @override
  void initState() {
    super.initState();
    final product = ref
        .read(productListProvider)
        .firstWhere((p) => p.id == widget.productId);
    selectedVariant = product.variants.first;
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);
    final product = products.firstWhere((p) => p.id == widget.productId);
final reviews = ref.watch(productReviewsProvider(product.id));

    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: kDefaultBlueColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(product.name, style: AppTextStyles.title),
                  const SizedBox(height: 8),
                  Text(product.description, style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  Text('₹${product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.price),
                  const SizedBox(height: 16),

                  // Variant dropdown
                  DropdownButton<String>(
                    value: selectedVariant,
                    isExpanded: true,
                    onChanged: (value) => setState(() => selectedVariant = value!),
                    items: product.variants.map((variant) {
                      return DropdownMenuItem(
                        value: variant,
                        child: Text('Size: $variant'),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Write a Review', style: AppTextStyles.title),
      const SizedBox(height: 8),
      TextField(
        controller: _reviewController,
        decoration: InputDecoration(hintText: 'Write your comment here'),
      ),
      const SizedBox(height: 8),
      DropdownButton<double>(
        value: _rating,
        items: List.generate(5, (i) => (i + 1).toDouble()).map((rating) {
          return DropdownMenuItem(value: rating, child: Text('$rating Stars'));
        }).toList(),
        onChanged: (val) => setState(() => _rating = val!),
      ),
      ElevatedButton(
        onPressed: () {
          final review = CustomerReview(
            reviewerName: 'You',
            comment: _reviewController.text,
            rating: _rating,
          );
          ref.read(productReviewsProvider(product.id).notifier).addReview(review);
          _reviewController.clear();
          setState(() {
            _rating = 5.0;
          });
        },
        child: Text('Submit Review'),
      ),
    ],
  ),
),


                  // --- Reviews Section ---
                  if (product.reviews.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          product.averageRating.toStringAsFixed(1),
                          style: AppTextStyles.title,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviews.length} reviews)',
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Reviews list
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: product.reviews.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final review = product.reviews[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(review.reviewerName,
                                  style: AppTextStyles.subtitle.copyWith(
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 16,
                                    color: Colors.amber,
                                  );
                                }),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(review.comment,
                                style: AppTextStyles.subtitle),
                          ),
                        );
                      },
                    ),
                  ] else
                    const Text('No customer reviews yet.',
                        style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),

          // Fixed Add to Cart Button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDefaultBlueColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .addToCart(product.id, selectedVariant);
                       context.push('/cart');
                },
                child: Text('Add to Cart', style: AppTextStyles.button),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
