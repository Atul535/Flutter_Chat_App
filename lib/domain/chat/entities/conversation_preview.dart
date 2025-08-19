class ConversationPreview {
  final String conversationId;
  final String receiverId;
  final String receiverName;
  final String receiverEmail;
  final String lastMessage;
  final dynamic lastMessageTime;
  final String avatarUrl;
  final String currentUserId;

  ConversationPreview({
    required this.conversationId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarUrl,
    required this.currentUserId,
  });
}