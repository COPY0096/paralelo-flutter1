//lib/productos/producto.dart
class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
    };
  }

  // Método para verificar si hay stock suficiente
  bool tieneStock(int cantidad) {
    return stock >= cantidad;
  }

  // Método para obtener el stock como string formateado
  String get stockFormatted {
    if (stock <= 0) return "Sin stock";
    if (stock <= 5) return "Stock bajo ($stock)";
    return "Stock: $stock";
  }

  // Método para verificar si el producto está agotado
  bool get estaAgotado => stock <= 0;

  // Método para verificar si el stock está bajo (menos de 5 unidades)
  bool get stockBajo => stock > 0 && stock <= 5;

  // Copiar con nuevos valores (útil para actualizaciones)
  Producto copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    double? precio,
    int? stock,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
    );
  }

  @override
  String toString() {
    return 'Producto(id: $id, nombre: $nombre, precio: $precio, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Producto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}