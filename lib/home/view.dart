// ignore_for_file: avoid_web_libraries_in_flutter, depend_on_referenced_packages

import 'dart:html' as html show window;

import 'package:chat_gpt_flutter/chat_gpt_model/messages.dart';
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
              applicationVersion: 'chatGPT model: gpt-4',
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
          minLines: 2,
          maxLines: 6,
          focusNode: FocusNode(
            onKey: (FocusNode node, RawKeyEvent evt) {
              if (evt.isKeyPressed(LogicalKeyboardKey.enter)) {
                if (evt is RawKeyDownEvent) {
                  if (evt.isShiftPressed) {
                    // Add newline
                    final newText =
                        '${context.read<HomeCubit>().textController.text}\n';
                    final newCaretPosition = context
                            .read<HomeCubit>()
                            .textController
                            .selection
                            .baseOffset +
                        1;
                    context.read<HomeCubit>().textController.value = context
                        .read<HomeCubit>()
                        .textController
                        .value
                        .copyWith(
                            text: newText,
                            selection: TextSelection.collapsed(
                                offset: newCaretPosition));
                  } else {
                    // Send message
                    context.read<HomeCubit>().sendRequest();
                  }
                }
                return KeyEventResult.handled;
              } else {
                return KeyEventResult.ignored;
              }
            },
          ),
          controller: context.read<HomeCubit>().textController,
          decoration: InputDecoration(
            labelText: 'What\'s on your mind...?',
            suffixIcon: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
              onPressed: context.read<HomeCubit>().sendRequest,
              icon: const Icon(Icons.send_rounded),
              label: const Text('Send'),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HomeCubit, HomeState>(
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

            final messages = context.read<HomeCubit>().messages;

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: messages.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < messages.length) {
                  final message = messages[index];
                  final isUser = message.role == Role.user;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isUser)
                          const CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.android_rounded,
                              color: Colors.white,
                            ),
                          ),
                        Flexible(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: isUser
                                        ? Colors.deepPurple.shade100
                                        : Colors.blueGrey.shade100,
                                  ),
                                  child: Text(
                                    message.content,
                                    style: TextStyle(
                                      color: isUser
                                          ? Colors.black
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              if (!isUser)
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                      text: context
                                          .read<HomeCubit>()
                                          .messages[index]
                                          .content,
                                    )).whenComplete(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.blueGrey,
                                          content: Text(
                                              'Message has been copied to the clipboard.'),
                                        ),
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.copy, size: 16),
                                  padding: EdgeInsets.zero,
                                ),
                              if (isUser)
                                IconButton(
                                  onPressed: () {
                                    context.read<HomeCubit>().onEdit(index);
                                  },
                                  icon: const Icon(Icons.edit, size: 16),
                                  padding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                        ),
                        if (isUser)
                          const CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  );
                } else {
                  // Show the loading indicator at the bottom of the chat screen
                  if (state is HomeStateLoading) {
                    return Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
