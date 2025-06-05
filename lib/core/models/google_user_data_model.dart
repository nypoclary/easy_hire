class GoogleUserData {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? aboutMe;

  GoogleUserData({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.aboutMe,
  });

  factory GoogleUserData.fromJson(Map<String, dynamic> json) {
    return GoogleUserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['name'] ?? json['displayName'], // support both fields
      photoUrl: json['photoUrl'],
      aboutMe: json['aboutMe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': displayName, 
      'photoUrl': photoUrl,
      'aboutMe': aboutMe,
    };
  }
}
