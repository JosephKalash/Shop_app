import 'cartItem.dart';

class OrderItem {
  final String id;
  final double totalPrice;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem.name(
      this.id,
      this.totalPrice,
      this.products,
      this.orderDate,
      );
}