import 'package:ecommerce/presentation/screen/cart/cart_screen.dart';
import 'package:ecommerce/presentation/screen/cart/checkout_screen.dart';
import 'package:ecommerce/presentation/screen/catalog/catalog_screen.dart';
import 'package:ecommerce/presentation/screen/catalog/product_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const CatalogScreen()),
      GoRoute(path: '/product/:id', builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailScreen(productId: id);
      }),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(path: '/checkout', builder: (context, state) => const CheckoutScreen()),
    ],
  );
});
