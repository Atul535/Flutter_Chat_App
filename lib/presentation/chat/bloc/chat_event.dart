part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class SendMessageEvent extends ChatEvent {
  final MessageEntity content;
  final String
      otherUserId; // Added to ensure repository can validate participants

  SendMessageEvent({
    required this.content,
    required this.otherUserId,
  });
}

final class LoadMessagesEvent extends ChatEvent {
  final String conversationId;

  LoadMessagesEvent({
    required this.conversationId,
  });
}

// final class LoadConversation   PreviewsEvent extends ChatEvent {}

final class GetConversationPreviewsEvent extends ChatEvent {}
