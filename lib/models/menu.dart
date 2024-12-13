class Menu {
  final int id;
  final String category;
  final int restaurantId; // Reference to the restaurant's ID

  Menu({
    required this.id,
    required this.category,
    required this.restaurantId,
  });

  // Factory method to parse JSON
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      category: json['category'],
      restaurantId:
          json['restaurant'], // Assuming the restaurant ID is provided
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'restaurant': restaurantId,
    };
  }
}
