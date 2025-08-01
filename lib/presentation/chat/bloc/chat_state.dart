part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoaded extends ChatState {}

final class ChatLoading extends ChatState {}

final class ConversationPreviewsLoaded extends ChatState {
  final List<ConversationPreview> previews;

  ConversationPreviewsLoaded(this.previews);
}

final class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

final class MessageSent extends ChatState {}

final class MessageReceived extends ChatState {
  final List<ChatModel> messages;

  MessageReceived(this.messages);
}
