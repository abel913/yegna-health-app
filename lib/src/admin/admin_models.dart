enum AdminRole {
  superAdmin,
  contentAuthor,
  healthReviewer,
  clubCoordinator,
}

enum AccountStatus {
  active,
  suspended,
}

class ManagedUser {
  const ManagedUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.role = 'student',
    this.status = AccountStatus.active,
    required this.createdAt,
    this.joinedClubCount = 0,
    this.completedQuizzesCount = 0,
  });

  final String id;
  final String email;
  final String displayName;
  final String role; // student, mentor, content_author, admin
  final AccountStatus status;
  final DateTime createdAt;
  final int joinedClubCount;
  final int completedQuizzesCount;

  bool get isAdmin => role == 'admin' || role == 'superAdmin';

  ManagedUser copyWith({
    String? email,
    String? displayName,
    String? role,
    AccountStatus? status,
    int? joinedClubCount,
    int? completedQuizzesCount,
  }) {
    return ManagedUser(
      id: id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt,
      joinedClubCount: joinedClubCount ?? this.joinedClubCount,
      completedQuizzesCount:
          completedQuizzesCount ?? this.completedQuizzesCount,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'role': role,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'joinedClubCount': joinedClubCount,
        'completedQuizzesCount': completedQuizzesCount,
      };

  factory ManagedUser.fromJson(Map<String, Object?> json) => ManagedUser(
        id: json['id']! as String,
        email: json['email']! as String,
        displayName: json['displayName'] as String? ?? '',
        role: json['role'] as String? ?? 'student',
        status: json['status'] == 'suspended'
            ? AccountStatus.suspended
            : AccountStatus.active,
        createdAt: DateTime.parse(json['createdAt']! as String),
        joinedClubCount: json['joinedClubCount'] as int? ?? 0,
        completedQuizzesCount: json['completedQuizzesCount'] as int? ?? 0,
      );
}

class AdminDashboardMetrics {
  const AdminDashboardMetrics({
    required this.activeArticles,
    required this.learningModules,
    required this.quizQuestions,
    required this.verifiedFacilities,
    required this.counselorMentors,
    required this.studentClubs,
    required this.registeredUsers,
  });

  final int activeArticles;
  final int learningModules;
  final int quizQuestions;
  final int verifiedFacilities;
  final int counselorMentors;
  final int studentClubs;
  final int registeredUsers;
}

class AdminAuditEntry {
  const AdminAuditEntry({
    required this.id,
    required this.action,
    required this.category,
    required this.performedBy,
    required this.timestamp,
    required this.details,
  });

  final String id;
  final String action;
  final String category;
  final String performedBy;
  final DateTime timestamp;
  final String details;

  Map<String, Object?> toJson() => {
        'id': id,
        'action': action,
        'category': category,
        'performedBy': performedBy,
        'timestamp': timestamp.toIso8601String(),
        'details': details,
      };

  factory AdminAuditEntry.fromJson(Map<String, Object?> json) =>
      AdminAuditEntry(
        id: json['id']! as String,
        action: json['action']! as String,
        category: json['category']! as String,
        performedBy: json['performedBy']! as String,
        timestamp: DateTime.parse(json['timestamp']! as String),
        details: json['details']! as String,
      );
}

class AdminAccount {
  const AdminAccount({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.displayName,
    this.role = 'admin',
    this.isActive = true,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String passwordHash;
  final String displayName;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  AdminAccount copyWith({
    String? id,
    String? email,
    String? passwordHash,
    String? displayName,
    String? role,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return AdminAccount(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'email': email,
        'password_hash': passwordHash,
        'display_name': displayName,
        'role': role,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
      };

  factory AdminAccount.fromJson(Map<String, Object?> json) => AdminAccount(
        id: json['id']! as String,
        email: json['email']! as String,
        passwordHash:
            (json['password_hash'] ?? json['password']) as String? ?? '',
        displayName:
            (json['display_name'] ?? json['displayName']) as String? ?? 'Admin',
        role: json['role'] as String? ?? 'admin',
        isActive: (json['is_active'] ?? json['isActive']) as bool? ?? true,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at']! as String)
            : DateTime.now(),
      );
}
