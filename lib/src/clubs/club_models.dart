enum ClubCategory {
  all,
  mentalHealth,
  srhWellness,
  antiSubstance,
  firstAid,
  girlsHygiene,
  peerLeadership,
}

class StudentClub {
  const StudentClub({
    required this.id,
    required this.nameEn,
    required this.nameAm,
    required this.descriptionEn,
    required this.descriptionAm,
    required this.category,
    required this.meetingScheduleEn,
    required this.meetingScheduleAm,
    required this.meetingLocationEn,
    required this.meetingLocationAm,
    required this.mentorNameEn,
    required this.mentorNameAm,
    this.mentorContact = '+251 91 123 4567',
    this.memberCount = 0,
    this.maxCapacity,
    this.rulesEn = const [
      'Maintain 100% confidentiality and respect peer privacy.',
      'Create an inclusive, judgment-free safe space.',
      'Active participation and support for all members.',
    ],
    this.rulesAm = const [
      '100% ሚስጥራዊነትን መጠበቅ እና የአቻዎችን ግላዊነት ማክበር።',
      'ከፍረጃ ነፃ የሆነ እና ሁሉን አቀፍ አስተማማኝ ቦታ መፍጠር።',
      'ንቁ ተሳትፎ እና ለሁሉም አባላት እርስ በእርስ ድጋፍ መስጠት።',
    ],
    this.isActive = true,
    this.tags = const [],
    required this.createdAt,
  });

  final String id;
  final String nameEn;
  final String nameAm;
  final String descriptionEn;
  final String descriptionAm;
  final ClubCategory category;
  final String meetingScheduleEn;
  final String meetingScheduleAm;
  final String meetingLocationEn;
  final String meetingLocationAm;
  final String mentorNameEn;
  final String mentorNameAm;
  final String mentorContact;
  final int memberCount;
  final int? maxCapacity;
  final List<String> rulesEn;
  final List<String> rulesAm;
  final bool isActive;
  final List<String> tags;
  final DateTime createdAt;

  bool get isAtCapacity => maxCapacity != null && memberCount >= maxCapacity!;

  StudentClub copyWith({
    String? nameEn,
    String? nameAm,
    String? descriptionEn,
    String? descriptionAm,
    ClubCategory? category,
    String? meetingScheduleEn,
    String? meetingScheduleAm,
    String? meetingLocationEn,
    String? meetingLocationAm,
    String? mentorNameEn,
    String? mentorNameAm,
    String? mentorContact,
    int? memberCount,
    int? maxCapacity,
    List<String>? rulesEn,
    List<String>? rulesAm,
    bool? isActive,
    List<String>? tags,
  }) {
    return StudentClub(
      id: id,
      nameEn: nameEn ?? this.nameEn,
      nameAm: nameAm ?? this.nameAm,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAm: descriptionAm ?? this.descriptionAm,
      category: category ?? this.category,
      meetingScheduleEn: meetingScheduleEn ?? this.meetingScheduleEn,
      meetingScheduleAm: meetingScheduleAm ?? this.meetingScheduleAm,
      meetingLocationEn: meetingLocationEn ?? this.meetingLocationEn,
      meetingLocationAm: meetingLocationAm ?? this.meetingLocationAm,
      mentorNameEn: mentorNameEn ?? this.mentorNameEn,
      mentorNameAm: mentorNameAm ?? this.mentorNameAm,
      mentorContact: mentorContact ?? this.mentorContact,
      memberCount: memberCount ?? this.memberCount,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      rulesEn: rulesEn ?? this.rulesEn,
      rulesAm: rulesAm ?? this.rulesAm,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'nameEn': nameEn,
        'nameAm': nameAm,
        'descriptionEn': descriptionEn,
        'descriptionAm': descriptionAm,
        'category': category.name,
        'meetingScheduleEn': meetingScheduleEn,
        'meetingScheduleAm': meetingScheduleAm,
        'meetingLocationEn': meetingLocationEn,
        'meetingLocationAm': meetingLocationAm,
        'mentorNameEn': mentorNameEn,
        'mentorNameAm': mentorNameAm,
        'mentorContact': mentorContact,
        'memberCount': memberCount,
        'maxCapacity': maxCapacity,
        'rulesEn': rulesEn,
        'rulesAm': rulesAm,
        'isActive': isActive,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
      };

  factory StudentClub.fromJson(Map<String, Object?> json) => StudentClub(
        id: json['id']! as String,
        nameEn: json['nameEn']! as String,
        nameAm: json['nameAm']! as String,
        descriptionEn: json['descriptionEn']! as String,
        descriptionAm: json['descriptionAm']! as String,
        category: ClubCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => ClubCategory.srhWellness,
        ),
        meetingScheduleEn: json['meetingScheduleEn']! as String,
        meetingScheduleAm: json['meetingScheduleAm']! as String,
        meetingLocationEn: json['meetingLocationEn']! as String,
        meetingLocationAm: json['meetingLocationAm']! as String,
        mentorNameEn: json['mentorNameEn']! as String,
        mentorNameAm: json['mentorNameAm']! as String,
        mentorContact: json['mentorContact'] as String? ?? '+251 91 123 4567',
        memberCount: json['memberCount'] as int? ?? 0,
        maxCapacity: json['maxCapacity'] as int?,
        rulesEn: (json['rulesEn'] as List<Object?>?)
                ?.map((e) => e! as String)
                .toList() ??
            const [],
        rulesAm: (json['rulesAm'] as List<Object?>?)
                ?.map((e) => e! as String)
                .toList() ??
            const [],
        isActive: json['isActive'] as bool? ?? true,
        tags: (json['tags'] as List<Object?>?)
                ?.map((e) => e! as String)
                .toList() ??
            const [],
        createdAt: DateTime.parse(json['createdAt']! as String),
      );
}

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
