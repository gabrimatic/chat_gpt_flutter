import 'dart:io';

import 'package:chat_gpt_flutter/chat_gpt_model/chat_gpt_model.dart';
import 'package:chat_gpt_flutter/error_model/error_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  HomeCubit() : super(HomeStateInit());

  Future<void> sendRequest() async {
    if (textController.value.text.isEmpty) return;

    // In seconds
    const timeout = 8;

    emit(HomeStateLoading());

    Response? response;

    try {
      response = await _dio.post(
        'https://api.openai.com/v1/completions',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // TODO: Hide token in git commits.
            'Authorization': 'Bearer [token]',
            'OpenAI-Organization': 'org-XOBjcsC2BCIwI3fVhUbZ7q11'
          },
          sendTimeout: timeout * 1000,
          receiveTimeout: timeout * 1000,
        ),
        data: {
          "model": "text-davinci-003",
          "prompt": textController.value.text,
          "temperature": 1,
          "max_tokens": 2048,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        emit(HomeStateLoaded(ChatGptModel.fromMap(response.data)));
      } else {
        emit(HomeStateError(errorModel: ErrorModel.fromMap(response.data)));
      }
    } catch (e) {
      emit(HomeStateError(errorMessage: e.toString()));
    }
  }
}
