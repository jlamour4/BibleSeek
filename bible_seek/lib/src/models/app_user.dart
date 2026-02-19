/// Backend user profile returned from POST /api/auth/session and PATCH /api/me.
class AppUser {
  const AppUser({
    required this.id,
    this.username,
    required this.name,
    required this.email,
    this.bio,
    this.location,
    this.profilePictureUrl,
    this.profilePictureCustomUrl,
  });

  final String id;
  final String? username;
  final String name;
  final String email;
  final String? bio;
  final String? location;
  final String? profilePictureUrl;
  final String? profilePictureCustomUrl;

  /// Avatar URL: custom if set, else provider photo.
  String? get avatarUrl => profilePictureCustomUrl ?? profilePictureUrl;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      bio: json['bio']?.toString(),
      location: json['location']?.toString(),
      profilePictureUrl: json['profilePictureUrl']?.toString(),
      profilePictureCustomUrl: json['profilePictureCustomUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'email': email,
        'bio': bio,
        'location': location,
        'profilePictureUrl': profilePictureUrl,
        'profilePictureCustomUrl': profilePictureCustomUrl,
      };

  AppUser copyWith({
    String? name,
    String? bio,
    String? location,
  }) {
    return AppUser(
      id: id,
      username: username,
      name: name ?? this.name,
      email: email,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      profilePictureUrl: profilePictureUrl,
      profilePictureCustomUrl: profilePictureCustomUrl,
    );
  }
}
