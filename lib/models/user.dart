class Restaurant {
  final int id; // Ensure this matches the type of "pk" in JSON
  final String name;
  final String district;
  final String address;
  final String operationalHours;
  final String photoUrl;

  Restaurant({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.operationalHours,
    required this.photoUrl,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] ?? {};

    return Restaurant(
      id: json['pk'] ?? 0,
      name: fields['name'] ?? 'Unknown', // Default to 'Unknown' if null
      district: fields['district'] ?? 'Unknown', // Default to 'Unknown'
      address: fields['address'] ?? 'Unknown',
      operationalHours: fields['operational_hours'] ?? 'Unknown',
      photoUrl: fields['photo_url'] ?? '', // Default to empty string
    );
  }
}
