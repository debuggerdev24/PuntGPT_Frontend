import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/bot/chat_message_model.dart';

class ChatSection extends StatelessWidget {
  const ChatSection({
    super.key,
    required this.message,
  });

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        (context.isBrowserMobile) ? 35.w : 25.w,
        12.w,
        25.w,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.senderLabel,
            style: semiBold(fontSize: context.isBrowserMobile ? 32.sp : 18.sp),
          ),
          Text(
            DateFormatter.formatTimeOnly(message.timestamp),
            style: semiBold(
              fontSize: (context.isBrowserMobile) ? 26.5.sp : 14.5.sp,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
          ),
          3.h.verticalSpace,
          Text(
            message.content,
            style: regular(fontSize: context.isBrowserMobile ? 32.sp : 16.sp),
          ),
          16.h.verticalSpace,
          horizontalDivider(),
        ],
      ),
    );
  }
}
