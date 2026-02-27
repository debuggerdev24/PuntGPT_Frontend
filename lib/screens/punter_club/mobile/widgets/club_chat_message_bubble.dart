import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/punt_club/club_chat_message_model.dart';

/// A single chat message bubble in Punter Club chat.
/// Shows sender, content, timestamp, and edit/delete actions for own messages (within 15 min).
class ClubChatMessageBubble extends StatelessWidget {
  const ClubChatMessageBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
    required this.onEdit,
    required this.onDelete,
  });

  final ClubChatMessageModel message;
  final bool isOwnMessage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        (context.isBrowserMobile) ? 35.w : 25.w,
        12.h,
        25.w,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '@${message.senderUsername}',
                style: semiBold(
                  fontSize: context.isBrowserMobile ? 32.sp : 18.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                DateFormatter.formatTimeOnly(message.createdAt),
                style: semiBold(
                  fontSize: context.isBrowserMobile ? 26.5.sp : 14.5.sp,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
              if (message.isEdited) ...[
                SizedBox(width: 6.w),
                Text(
                  '(edited)',
                  style: regular(
                    fontSize: context.isBrowserMobile ? 22.sp : 12.sp,
                    color: AppColors.primary.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const Spacer(),
              // Edit/Delete: only for own messages, within 15 min (message.canEdit)
              if (isOwnMessage && message.canEdit)
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: (context.isBrowserMobile) ? 28.w : 18.w,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
            ],
          ),
          6.h.verticalSpace,
          Text(
            message.content,
            style: regular(
              fontSize: context.isBrowserMobile ? 32.sp : 16.sp,
            ),
          ),
          16.h.verticalSpace,
          horizontalDivider(),
        ],
      ),
    );
  }
}
