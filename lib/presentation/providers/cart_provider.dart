import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/cart_item_model.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  void addToCart(String productId, String variant) {
    final index = state.indexWhere(
        (item) => item.productId == productId && item.variant == variant);

    if (index == -1) {
      state = [
        ...state,
        CartItemModel(productId: productId, variant: variant, quantity: 1)
      ];
    } else {
      final updatedItem = state[index];
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            CartItemModel(
              productId: updatedItem.productId,
              variant: updatedItem.variant,
              quantity: updatedItem.quantity + 1,
            )
          else
            state[i]
      ];
    }
  }

  void removeFromCart(String productId, String variant) {
    state = state
        .where((item) => !(item.productId == productId && item.variant == variant))
        .toList();
  }

  void clearCart() {
    state = [];
  }

  // Update the quantity of a product in the cart
  void updateQuantity(String productId, String variant, int newQuantity) {
    final index = state.indexWhere(
        (item) => item.productId == productId && item.variant == variant);

    if (index != -1) {
      final updatedItem = state[index];
      if (newQuantity > 0) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index)
              CartItemModel(
                productId: updatedItem.productId,
                variant: updatedItem.variant,
                quantity: newQuantity,
              )
            else
              state[i]
        ];
      } else {
        removeFromCart(productId, variant);
      }
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});
