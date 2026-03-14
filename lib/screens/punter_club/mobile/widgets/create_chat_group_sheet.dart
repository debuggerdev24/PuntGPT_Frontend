import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/invite_user_sheet.dart';

class CreateChatGroupSheet extends StatelessWidget {
  const CreateChatGroupSheet({
    super.key,
    required this.provider,
  });

  final PuntClubProvider provider;

  @override
  Widget build(BuildContext context) {
    if (isGuest) {
      return _GuestCreateClubView();
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        height: 310.h,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            Text(
              "Create Punter Club",
              style: regular(
                fontSize: 24.sp,
                fontFamily: AppFontFamily.secondary,
              ),
            ),
            16.h.verticalSpace,
            horizontalDivider(),
            24.h.verticalSpace,
            AppTextField(
              controller: provider.clubNameCtr,
              hintText: "Enter Club Name",
            ),
            AppFilledButton(
              margin: EdgeInsets.only(top: 24.h),
              text: "Create Club",
              onTap: () {
                context.pop();
                final currentCtx = AppRouter.rootNavigatorKey.currentContext;
                if (provider.clubNameCtr.text.trim().isEmpty) {
                  AppToast.error(
                    context: currentCtx!,
                    message: "Please enter club name",
                  );
                  return;
                }
                provider.createChatGroup(
                  onError: (error) {
                    AppToast.error(context: currentCtx!, message: error);
                  },
                  onSuccess: () {
                    AppToast.success(
                      context: currentCtx!,
                      message: "Chat group created successfully",
                    );
                    provider.getUsersInviteList(groupId: provider.groupId);
                    showModalBottomSheet(
                      context: currentCtx,
                      isScrollControlled: true,
                      showDragHandle: true,
                      useRootNavigator: true,
                      backgroundColor: AppColors.white,
                      builder: (_) {
                        return InviteUserSheet(showInviteLater: true);
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
}

class _GuestCreateClubView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: ImageWidget(
              type: ImageType.svg,
              path: AppAssets.groupIcon,
              width: 40.w,
            ),
          ),
          24.w.verticalSpace,
          Text(
            "Create your Punter Club",
            style: semiBold(
              fontSize: 20.sp,
              fontFamily: AppFontFamily.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          12.w.verticalSpace,
          Text(
            AppStrings.guestCreateChatGroupMessage,
            style: regular(
              fontSize: 15.sp,
              color: AppColors.primary.withValues(alpha: 0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          32.w.verticalSpace,
          AppFilledButton(
            text: "Subscribe to Pro",
            onTap: () {
              context.pop();
              context.pushNamed(
                kIsWeb ? WebRoutes.manageSubscriptionScreen.name : AppRoutes.manageSubscriptionScreen.name,
              );
            },
          ),
          // 16.w.verticalSpace,
          // OnMouseTap(
          //   onTap: () {
          //     context.pop();
          //     context.pushNamed(
          //       kIsWeb ? WebRoutes.logInScreen.name : AppRoutes.loginScreen.name,
          //     );
          //   },
          //   child: Text(
          //     "Already have an account? Sign in",
          //     style: medium(
          //       fontSize: 14.sp,
          //       color: AppColors.primary,
          //       decoration: TextDecoration.underline,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
