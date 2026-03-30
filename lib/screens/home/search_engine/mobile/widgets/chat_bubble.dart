import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/bot/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.isUser, required this.message});

  final ChatMessageModel message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.sizeOf(context).width * 0.88;

    final fill = isUser ? AppColors.greyColor : const Color(0xFF1C1C1C);
    final border = isUser
        ? AppColors.primary.withValues(alpha: 0.3)
        : AppColors.white.withValues(alpha: 0.15);
    final labelColor = isUser
        ? AppColors.primary.withValues(alpha: 0.9)
        : AppColors.white.withValues(alpha: 0.8);
    final timeColor = isUser
        ? AppColors.primary.withValues(alpha: 0.45)
        : AppColors.white.withValues(alpha: 0.7);
    final msgColor = isUser ? AppColors.primary : AppColors.white;
    final borderRadius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (context.isBrowserMobile) ? 35.w : 16.w,
        vertical: 6.w,
      ),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Container(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: borderRadius,
                  border: Border.all(color: border, width: 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8.w,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.senderLabel,
                          style: semiBold(
                            fontSize: context.isBrowserMobile ? 32.sp : 16.sp,
                            color: labelColor,
                          ),
                        ),
                        Text(
                          DateFormatter.formatTimeOnly(message.timestamp),
                          style: regular(
                            fontSize: context.isBrowserMobile ? 22.sp : 11.sp,
                            color: timeColor,
                          ),
                        ),
                      ],
                    ),
                    5.w.verticalSpace,
                    Text(
                      message.content,
                      style: regular(
                        fontSize: context.isBrowserMobile ? 30.sp : 15.sp,
                        color: msgColor,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
