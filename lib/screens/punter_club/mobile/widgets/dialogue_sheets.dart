import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';

class CreateUserNameSheet extends StatelessWidget {
  const CreateUserNameSheet({
    super.key,
    required this.provider,
    required this.onSubmit,
  });

  final PuntClubProvider provider;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        height: 370.w,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            Text(
              "Create Username",
              style: regular(
                fontSize: 24.sp,
                fontFamily: AppFontFamily.secondary,
              ),
            ),
            10.h.verticalSpace,
            Text(
              "Your username will be displayed to your club members.",
              style: semiBold(
                fontSize: 14.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            22.w.verticalSpace,
            horizontalDivider(),
            24.w.verticalSpace,
            AppTextField(
              controller: provider.usernameCtr,
              hintText: "Enter username",
            ),
            AppFilledButton(
              margin: EdgeInsets.only(top: 24.w),
              text: "Save",
              onTap: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
