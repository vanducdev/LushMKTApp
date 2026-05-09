import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItemModel>[].obs;

  double get totalCartPrice => cartItems.fold(0, (sum, item) => sum + item.totalCost);
  int get totalCartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addProduct(ProductModel product, int qty) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity += qty;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(product: product, quantity: qty));
    }
  }

  void removeProduct(ProductModel product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
  }

  void clearCart() {
    cartItems.clear();
  }
}
