// ignore_for_file: depend_on_referenced_packages

import 'package:center_the_widgets/center_the_widgets.dart';
import 'package:chat_gpt_flutter/home/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

import 'home/view.dart';

void main() {
  setPathUrlStrategy();

  final themeData = ThemeData.light();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => HomeCubit(),
        child: const CenterTheWidgets(
          /// This color has also suggested by ChatGPT!
          color: Color(0XFFA8DADC),
          child: HomeView(),
        ),
      ),
      theme: themeData.copyWith(
        splashColor: Colors.blueGrey,
        primaryColor: Colors.blueGrey,
        focusColor: Colors.blueGrey,
        primaryColorDark: Colors.blueGrey,
        hintColor: Colors.blueGrey,
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.blueGrey),
          focusColor: Colors.blueGrey,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
    ),
  );
}
