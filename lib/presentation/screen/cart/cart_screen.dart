import 'package:ecommerce/core/utils/app_text_styles.dart';
import 'package:ecommerce/core/utils/colros.dart';
import 'package:ecommerce/presentation/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final products = ref.watch(productListProvider);

    double total = 0.0;

    // Calculate the total before rendering the UI
    for (var item in cartItems) {
      final product = products.firstWhere(
        (p) => p.id == item.productId,
        orElse: () => throw Exception('Product not found'),
      );
      total += product.price * item.quantity;
    }

    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kAppBrightWhiteColor),
        backgroundColor: kDefaultBlueColor,
        title: const Text(
          'Cart',
          style: TextStyle(color: kAppBrightWhiteColor),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, index) {
                final item = cartItems[index];
                final product = products.firstWhere(
                  (p) => p.id == item.productId,
                  orElse: () => throw Exception('Product not found'),
                );
                final itemTotal = product.price * item.quantity;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(product.imageUrl,
                          width: 60, height: 60, fit: BoxFit.cover),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: AppTextStyles.subtitle.copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Variant: ${item.variant}'),
                            Text('Qty: ${item.quantity}'),
                            Text('Price: ₹${itemTotal.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    ref
                                        .read(cartProvider.notifier)
                                        .updateQuantity(
                                          item.productId,
                                          item.variant,
                                          item.quantity - 1,
                                        );
                                  }
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(
                                        item.productId,
                                        item.variant,
                                        item.quantity + 1,
                                      );
                                },
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref.read(cartProvider.notifier).removeFromCart(
                                    item.productId,
                                    item.variant,
                                  );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total: ₹${total.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                context.go('/checkout');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kDefaultBlueColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(color: kAppBrightWhiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
