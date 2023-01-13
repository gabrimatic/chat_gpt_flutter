import 'package:center_the_widgets/center_the_widgets.dart';
import 'package:chat_gpt_flutter/home/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

import 'home/view.dart';

void main() {
  setPathUrlStrategy();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => HomeCubit(),
        child: const CenterTheWidgets(child: HomeView()),
      ),
    ),
  );
}
