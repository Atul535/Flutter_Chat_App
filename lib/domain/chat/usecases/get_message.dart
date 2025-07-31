import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/domain/chat/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetMessage {
  final ChatRepository chatRepository;
  GetMessage(this.chatRepository);
  Future<Either<Failure, Stream<List<ChatModel>>>> call(
      GetMessageParams params) async {
    return await chatRepository.getMessage(
      senderId: params.senderId,
      receiverId: params.receiverId,
    );
  }
}

class GetMessageParams {
  final String senderId;
  final String receiverId;

  GetMessageParams({
    required this.senderId,
    required this.receiverId,
  });
}
