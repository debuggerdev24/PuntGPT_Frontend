import 'dart:async';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/punt_club/club_chat_message_model.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/punter_club_screen.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/club_chat_message_bubble.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/dialogue_sheets.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/invite_user_sheet.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/punter_club_shimmers.dart';
import 'package:puntgpt_nick/services/punter_club/chat_socket_service.dart';

/// Club chat screen: connects to WebSocket, shows messages, supports send/edit/delete and typing.
class PuntClubChatScreen extends StatefulWidget {
  const PuntClubChatScreen({super.key, required this.title});
  final String title;

  @override
  State<PuntClubChatScreen> createState() => _PuntClubChatScreenState();
}

class _PuntClubChatScreenState extends State<PuntClubChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasInitiatedChat = false;
  bool _showGoToBottomButton = false;
  StreamSubscription<ChatConnectionState>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onScroll);
    _connectionSubscription = ChatService.instance.connectionState.listen((
      state,
    ) {
      if (state == ChatConnectionState.connected && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            AppToast.success(
              context: context,
              message: 'Chat connected successfully',
              duration: const Duration(seconds: 2),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onScroll() {
    final position = _scrollController.position;
    final isNotAtBottom = position.pixels <= position.maxScrollExtent - 35.w;
    Logger.info(
      '${position.pixels.toInt()} : ${position.maxScrollExtent.toInt()} : $isNotAtBottom',
    );

    setState(() {
      _showGoToBottomButton = isNotAtBottom;
    });
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent * 2,
      duration: Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!context.isMobileView) {
      context.pop();
    }
    return Consumer<PuntClubProvider>(
      builder: (context, provider, child) {
        // Connect to chat once when we have groupId (avoids infinite loop from notifyListeners → rebuild → callback)
        if (!_hasInitiatedChat) {
          final gid = provider.selectedGroupId ?? provider.groupId;
          if (gid.isNotEmpty) {
            _hasInitiatedChat = true;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await provider.connectChat();
            });
          }
        }
        return StreamBuilder<ChatConnectionState>(
          stream: ChatService.instance.connectionState,
          initialData: ChatService.instance.state,
          builder: (context, connSnapshot) {
            final isSocketConnected =
                connSnapshot.data == ChatConnectionState.connected;
            final isHistoryLoaded = provider.chatMessages != null;
            final showShimmer = !isHistoryLoaded || !isSocketConnected;

            if (showShimmer) {
              return SizedBox.expand(
                child: PunterClubShimmers.clubChatScreenShimmer(
                  context: context,
                ),
              );
            }
            return Stack(
              children: [
                Column(
                  children: [
                    _topBar(context: context, provider: provider),
                    Expanded(
                      child: (provider.chatMessages!.isEmpty)
                          ? _buildEmptyState(context)
                          :
                            //* Message list
                            ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.only(bottom: 4.w),
                              itemCount: provider.chatMessages!.length + 1,
                              itemBuilder: (context, index) {
                                if (index >= provider.chatMessages!.length) {
                                  return const SizedBox.shrink();
                                }
                                final msg = provider.chatMessages![index];
                                return ClubChatMessageBubble(
                                  message: msg,
                                  isOwnMessage: provider.isMyMessage(msg),
                                  onEdit: () =>
                                      _showEditDialog(context, provider, msg),
                                  onDelete: () =>
                                      _showDeleteDialog(context, provider, msg),
                                );
                              },
                            ),
                    ),
                    //* Input area
                    _buildInputArea(context, provider),
                  ],
                ),
                if (_showGoToBottomButton)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: goToBottomButton(),
                  ),
                if (provider.isLeavingGroup) const FullPageIndicator(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              size: context.isBrowserMobile ? 64.w : 48.w,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
            8.w.verticalSpace,
            Text(
              "No messages yet. Say hello!",
              style: medium(
                fontSize: context.isBrowserMobile ? 28.sp : 16.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //* Subtitle in top bar: shows typing state or member count.
  Widget _topBarSubtitle({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    final typing = provider.typingUsers;
    final names = typing.values.toList();
    final hasTyping = names.isNotEmpty;

    final String text = hasTyping
        ? (names.length == 1
              ? '${names.first} is typing...'
              : names.length == 2
              ? '${names[0]} and ${names[1]} are typing...'
              : '${names[0]} and ${names.length - 1} others are typing...')
        : '${provider.groupMembersList?.length ?? 11} Member';

    return Text(
      text,
      style: semiBold(
        height: 1.5,
        fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
        color: hasTyping
            ? AppColors.primary.withValues(alpha: 0.8)
            : AppColors.primary.withValues(alpha: 0.6),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget goToBottomButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 65, right: 12),
      child: Material(
        color: AppColors.primary.withValues(alpha: 1),
        borderRadius: BorderRadius.circular(50.r),
        elevation: 8,
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
    );
  }

  Widget _buildInputArea(BuildContext context, PuntClubProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        horizontalDivider(),
        Row(
          children: [
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: regular(
                  fontSize: context.isBrowserMobile ? 32.sp : 18.sp,
                ),
                controller: _messageController,
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefix: SizedBox(
                    width: (context.isBrowserMobile) ? 35.w : 25.w,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _sendMessage(provider),
                    icon: Icon(
                      Icons.send_rounded,
                      size: (context.isBrowserMobile) ? 32.w : 22.w,
                    ),
                  ),
                  hintText: "Type your message...",
                  hintStyle: medium(
                    fontStyle: FontStyle.italic,
                    fontSize: (context.isBrowserMobile) ? 28.sp : 14.sp,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
                onChanged: (_) {
                  // Typing: debounce start, send stop when empty
                  deBouncer.run(() {
                    if (_messageController.text.trim().isEmpty) {
                      provider.sendStopTyping();
                    } else {
                      provider.sendTyping();
                    }
                  });
                },
                onSubmitted: (_) => _sendMessage(provider),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _sendMessage(PuntClubProvider provider) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    provider.sendStopTyping();
    provider.sendChatMessage(text);
  }

  void _showEditDialog(
    BuildContext context,
    PuntClubProvider provider,
    ClubChatMessageModel msg,
  ) {
    final controller = TextEditingController(text: msg.content);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Edit message'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter updated message',
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newContent = controller.text.trim();
              if (newContent.isEmpty) return;
              provider.editChatMessage(msg.messageId, newContent);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    PuntClubProvider provider,
    ClubChatMessageModel msg,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Delete message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteChatMessage(msg.messageId);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _topBar({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 7.w, 25.w, 7.w),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  provider.disconnectChat();
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 16.h.flexClamp(16, 24),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      final grp =
                          provider.chatGroupsList![provider.selectedGroup];
                      provider.getUsersInviteList(groupId: grp.id.toString());
                    },
                    child: Text(
                      widget.title,
                      style: regular(
                        fontSize: (context.isBrowserMobile) ? 50.sp : 24.sp,
                        fontFamily: AppFontFamily.secondary,
                        height: 1,
                      ),
                    ),
                  ),
                  _topBarSubtitle(context: context, provider: provider),
                ],
              ),
              Spacer(),
              OnMouseTap(
                onTap: () {
                  final grp = provider.chatGroupsList![provider.selectedGroup];
                  provider.getUsersInviteList(groupId: grp.id.toString());
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    showDragHandle: true,
                    backgroundColor: AppColors.white,
                    builder: (context) => const InviteUserSheet(),
                  );
                },
                child: ImageWidget(
                  width: (context.isBrowserMobile) ? 60.w : 28.w,
                  path: AppAssets.addClubMember,
                  type: ImageType.svg,
                  color: AppColors.primary,
                ),
              ),
              (context.isBrowserMobile)
                  ? 40.w.horizontalSpace
                  : 20.w.horizontalSpace,
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    showDragHandle: true,
                    backgroundColor: AppColors.white,
                    builder: (sheetContext) => OptionsSheetView(
                      provider: provider,
                      sheetContext: sheetContext,
                    ),
                  );
                },
                child: ImageWidget(
                  width: (context.isBrowserMobile) ? 60.w : 28.w,
                  path: AppAssets.option,
                  type: ImageType.svg,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}

class OptionsSheetView extends StatelessWidget {
  const OptionsSheetView({
    super.key,
    required this.provider,
    required this.sheetContext,
  });
  final PuntClubProvider provider;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    final spacing = (context.isBrowserMobile)
        ? 40.w.verticalSpace
        : 24.w.verticalSpace;
    return SizedBox(
      height: context.screenHeight - 0.15.sh,
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 25.h),
        child: Column(
          children: [
            Text(
              "Option",
              style: regular(
                fontSize: 24.twentyFourSp(context),
                fontFamily: AppFontFamily.secondary,
              ),
            ),
            18.h.verticalSpace,
            horizontalDivider(),
            spacing,
            optionItem(
              title: "View Members",
              onTap: () {
                context.pop();
                provider.getGroupMembersList(
                  groupId: provider.chatGroupsList![provider.selectedGroup].id
                      .toString(),
                );
                context.pushNamed(AppRoutes.groupMembersScreen.name);
              },
            ),
            spacing,
            horizontalDivider(),
            spacing,
            optionItem(
              title: "Change Name",
              onTap: () {
                context.pop();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  showDragHandle: true,
                  backgroundColor: AppColors.white,
                  builder: (sheetContext) {
                    return CreateUserNameSheet(
                      provider: provider,
                      onSubmit: () {
                        sheetContext.pop();
                        provider.userNameSetup(
                          onSuccess: () {
                            final currentCtx =
                                AppRouter.rootNavigatorKey.currentContext;
                            AppToast.success(
                              context: currentCtx!,
                              message: "Name updated successfully",
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            spacing,
            horizontalDivider(),
            const Spacer(),
            if (!provider.isAdmin)
              AppOutlinedButton(
                borderColor: AppColors.red,
                textStyle: semiBold(fontSize: 18.sp, color: AppColors.red),
                text: "Leave Group",
                onTap: () {
                  context.pop();
                  final currentCtx = AppRouter.rootNavigatorKey.currentContext;
                  showLeaveGroupConfirmation(
                    context: currentCtx!,
                    onLeaveGroup: () {
                      provider.leaveGroup(
                        onSuccess: () {
                          final cuttentCtx =
                              AppRouter.rootNavigatorKey.currentContext;
                          if (cuttentCtx != null && cuttentCtx.mounted) {
                            AppToast.success(
                              context: cuttentCtx,
                              message: "Group left successfully",
                            );
                            cuttentCtx.pop();
                          }
                        },
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget optionItem({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 11.w,
        children: [
          Text(title, style: semiBold(fontSize: 16.sp)),
          Icon(Icons.arrow_forward_ios_rounded, size: 12),
        ],
      ),
    );
  }

  void showLeaveGroupConfirmation({
    required BuildContext context,
    required VoidCallback onLeaveGroup,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              "Are you sure you want to Quit Group?",
              style: regular(
                color: AppColors.black,
                fontSize: context.isBrowserMobile ? 65.sp : 19.sp,
              ),
            ),
            actions: [
              myActionButtonTheme(
                onPressed: () {
                  dialogContext.pop();
                  onLeaveGroup.call();
                },
                title: "Yes",
              ),
              myActionButtonTheme(
                onPressed: () => dialogContext.pop(),
                title: "Cancel",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget myActionButtonTheme({
    required VoidCallback onPressed,
    required String title,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: regular(
          color: (title == "Yes") ? AppColors.red : AppColors.black,
          fontSize: 16.5,
        ),
      ),
    );
  }
}
