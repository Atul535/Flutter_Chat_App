import 'dart:async';

import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
import 'package:chat_app/domain/chat/entities/message_entity.dart';
import 'package:chat_app/domain/chat/usecases/get_conversation_previews.dart';
import 'package:chat_app/domain/chat/usecases/get_message.dart';
import 'package:chat_app/domain/chat/usecases/send_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessage _getMessage;
  final SendMessage _sendMessage;
  final GetConversationPreviews _getConversationPreviews;
  StreamSubscription<List<ChatModel>>? _messagesSub;
  ChatBloc({
    required GetMessage getMessage,
    required SendMessage sendMessage,
    required GetConversationPreviews getConversationPreviews,
  })  : _getMessage = getMessage,
        _sendMessage = sendMessage,
        _getConversationPreviews = getConversationPreviews,
        super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    // Handle sending messages
    on<SendMessageEvent>(_onSendMessage);
    // Handle loading conversation previews
    on<GetConversationPreviewsEvent>(_onLoadConversationPreviews);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoaded());

    // Cancel previous subscription if any
    await _messagesSub?.cancel();

    try {
      final result = await _getMessage(
        GetMessageParams(
          senderId: event.senderId,
          receiverId: event.receiverId,
        ),
      );
      result.fold(
        (failure) {
          emit(ChatError('Failed to load messages: ${failure.message}'));
        },
        (messagesStream) {
          _messagesSub = messagesStream.listen((messages) {
            emit(MessageReceived(messages));
          });
        },
      );
    } catch (e) {
      emit(ChatError('Failed to load messages: $e'));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _sendMessage(event.message);
      emit(MessageSent());
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }

  Future<void> _onLoadConversationPreviews(  
    GetConversationPreviewsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final result = await _getConversationPreviews();
      result.fold(
        (failure) {
          emit(ChatError(
              'Failed to load conversation previews: ${failure.message}'));
        },
        (previews) {
          emit(ConversationPreviewsLoaded(previews));
        },
      );
    } catch (e) {
      emit(ChatError('Failed to load conversation previews: $e'));
    }
  }
}
