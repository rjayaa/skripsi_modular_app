class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? avatarUrl;
  final String role;
  final String status;
  final String createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.address,
    this.avatarUrl,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      avatarUrl: json['avatar_url'],
      role: json['role'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
