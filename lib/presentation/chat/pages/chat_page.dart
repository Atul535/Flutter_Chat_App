import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/core/utils/loader.dart';
import 'package:chat_app/presentation/chat/bloc/chat_bloc.dart';
import 'package:chat_app/presentation/chat/widgets/custom_bottom_navigation_bar.dart';
import 'package:chat_app/presentation/chat/widgets/chat_list.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetConversationPreviewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppPallete.appBarColor,
          title: const Text(
            'Message',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 7, top: 7, bottom: 7),
              child: GestureDetector(
                onTap: () {
                  appRouter.go(RouteNames.profile);
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppPallete.greyColor.withOpacity(0.5),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: Loader());
                  } else if (state is ConversationPreviewsLoaded) {
                    final query = _searchController.text.toLowerCase();
                    final filtered = state.previews.where((preview) {
                      final name = preview.receiverName.toLowerCase();
                      final lastMessage = preview.lastMessage.toLowerCase();
                      return name.contains(query) ||
                          lastMessage.contains(query);
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          'No messages found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ChatList(conversations: filtered);
                  } else if (state is ChatError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(child: Loader());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
