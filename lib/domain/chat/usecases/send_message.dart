
import 'package:chat_app/domain/chat/entities/message_entity.dart';
import 'package:chat_app/domain/chat/repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository chatRepository;
  SendMessage(this.chatRepository);

  Future<void> call(SendMessageParams params ) async {
    return await chatRepository.sendMessage(
      content: params.content,
      otherUserId: params.otherUserId,
    );
  }
}

class SendMessageParams {
  final MessageEntity  content;
  final String otherUserId;

  SendMessageParams({
    required this.content,
    required this.otherUserId,
  });
}
