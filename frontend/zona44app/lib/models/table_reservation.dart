class TableReservation {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final DateTime date;
  final String time;
  final int peopleCount;
  final String comments;
  final String status; // 'pendiente', 'confirmada', 'cancelada'
  final int? userId;
  final DateTime? createdAt;

  TableReservation({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.date,
    required this.time,
    required this.peopleCount,
    this.comments = '',
    this.status = 'pendiente',
    this.userId,
    this.createdAt,
  });

  factory TableReservation.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    try {
      if (json['created_at'] != null &&
          json['created_at'].toString().isNotEmpty) {
        createdAt = DateTime.tryParse(json['created_at'].toString());
      }
    } catch (_) {
      createdAt = null;
    }

    DateTime date;
    try {
      date = DateTime.parse(json['date'].toString());
    } catch (_) {
      date = DateTime.now();
    }

    return TableReservation(
      id: json['id'],
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      date: date,
      time: json['time']?.toString() ?? '',
      peopleCount: json['people_count'] ?? 1,
      comments: json['comments']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pendiente',
      userId: json['user_id'],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'date': date.toIso8601String().split('T')[0], // Solo la fecha YYYY-MM-DD
      'time': time,
      'people_count': peopleCount,
      'comments': comments,
    };
  }
}
