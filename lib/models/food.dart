class Food {
  final int id;
  final int? menuId; // Nullable because it can be null in the Django model
  final String name;
  final String price;

  Food({
    required this.id,
    this.menuId,
    required this.name,
    required this.price,
  });

  // Factory method to parse JSON
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      menuId: json['menu'], // Assuming the menu ID is provided
      name: json['name'],
      price: json['price'],
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu': menuId,
      'name': name,
      'price': price,
    };
  }
}
