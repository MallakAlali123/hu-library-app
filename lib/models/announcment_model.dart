class AnnouncementModel {
  final String announcementId;
  final String title;
  final String content;
  final String createdAt;
  final String createdBy;

  AnnouncementModel({
    required this.announcementId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.createdBy,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map, String id) {
    return AnnouncementModel(
      announcementId: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] ?? '',
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}