class Restaurant {
  final int id;
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
    final fields = json['fields'] ?? {}; // Extract fields safely
    return Restaurant(
      id: json['pk'] ?? 0, // Use "pk" or default to 0 if null
      name: fields['name'] ?? 'Unknown', // Handle null gracefully
      district: fields['district'] ?? 'Unknown',
      address: fields['address'] ?? 'Unknown',
      operationalHours: fields['operational_hours'] ?? 'Unknown',
      photoUrl: fields['photo_url'] ?? '',
    );
  }
}
