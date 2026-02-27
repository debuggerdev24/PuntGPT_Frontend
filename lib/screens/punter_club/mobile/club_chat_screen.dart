import 'dart:async';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/punt_club/club_chat_message_model.dart';
import 'package:puntgpt_nick/services/punter_club/chat_service.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/punter_club_screen.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/club_chat_message_bubble.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/dialogue_sheets.dart';

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
  StreamSubscription<ChatConnectionState>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _connectionSubscription = ChatService.instance.connectionState.listen((state) {
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
        return Stack(
          children: [
            Column(
              children: [
                _topBar(context: context, provider: provider),
                Expanded(
                  child: Stack(
                    children: [
                      // Message list
                      ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          bottom: 100.h,
                          left: 0,
                          right: 0,
                          top: 8.h,
                        ),
                        itemCount: provider.chatMessages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0 && provider.chatMessages.isEmpty) {
                            return _buildEmptyState(context);
                          }
                          if (index >= provider.chatMessages.length) {
                            return const SizedBox.shrink();
                          }
                          final msg = provider.chatMessages[index];
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
                      // Typing indicator bar (above input)
                      if (provider.typingUsers.isNotEmpty)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 60.h,
                          child: _buildTypingIndicator(provider),
                        ),
                      // Ask PuntGPT FAB
                      Padding(
                        padding: EdgeInsets.only(bottom: 25.h, right: 25.w),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: context.isBrowserMobile
                              ? askPuntGPTButtonWeb(context: context)
                              : askPuntGPTButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // Input area
                _buildInputArea(context, provider),
              ],
            ),
            if (provider.isLeavingGroup || provider.isUserNameSetupLoading)
              const FullPageIndicator(),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Text(
          "No messages yet. Say hello!",
          style: medium(
            fontSize: context.isBrowserMobile ? 28.sp : 16.sp,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  /// Typing indicator: "User1, User2 are typing..."
  Widget _buildTypingIndicator(PuntClubProvider provider) {
    final names = provider.typingUsers.values.toList();
    final text = names.length == 1
        ? '${names.first} is typing...'
        : names.length == 2
            ? '${names[0]} and ${names[1]} are typing...'
            : '${names[0]} and ${names.length - 1} others are typing...';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: medium(
                fontSize: context.isBrowserMobile ? 24.sp : 13.sp,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
                controller: _messageController,
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
        content: const Text(
          'Are you sure you want to delete this message?',
        ),
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
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
          padding: EdgeInsets.fromLTRB(4.w, 10.w, 25.w, 14.w),
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
                      final grp = provider.chatGroupsList![provider.selectedGroup];
                      provider.getUsersInviteList(
                        groupId: grp.id.toString(),
                      );
                    },
                    child: Text(
                      widget.title,
                      style: regular(
                        fontSize: (context.isBrowserMobile) ? 50.sp : 24.sp,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                  Text(
                    "11 Member",
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
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
              (context.isBrowserMobile) ? 40.w.horizontalSpace : 20.w.horizontalSpace,
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
                    return createUserNameSheet(
                      context: sheetContext,
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
            AppOutlinedButton(
              borderColor: AppColors.red,
              textStyle: semiBold(fontSize: 18.sp, color: AppColors.red),
              text: "Leave Group",
              onTap: () {
                context.pop();
                final cuttentCtx = AppRouter.rootNavigatorKey.currentContext;
                showLeaveGroupConfirmation(
                  context: cuttentCtx!,
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
