class Car {
  final String name;
  final String image;
  final String category;
  final String price;
  final String address;
  final List<String> features; // <-- replace details with this

  Car({
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.address,
    required this.features, // <-- new required field
  });
}
