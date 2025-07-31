part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class SendMessageEvent extends ChatEvent {
  final MessageEntity message;

  SendMessageEvent({
    required this.message,
  });
}

final class LoadMessagesEvent extends ChatEvent {
  final String senderId;
  final String receiverId;

  LoadMessagesEvent({
    required this.senderId,
    required this.receiverId,
  });
}

// final class LoadConversation   PreviewsEvent extends ChatEvent {}

final class GetConversationPreviewsEvent extends ChatEvent {}
