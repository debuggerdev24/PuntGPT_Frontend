import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/subscription_gate_view_web.dart';
import 'package:puntgpt_nick/provider/bot/bot_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/chat_bubble_web.dart';

class AskPuntGptScreenWeb extends StatefulWidget {
  const AskPuntGptScreenWeb({super.key});

  @override
  State<AskPuntGptScreenWeb> createState() => _AskPuntGptScreenWebState();
}

class _AskPuntGptScreenWebState extends State<AskPuntGptScreenWeb> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final isNotNearBottom = position.pixels <= position.maxScrollExtent - 80;
    setState(() => _showScrollToBottom = isNotNearBottom);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent * 2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(BotProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _scrollToBottom();
    provider.sendMessage(
      userQuery: text,
      onFailed: (error) {
        AppToast.info(context: context, message: error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BotProvider, SubscriptionProvider>(
      builder: (context, provider, subProvider, child) {
        if (provider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppToast.error(context: context, message: provider.errorMessage!);
            provider.clearError();
          });
        }

        if (!subProvider.isSubscribed) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              Expanded(
                child: SubscriptionGateViewWeb(
                  featureTitle: "Subscribe to use Ask PuntGPT",
                  featureDescription:
                      "Chat with AI for tips, form guides, track conditions and race analysis.",
                  icon: Icons.smart_toy_rounded,
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBar(context),
            Expanded(
              child: Stack(
                children: [
                  if (provider.messages.isEmpty && !provider.isLoading)
                    _emptyState(context)
                  else
                    ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount:
                          provider.messages.length + (provider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < provider.messages.length) {
                          return ChatBubbleWeb(
                            message: provider.messages[index],
                            isUser: provider.messages[index].isUser,
                          );
                        }
                        return HomeSectionShimmers.chatMessageShimmer(
                          context: context,
                        );
                      },
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.messages.isNotEmpty && _showScrollToBottom)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 18,
                                bottom: 17,
                              ),
                              child: Material(
                                color: AppColors.primary.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(50),
                                elevation: 4,
                                child: InkWell(
                                  onTap: _scrollToBottom,
                                  borderRadius: BorderRadius.circular(24),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 24,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        horizontalDivider(),
                        TextField(
                          controller: _controller,
                          enabled: !provider.isLoading,
                          onSubmitted: (_) => _sendMessage(provider),
                          style: medium(fontSize: 15, color: AppColors.primary),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            suffixIcon: IconButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : () => _sendMessage(provider),
                              icon: const Icon(Icons.send_rounded, size: 22),
                            ),
                            hintText: "Type your message...",
                            hintStyle: medium(
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              color: AppColors.primary.withValues(alpha: 0.45),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _topBar(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 6.w, 25.w, 5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed:() => context.pop(),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.wSize),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ask @ PuntGPT",
                      style: regular(
                        fontSize: 16.fSize,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.2,
                      ),
                    ),
                    1.w.verticalSpace,
                    Text(
                      "Tips, form guides & race analysis",
                      style: semiBold(
                        fontSize: 14.fSize,
                        height: 1.1,

                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 45),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_rounded,
              size: 56,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Start the conversation",
            textAlign: TextAlign.center,
            style: semiBold(
              fontSize: 20,
              fontFamily: AppFontFamily.secondary,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Ask me anything about horse racing-tips, form guides, track conditions, or which races to watch today.",
            textAlign: TextAlign.center,
            style: regular(
              fontSize: 14,
              color: AppColors.primary.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _suggestionChip(
            "Give me a jockey's name, I'll tell you what it's riding today",
          ),
          const SizedBox(height: 10),
          _suggestionChip(
            "Give me a trainer's name, I'll tell you where it has runners today",
          ),
          const SizedBox(height: 10),
          _suggestionChip("Find me 3 favourites racing today"),
          const SizedBox(height: 10),
          _suggestionChip(
            "Any winning barrier bias/trends from today's racing so far?",
          ),
        ],
      ),
    );
  }

  Widget _suggestionChip(String label) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: medium(
          fontSize: 13,
          color: AppColors.primary.withValues(alpha: 0.8),
          height: 1.3,
        ),
      ),
    );
  }
}
