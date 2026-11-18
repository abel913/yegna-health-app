class ClubMembership {
  const ClubMembership({
    required this.clubId,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.joinedAt,
    this.role = 'member',
  });

  final String clubId;
  final String userId;
  final String userEmail;
  final String userName;
  final DateTime joinedAt;
  final String role; // member, lead

  ClubMembership copyWith({
    String? clubId,
    String? userId,
    String? userEmail,
    String? userName,
    DateTime? joinedAt,
    String? role,
  }) =>
      ClubMembership(
        clubId: clubId ?? this.clubId,
        userId: userId ?? this.userId,
        userEmail: userEmail ?? this.userEmail,
        userName: userName ?? this.userName,
        joinedAt: joinedAt ?? this.joinedAt,
        role: role ?? this.role,
      );

  Map<String, Object?> toJson() => {
        'clubId': clubId,
        'userId': userId,
        'userEmail': userEmail,
        'userName': userName,
        'joinedAt': joinedAt.toIso8601String(),
        'role': role,
      };

  factory ClubMembership.fromJson(Map<String, Object?> json) => ClubMembership(
        clubId: json['clubId']! as String,
        userId: json['userId']! as String,
        userEmail: json['userEmail']! as String,
        userName: json['userName'] as String? ?? '',
        joinedAt: DateTime.parse(json['joinedAt']! as String),
        role: json['role'] as String? ?? 'member',
      );
}
