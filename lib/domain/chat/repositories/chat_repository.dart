import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
import 'package:chat_app/domain/chat/entities/message_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ChatRepository {
  Future<void> sendMessage({
    required MessageEntity  content,
    required String otherUserId,
  });
  Future<Either<Failure, Stream<List<ChatModel>>>> getMessage({
    required String conversationId,
  });
  Future<Either<Failure, List<ConversationPreview>>> getConversationPreviews();
}
