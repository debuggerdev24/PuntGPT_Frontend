import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/widgets/subscription_gate_view.dart';
import 'package:puntgpt_nick/provider/bot/bot_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/chat_section.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

class AskPuntGptScreen extends StatefulWidget {
  const AskPuntGptScreen({super.key});

  @override
  State<AskPuntGptScreen> createState() => _AskPuntGptScreenState();
}

class _AskPuntGptScreenState extends State<AskPuntGptScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;
  static double bottomOffset = 80.w;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final isNotNearBottom =
        position.pixels <= position.maxScrollExtent - bottomOffset;

    setState(() => _showScrollToBottom = isNotNearBottom);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
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
    scrollToBottom();
    provider.sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    if (!context.isMobileView) {
      context.pop();
    }
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
              topBar(context),
              Expanded(
                child: SubscriptionGateView(
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
            topBar(context),
            Expanded(
              child: Stack(
                children: [
                  if (provider.messages.isEmpty && !provider.isLoading)
                    Center(child: _buildEmptyState(context))
                  else
                    ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 80.w),
                      itemCount:
                          provider.messages.length +
                          (provider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < provider.messages.length) {
                          return ChatSection(message: provider.messages[index]);
                        }
                        return HomeSectionShimmers.chatMessageShimmer(
                          context: context,
                        );
                      },
                    ),
                  //* scroll to bottom button
                  // if (provider.messages.isNotEmpty && _showScrollToBottom)
                  // Positioned(
                  //   left: 0,
                  //   right: 0,
                  //   bottom: 70.w,
                  //   child:
                  // ),
                  //* text field
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.messages.isNotEmpty && _showScrollToBottom)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 18.w,
                                bottom: 17.w,
                              ),
                              child: Material(
                                color: AppColors.primary.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(50.r),
                                elevation: 4,
                                child: InkWell(
                                  onTap: scrollToBottom,
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 28.w,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        horizontalDivider(),
                        TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _controller,
                          enabled: !provider.isLoading,
                          onSubmitted: (_) => _sendMessage(provider),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            suffixIcon: IconButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : () => _sendMessage(provider),
                              icon: Icon(Icons.send_rounded, size: 24.w),
                            ),

                            hintText: "Type your message...",
                            hintStyle: medium(
                              fontStyle: FontStyle.italic,
                              fontSize: (context.isBrowserMobile)
                                  ? 24.sp
                                  : 14.sp,
                              color: AppColors.primary.withValues(alpha: 0.9),
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

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all((context.isBrowserMobile) ? 28.w : 20.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_rounded,
              size: (context.isBrowserMobile) ? 80.w : 56.w,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          24.w.verticalSpace,
          Text(
            "Start the conversation",
            style: semiBold(
              fontSize: (context.isBrowserMobile) ? 28.sp : 20.sp,
              fontFamily: AppFontFamily.secondary,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          12.w.verticalSpace,
          Text(
            "Ask me anything about horse racing—tips, form guides, track conditions, or which races to watch today.",
            style: regular(
              fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
              color: AppColors.primary.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          20.h.verticalSpace,
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _suggestionChip("Best race today?", context),
              _suggestionChip("Compare horses", context),
              _suggestionChip("Track conditions", context),
              _suggestionChip("Form analysis", context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _suggestionChip(String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.text = label;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (context.isBrowserMobile) ? 20.w : 14.w,
          vertical: (context.isBrowserMobile) ? 14.h : 10.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: Text(
          label,
          style: medium(
            fontSize: (context.isBrowserMobile) ? 22.sp : 13.sp,
            color: AppColors.primary.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }

  Widget topBar(BuildContext context) {
    return AppScreenTopBar(
      title: "Ask @PuntGPT",
      slogan: "Tips, form guides & race analysis",
      onBack: () => context.pop(),
    );
  }
}
