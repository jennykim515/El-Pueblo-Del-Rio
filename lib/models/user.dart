class AppUser {
  String? username;
  String? passwordHash;
  String? name;
  String? email;
  int? userType; // 0: community member, 1: police officer

  AppUser({
    this.username,
    this.passwordHash,
    this.name,
    this.email,
    this.userType,
  });

  // Factory constructor to create a User instance from a map
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      username: json['username'],
      passwordHash: json['passwordHash'],
      name: json['name'],
      email: json['email'],
      userType: json['userType'],
    );
  }

  // Convert User object to a map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'passwordHash': passwordHash,
      'name': name,
      'email': email,
      'userType': userType,
    };
  }
}
