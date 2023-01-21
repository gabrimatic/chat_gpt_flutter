import 'dart:html' as html show window;

import 'package:chat_gpt_flutter/home/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('ChatGPT Flutter'),
        leading: IconButton(
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: 'ChatGPT Flutter',
              applicationVersion: 'v0.7',
              applicationLegalese: '',
              applicationIcon: const FlutterLogo(),
              children: [
                ListTile(
                  title: const Text('By Hossein Yousefpour'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    html.window.open(
                      'https://gabrimatic.info/',
                      '_blank',
                    );
                  },
                ),
              ],
            );
          },
          icon: const Icon(Icons.info_outline_rounded),
        ),
        actions: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeStateLoaded) {
                return IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                      text: state.chatGptModel.result,
                    )).whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.blueGrey,
                            content: Text(
                              'Result has been copied to the clipboard.',
                            )),
                      );
                    });
                  },
                  icon: const Icon(Icons.copy),
                );
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
      bottomSheet: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 0.2,
              spreadRadius: 0.2,
              color: Colors.black12,
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          maxLines: 2,
          focusNode: FocusNode(
            onKey: (FocusNode node, RawKeyEvent evt) {
              if (evt.isShiftPressed &&
                  evt.isKeyPressed(LogicalKeyboardKey.enter)) {
                if (evt is RawKeyDownEvent) {
                  context.read<HomeCubit>().sendRequest();
                }
                return KeyEventResult.handled;
              } else {
                return KeyEventResult.ignored;
              }
            },
          ),
          controller: context.read<HomeCubit>().textController,
          decoration: InputDecoration(
              label: const Text('What\'s on your mind...?'),
              suffixIcon: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
                onPressed: context.read<HomeCubit>().sendRequest,
                icon: const Icon(Icons.search_rounded),
                label: const Text('Answer!'),
              )),
        ),
      ),
      body: Center(
        child: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 64),
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeStateInit) {
                    return const Center(
                      child: Text(
                        'Hint: To submit, simply press Shift-Enter!',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 2,
                          color: Colors.black26,
                        ),
                      ),
                    );
                  }

                  if (state is HomeStateLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.purple,
                        ),
                      ),
                    );
                  }

                  String text = '';
                  if (state is HomeStateLoaded) {
                    text = state.chatGptModel.result;
                  } else if (state is HomeStateError) {
                    text = 'IDK!';
                  }

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SelectableText(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
