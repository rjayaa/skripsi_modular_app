class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final String createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      role: json['role'],
      createdAt: json['created_at'],
    );
  }
}
