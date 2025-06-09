class Articulo {
  final String marca;
  final String modelo;
  final int cantidad;
  final double precio;

  Articulo({
    required this.marca,
    required this.modelo,
    required this.cantidad,
    required this.precio,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      cantidad: json['existencia'] ?? 0,
      precio: (json['precio'] ?? 0).toDouble(),
    );
  }
}
