class ClubAnnouncement {
  const ClubAnnouncement({
    required this.id,
    required this.clubId,
    required this.title,
    required this.content,
    this.type = 'general',
    this.isPinned = false,
    this.authorName = 'Club Coordinator',
    required this.createdAt,
  });

  final String id;
  final String clubId;
  final String title;
  final String content;
  final String type;
  final bool isPinned;
  final String authorName;
  final DateTime createdAt;

  bool get isUrgent => type == 'urgent';
  bool get isVenueChange => type == 'venue_change';
  bool get isEvent => type == 'event';

  Map<String, dynamic> toJson() => {
        'id': id,
        'clubId': clubId,
        'title': title,
        'content': content,
        'type': type,
        'isPinned': isPinned,
        'authorName': authorName,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ClubAnnouncement.fromJson(Map<String, dynamic> json) {
    return ClubAnnouncement(
      id: json['id'] as String? ?? 'ann_${DateTime.now().millisecondsSinceEpoch}',
      clubId: json['clubId'] as String? ?? '',
      title: json['title'] as String? ?? 'Notice',
      content: json['content'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      isPinned: json['isPinned'] as bool? ?? false,
      authorName: json['authorName'] as String? ?? 'Club Coordinator',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String formattedDate() {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 60) {
      final mins = diff.inMinutes.clamp(1, 59);
      return '${mins}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }
}
