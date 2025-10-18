class Order {
  final int id;
  final String orderNumber;
  final String status;
  final String deliveryType;
  final double totalAmount;
  final DateTime? createdAt;
  final List<OrderItem> orderItems;
  final OrderUser? user;
  // Nuevos campos para datos de cliente sin usuario autenticado
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final String customerCity;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.deliveryType,
    required this.totalAmount,
    required this.createdAt,
    required this.orderItems,
    this.user,
    this.customerName = '',
    this.customerEmail = '',
    this.customerPhone = '',
    this.customerAddress = '',
    this.customerCity = '',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    try {
      if (json['created_at'] != null &&
          json['created_at'].toString().isNotEmpty) {
        createdAt = DateTime.tryParse(json['created_at'].toString());
      }
    } catch (_) {
      createdAt = null;
    }
    return Order(
      id: json['id'] ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      deliveryType: json['delivery_type']?.toString() ?? '',
      totalAmount: (json['total_amount'] is num)
          ? (json['total_amount'] as num).toDouble()
          : double.tryParse(json['total_amount']?.toString() ?? '') ?? 0.0,
      createdAt: createdAt,
      orderItems:
          (json['order_items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      user: json['user'] != null ? OrderUser.fromJson(json['user']) : null,
      customerName: json['customer_name']?.toString() ?? '',
      customerEmail: json['customer_email']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      customerAddress: json['customer_address']?.toString() ?? '',
      customerCity: json['customer_city']?.toString() ?? '',
    );
  }
}

class OrderUser {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  OrderUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  factory OrderUser.fromJson(Map<String, dynamic> json) {
    return OrderUser(
      id: json['id'] ?? 0,
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
    );
  }
}

class OrderItem {
  final int id;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Producto producto;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.producto,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Debug: Imprimir el JSON del item
    print('🔍 OrderItem JSON: $json');

    return OrderItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unit_price'] is num)
          ? (json['unit_price'] as num).toDouble()
          : double.tryParse(json['unit_price']?.toString() ?? '') ?? 0.0,
      totalPrice: (json['total_price'] is num)
          ? (json['total_price'] as num).toDouble()
          : double.tryParse(json['total_price']?.toString() ?? '') ?? 0.0,
      producto: json['producto'] != null
          ? Producto.fromJson(json['producto'])
          : Producto.empty(),
    );
  }
}

class Producto {
  final int id;
  final String name;
  final double precio;
  final String descripcion;

  Producto({
    required this.id,
    required this.name,
    required this.precio,
    required this.descripcion,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    // Debug: Imprimir el JSON del producto
    print('🔍 Producto JSON: $json');

    return Producto(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      precio: (json['precio'] is num)
          ? (json['precio'] as num).toDouble()
          : double.tryParse(json['precio']?.toString() ?? '') ?? 0.0,
      descripcion: json['descripcion']?.toString() ?? '',
    );
  }

  factory Producto.empty() =>
      Producto(id: 0, name: '', precio: 0.0, descripcion: '');
}
