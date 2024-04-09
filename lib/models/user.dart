class AppUser {
  String? id;
  String? username;
  String? passwordHash;
  String? name;
  String? email;
  String? aboutMe;
  String? userType;
  late final String? imageUrl;


  AppUser({
    this.id,
    this.username,
    this.passwordHash,
    this.name,
    this.email,
    this.userType,
    this.aboutMe,
    this.imageUrl
  });

  // Updated to include an 'id' parameter
  factory AppUser.fromJson(Map<String, dynamic> json, {String? id}) {
    return AppUser(
      id: id, // Assign the passed 'id' to the AppUser's 'id'
      username: json['username'],
      passwordHash: json['passwordHash'],
      name: json['name'],
      email: json['email'],
      userType: json['userType'],
      aboutMe: json['aboutMe'],
      imageUrl: json['imageUrl']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // Typically not necessary to include in toJson as 'id' is usually managed by Firestore
      'username': username,
      'passwordHash': passwordHash,
      'name': name,
      'email': email,
      'userType': userType,
      'aboutMe': aboutMe,
      'imageUrl': imageUrl
    };
  }
}
