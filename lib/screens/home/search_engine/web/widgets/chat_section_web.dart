import 'package:puntgpt_nick/core/app_imports.dart';

class ChatSectionWeb extends StatelessWidget {
  const ChatSectionWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 18.w, 24.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "@you",
            style: semiBold(fontSize: context.isDesktop ? 14.sp : 22.sp),
          ),
          Text(
            "12:41 PM",
            style: semiBold(
              fontSize: context.isDesktop ? 12.sp : 22.sp,
              color: AppColors.greyColor.withValues(alpha: 0.6),
            ),
          ),
          3.w.verticalSpace,
          Text(
            "mdsndjkjvdjkvbdjkfvbdf c mnbbnxmnfklfjkfjkdm,nnm,nbm,cnvm,bncmnbmcb",
            style: regular(fontSize: context.isDesktop ? 14.sp : 22.sp),
          ),
          16.w.verticalSpace,
          horizontalDivider(opacity: 0.15),
        ],
      ),
    );
  }
}
