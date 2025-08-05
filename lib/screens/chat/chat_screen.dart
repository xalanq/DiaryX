import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';

import '../../stores/chat_store.dart';
import '../../databases/app_database.dart';
import '../../utils/app_logger.dart';
import 'components/ai_analysis_templates.dart';

part 'components/chat_list_item.dart';
part 'components/chat_floating_action_button.dart';

/// Premium chat screen with session management and AI-powered conversations
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadChats();
    AppLogger.userAction('Chat screen opened');
  }

  Future<void> _loadChats() async {
    final chatStore = context.read<ChatStore>();
    await chatStore.loadChats();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: PremiumScreenBackground(
        child: Column(
          children: [
            // Chat content with scroll
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top padding
                    SizedBox(height: MediaQuery.of(context).padding.top + 20),

                    // AI Analysis Templates Section
                    const AIAnalysisTemplates(),

                    // Bottom padding
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
