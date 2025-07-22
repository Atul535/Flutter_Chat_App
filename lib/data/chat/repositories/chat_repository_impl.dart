// import 'package:chat_app/core/utils/failure.dart';
// import 'package:chat_app/data/chat/datasource/chat_remote_data_source_impl.dart';
// import 'package:chat_app/data/chat/model/chat_model.dart';
// import 'package:chat_app/domain/chat/entities/message_entity.dart';
// import 'package:chat_app/domain/chat/repositories/chat_repository.dart';
// import 'package:fpdart/fpdart.dart';

// class ChatRepositoryImpl implements ChatRepository {
//   final ChatRemoteDataSource chatRemoteDataSource;

//   ChatRepositoryImpl(this.chatRemoteDataSource);
//   @override
//   Future<Either<Failure, Stream<List<ChatModel>>>> getMessage({
//     required String senderId,
//     required String receiverId,
//   }) async {
//     try {
//       final messages = chatRemoteDataSource.getMessages(
//         senderId: senderId,
//         receiverId: receiverId,
//       );
//       return Right(messages);
//     } catch (e) {
//       return Left(Failure(e.toString()));
//     }
//   }

//   @override
//   Future<void> sendMessage(MessageEntity message) async {
//     try {
//       if (message is! ChatModel) {
//         throw Failure("Invalid message type");
//       }
//       await chatRemoteDataSource.sendMessage(ChatModel(
//         id: message.id,
//         senderId: message.senderId,
//         receiverId: message.receiverId,
//         message: message.message,
//         timestamp: message.timestamp,
//       ));
//       throw Right(null);
//     } catch (e) {
//       throw Failure(e.toString());
//     }
//   }
// }

import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/data/chat/datasource/chat_remote_data_source_impl.dart';
import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/domain/chat/entities/message_entity.dart';
import 'package:chat_app/domain/chat/repositories/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;

  ChatRepositoryImpl(this.chatRemoteDataSource);

  @override
  Future<Either<Failure, Stream<List<ChatModel>>>> getMessage({
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final messages = chatRemoteDataSource.getMessages(
        senderId: senderId,
        receiverId: receiverId,
      );
      return Right(messages);
    } catch (e) {
      return Left(Failure('Get message failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(MessageEntity message) async {
    try {
      if (message is! ChatModel) {
        return Left(Failure("Invalid message type"));
      }

      await chatRemoteDataSource.sendMessage(message);
      return Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
