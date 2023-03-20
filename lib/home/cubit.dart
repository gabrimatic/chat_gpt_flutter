// ignore_for_file: depend_on_referenced_packages

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

    const timeout = Duration(seconds: 8);

    emit(HomeStateLoading());

    Response? response;

    final messages = [
      {"role": "system", "content": "You are an AI language model."},
      {
        "role": "user",
        "content": textController.value.text,
      },
    ];

    try {
      response = await _dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // TODO: Hide token in git commits.
            'Authorization': 'Bearer [token]',
            // TODO: Hide OpenAI-Organization in git commits.
            'OpenAI-Organization': '[id]'
          },
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
        data: {
          "model": "gpt-3.5-turbo",
          "messages": messages,
          "temperature": 0.8,
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
