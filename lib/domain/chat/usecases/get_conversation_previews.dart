import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
import 'package:chat_app/domain/chat/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetConversationPreviews {
  final ChatRepository repository;

  GetConversationPreviews(this.repository);

  Future<Either<Failure, List<ConversationPreview>>> call() async {
    return await repository.getConversationPreviews();
  }
}
