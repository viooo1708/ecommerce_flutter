//
// class Product {
//   final int id;
//   final String name;
//   final double price;
//   final String description;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.description,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       price: json['price'].toDouble(),
//       description: json['Description'],
//     );
//   }
// }

class Product {
  final int? id; // nullable
  final String name;
  final double price;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  /// ===============================
  /// BACKEND → FLUTTER
  /// ===============================
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
    );
  }

  /// ===============================
  /// FLUTTER → BACKEND
  /// ===============================
  Map<String, dynamic> toJson({bool includeId = false}) {
    final data = {
      'name': name,
      'price': price,
      'description': description,
    };

    if (includeId && id != null) {
      data['id'] = id!; // ⚡ paksa non-null
    }

    return data;
  }
}
