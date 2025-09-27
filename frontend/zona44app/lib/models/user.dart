class User {
  final int? id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;
  final String? city;
  final String? department;

  User({
    this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.city,
    this.department,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'address': address,
      'city': city,
      'department': department,
    };
  }
}
