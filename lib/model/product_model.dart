class ProductModel {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    this.isFavorite = false,
  });
}
