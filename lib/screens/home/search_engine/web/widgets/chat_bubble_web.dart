import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/bot/chat_message_model.dart';

class ChatBubbleWeb extends StatelessWidget {
  const ChatBubbleWeb({
    super.key,
    required this.message,
    required this.isUser,
  });

  final ChatMessageModel message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    const maxBubbleWidth = 360.0;

    final fillColor = isUser ? const Color(0xFF1C1C1C) : AppColors.greyColor;
    final borderColor = isUser
        ? AppColors.white.withValues(alpha: 0.15)
        : AppColors.primary.withValues(alpha: 0.3);
    final labelColor = isUser
        ? AppColors.white.withValues(alpha: 0.8)
        : AppColors.primary.withValues(alpha: 0.9);
    final timeColor = isUser
        ? AppColors.white.withValues(alpha: 0.7)
        : AppColors.primary.withValues(alpha: 0.45);
    final messageColor = isUser ? AppColors.white : AppColors.primary;

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxBubbleWidth),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: borderRadius,
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.senderLabel,
                          style: semiBold(fontSize: 16, color: labelColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormatter.formatTimeOnly(message.timestamp),
                          style: regular(fontSize: 11, color: timeColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message.content,
                      style: regular(
                        fontSize: 15,
                        color: messageColor,
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
