class ConversationPreview {
  final String contactId;
  final String contactName;
  final String contactEmail;
  final String? avatarUrl;
  final String lastMessage;
  final String lastMessageTime;
  final String currentUserId;

  ConversationPreview({
    required this.contactId,
    required this.contactName,
    required this.contactEmail,
    required this.lastMessage,
    required this.lastMessageTime,
    this.avatarUrl,
    required this.currentUserId,
  });
}
