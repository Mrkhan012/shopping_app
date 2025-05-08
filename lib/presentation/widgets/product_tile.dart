import 'package:ecommerce/core/utils/app_decoration.dart';
import 'package:ecommerce/core/utils/app_text_styles.dart';
import 'package:ecommerce/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/product_model.dart';
class ProductTile extends StatelessWidget {
  final ProductModel product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;


    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: Container(
          decoration: AppDecoration.outlineGrayA.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product.imageUrl,
                      height: screenHeight *0.1 ,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.teal,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.title.copyWith(
                        fontSize: screenWidth > 600 ? 14 : 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: screenWidth > 600 ? 14 : 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category: ${product.category}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: screenWidth > 600 ? 14 : 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            for (int i = 0; i < 5; i++)
                              Icon(
                                i < product.averageRating
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            const SizedBox(width: 4),
                            Text(
                              product.averageRating.toStringAsFixed(1),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: screenWidth > 600 ? 16 : 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
