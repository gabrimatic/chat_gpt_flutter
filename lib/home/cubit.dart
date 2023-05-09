// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:chat_gpt_flutter/chat_gpt_model/chat_gpt_model.dart';
import 'package:chat_gpt_flutter/chat_gpt_model/messages.dart';
import 'package:chat_gpt_flutter/error_model/error_model.dart';
import 'package:chat_gpt_flutter/values/consts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _isMock = false;

class HomeState {}

class HomeStateInit extends HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateError extends HomeState {
  final String? errorMessage;
  final ErrorModel? errorModel;

  HomeStateError({this.errorMessage, this.errorModel});
}

class HomeStateLoaded extends HomeState {
  final ChatGptModel chatGptModel;

  HomeStateLoaded(this.chatGptModel);
}

class HomeCubit extends Cubit<HomeState> {
  final textController = TextEditingController();
  final _dio = Dio();
  int editingIndex = -1;

  // Initialize the conversation history
  List<MessagesModel> messages = [];

  HomeCubit() : super(HomeStateInit());

  void onEdit(int index) {
    editingIndex = index;
    textController.text = messages[index].content;
    textController.selection = TextSelection.fromPosition(TextPosition(
      offset: messages[index].content.length,
    ));
  }

  Future<void> sendRequest() async {
    if (_isMock) {
      _mockSendRequest();
      return;
    }

    if (textController.value.text.isEmpty) return;

    const timeout = Duration(seconds: 8);

    emit(HomeStateLoading());

    Response? response;

    // Add the user's message to the conversation history
    if (editingIndex > -1) {
      messages = [
        ...messages.sublist(0, editingIndex),
        MessagesModel(role: Role.user, content: textController.value.text),
      ];
    } else {
      messages.add(
        MessagesModel(role: Role.user, content: textController.value.text),
      );
    }

    try {
      response = await _dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // TODO: Hide token in git commits.
            'Authorization': 'Bearer [token]',
          },
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        data: {
          "model": GptModels.gpt4.name,
          "messages": MessagesModel.listToMapList(messages),
          "temperature": 0.8,
          "max_tokens": 2048,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        // Extract the assistant's message from the response
        String assistantMessage =
            response.data['choices'][0]['message']['content'];

        // Add the assistant's message to the conversation history
        messages.add(
          MessagesModel(role: Role.assiatant, content: assistantMessage),
        );

        textController.clear();

        emit(HomeStateLoaded(ChatGptModel.fromMap(response.data)));
      } else {
        emit(HomeStateError(errorModel: ErrorModel.fromMap(response.data)));
        debugPrint('=== Error: ${response.data} ===');
      }
    } catch (e) {
      emit(HomeStateError(errorMessage: e.toString()));
      debugPrint('=== Error: $e ===');
    } finally {
      editingIndex = -1;
    }
  }

  Future<void> _mockSendRequest() async {
    if (textController.value.text.isEmpty) return;

    emit(HomeStateLoading());

    // Add the user's message to the conversation history
    if (editingIndex > -1) {
      messages = [
        ...messages.sublist(0, editingIndex),
        MessagesModel(role: Role.user, content: textController.value.text),
      ];
    } else {
      messages.add(
        MessagesModel(role: Role.user, content: textController.value.text),
      );
    }

    try {
      // Mock response data
      Map<String, dynamic> mockResponseData = {
        'id': 'chatcmpl-7Dj3pSbOk2ZAS3O06Wg47NSoIxIL8',
        'object': 'chat.completion',
        'created': 1683505833,
        'model': 'gpt-4-0314',
        'choices': [
          {
            'message': {
              'content':
                  'This is a mock response from the AI assistant. How can I help you?',
            },
          },
        ],
        'usage': {
          'prompt_tokens': 11,
          'completion_tokens': 23,
          'total_tokens': 34,
        },
      };

      // Extract the assistant's message from the response
      String assistantMessage =
          mockResponseData['choices'][0]['message']['content'];

      // Add the assistant's message to the conversation history
      messages.add(
        MessagesModel(role: Role.assiatant, content: assistantMessage),
      );

      textController.clear();

      emit(HomeStateLoaded(ChatGptModel.fromMap(mockResponseData)));
    } catch (e) {
      emit(HomeStateError(errorMessage: e.toString()));
      debugPrint(e.toString());
    }
  }
}
