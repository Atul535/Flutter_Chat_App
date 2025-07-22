import 'package:chat_app/domain/chat/entities/message_entity.dart';
import 'package:chat_app/domain/chat/repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository chatRepository;

  SendMessage(this.chatRepository);
  Future<void> call(MessageEntity message)  {
    return chatRepository.sendMessage(message);
  }
}
