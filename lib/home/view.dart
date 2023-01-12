import 'package:chat_gpt_flutter/home/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
              applicationVersion: 'v0.5',
              applicationLegalese: '',
              applicationIcon: const FlutterLogo(),
              children: [
                ListTile(
                  title: const Text('By Hossein Yousefpour'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    launchUrlString(
                      'https//gabrimatic.info',
                      mode: LaunchMode.externalApplication,
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
          controller: context.read<HomeCubit>().textController,
          decoration: InputDecoration(
              label: const Text('What\'s on your mind...?'),
              // TODO: Fix colors
              suffixIcon: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
                onPressed: context.read<HomeCubit>().connect,
                icon: const Icon(Icons.search_rounded),
                label: const Text('Answer!'),
              )),
        ),
      ),
      body: Center(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeStateLoading) {
              return const CircularProgressIndicator();
            }

            String text = '';
            if (state is HomeStateLoaded) {
              text = state.chatGptModel.result;
            } else if (state is HomeStateError) {
              text = 'IDK!';
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  letterSpacing: 2,
                  color: Colors.black87,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
