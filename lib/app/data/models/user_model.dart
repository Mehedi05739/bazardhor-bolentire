/// Authenticated user returned by `/api/auth/login`.
class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    this.avatar,
    this.userType,
    this.status,
    this.isActive = false,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String? avatar;
  final String? userType;
  final String? status;
  final bool isActive;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: '${json['id'] ?? ''}',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatar: json['avatar'] as String?,
      userType: json['user_type'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'name': name,
    'username': username,
    'email': email,
    'phone': phone,
    'avatar': avatar,
    'user_type': userType,
    'status': status,
    'is_active': isActive,
  };
}
