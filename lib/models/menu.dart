class Menu {
  final int id;
  final String category;
  final int? restaurantId; // Allow this field to be nullable

  Menu({
    required this.id,
    required this.category,
    this.restaurantId, // Nullable field
  });

  // Factory method to parse JSON
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] ?? 0, // Default to 0 if null
      category: json['category'] ?? 'Unknown', // Default to "Unknown" if null
      restaurantId: json['restaurant'], // Allow null for restaurantId
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
