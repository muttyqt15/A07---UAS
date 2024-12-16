class Restaurant {
  final int id;
  final String name;
  final String district;
  final String address;
  final String operationalHours;
  final String photoUrl;

  Restaurant({
    this.id = 0,
    this.name = 'Unknown',
    this.district = 'Unknown',
    this.address = 'Unknown',
    this.operationalHours = 'Unknown',
    this.photoUrl = '',
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['pk'] ?? 0,
      name: json['fields']?['name'] ?? 'Unknown',
      district: json['fields']?['district'] ?? 'Unknown',
      address: json['fields']?['address'] ?? 'Unknown',
      operationalHours: json['fields']?['operational_hours'] ?? 'Unknown',
      photoUrl: json['fields']?['photo_url'] ?? '',
    );
  }
}
