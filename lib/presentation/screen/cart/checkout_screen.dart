import 'package:ecommerce/core/utils/colros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_providers.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final products = ref.watch(productListProvider);

    double subtotal = 0.0;

    for (var item in cartItems) {
      final product = products.firstWhere(
        (p) => p.id == item.productId,
        orElse: () => throw Exception('Product not found'),
      );
      subtotal += product.price * item.quantity;
    }

    const double shipping = 50.0;
    final double tax = subtotal * 0.18;
    final double total = subtotal + tax + shipping;

    return Scaffold(
            backgroundColor: kAppBackgroundColor,

      appBar: AppBar(
        backgroundColor: kDefaultBlueColor,
        title: const Text('Checkout', style: TextStyle(color: kAppBrightWhiteColor),),
       
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, index) {
                  final item = cartItems[index];
                  final product = products.firstWhere(
                    (p) => p.id == item.productId,
                    orElse: () => throw Exception('Product not found'),
                  );
                  return ListTile(
                    title: Text('${product.name} (${item.variant})'),
                    subtitle: Text('₹${product.price.toStringAsFixed(2)} x ${item.quantity}'),
                    trailing: Text('₹${(product.price * item.quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('₹${subtotal.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tax (18%)'),
                Text('₹${tax.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Shipping'),
                Text('₹${shipping.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order Placed!')),
                  );
                        context.go('/');

                },
                 style: ElevatedButton.styleFrom(
                  backgroundColor: kDefaultBlueColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Place Order',
                style: TextStyle(color: kAppBrightWhiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
