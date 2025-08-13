// class ConversationPreview {
//   final String conversationId;
//   final String contactId;
//   final String contactName;
//   final String contactEmail;
//   final String? avatarUrl;
//   final String lastMessage;
//   final String lastMessageTime;
//   final String currentUserId;

//   ConversationPreview({
//     required this.conversationId,
//     required this.contactId,
//     required this.contactName,
//     required this.contactEmail,
//     required this.lastMessage,
//     required this.lastMessageTime,
//     this.avatarUrl,
//     required this.currentUserId,
//   });
// }

class ConversationPreview {
  final String conversationId;
  final String receiverId; // Add this
  final String receiverName; // Renamed from contactName
  final String receiverEmail; // Renamed from contactEmail
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