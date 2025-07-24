// // lib/domain/chat/usecases/get_conversation_previews.dart

// import 'package:chat_app/core/utils/failure.dart';
// import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
// import 'package:chat_app/domain/chat/repositories/chat_repository.dart';
// import 'package:fpdart/fpdart.dart';

// class GetConversationPreviews {
//   final ChatRepository repo;
//   GetConversationPreviews(this.repo);

//   Future<Either<Failure, List<ConversationPreview>>> call(GetConversationPreviewsParams params) {
//     return repo.getConversationPreviews(params.myUserId);
//   }
// }
// class GetConversationPreviewsParams {
//   final String myUserId;

//   GetConversationPreviewsParams({required this.myUserId});
// }