class CartItem {
  final int id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    name: json['name'],
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
  };
}
