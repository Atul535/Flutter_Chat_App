import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/data/chat/datasource/chat_remote_data_source_impl.dart';
import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
import 'package:chat_app/domain/chat/entities/message_entity.dart';
import 'package:chat_app/domain/chat/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;

  ChatRepositoryImpl(this.chatRemoteDataSource);

  @override
  Future<Either<Failure, Stream<List<ChatModel>>>> getMessage({
    required String conversationId,
  }) async {
    try {
      final messages = chatRemoteDataSource.getMessages(
        conversationId: conversationId,
      );
      return Right(messages);
    } catch (e) {
      return Left(Failure('Get message failed: $e'));
    }
  }

  @override
 @override
Future<void> sendMessage({
  required MessageEntity content,
  required String otherUserId,
}) async {
  final chatModel = ChatModel(
    id: content.id,
    senderId: content.senderId,
    receiverId: content.receiverId,
    conversationId: content.conversationId,
    content: content.content,
    timestamp: content.timestamp,
  );

  await chatRemoteDataSource.sendMessage(
    message: chatModel,
    otherUserId: otherUserId,
  );
}



  @override
  Future<Either<Failure, List<ConversationPreview>>>
      getConversationPreviews() async {
    try {
      final previews = await chatRemoteDataSource.getConversationPreviews();
      return Right(previews);
    } catch (e) {
      return Left(Failure('Get conversation previews failed: $e'));
    }
  }
}
