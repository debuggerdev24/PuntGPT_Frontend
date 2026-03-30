import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/invite_user_sheet.dart';

class CreateChatGroupSheet extends StatelessWidget {
  const CreateChatGroupSheet({
    super.key,
    required this.provider,
  });

  final PuntClubProvider provider;

  @override
  Widget build(BuildContext context) {
    final isSubscribed =
        context.read<SubscriptionProvider>().isSubscribed;

    if (isGuest) {
      return const _GuestCreateClubView();
    }
    if (!isSubscribed) {
      return const _NonSubscribedCreateClubView();
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        height: 310.w,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            Text(
              "Create Punters Club",
              style: regular(
                fontSize: 24.sp,
                fontFamily: AppFontFamily.secondary,
              ),
            ),
            16.w.verticalSpace,
            horizontalDivider(),
            24.w.verticalSpace,
            AppTextField(
              controller: provider.clubNameCtr,
              hintText: "Enter Club Name",
            ),
            AppFilledButton(
              margin: EdgeInsets.only(top: 24.w),
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
  const _GuestCreateClubView();

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
                kIsWeb
                    ? WebRoutes.manageSubscriptionScreen.name
                    : AppRoutes.manageSubscriptionScreen.name,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Logged-in user without an active Pro subscription.
class _NonSubscribedCreateClubView extends StatelessWidget {
  const _NonSubscribedCreateClubView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(25.w, 8.w, 25.w, 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Create Punter Club",
              style: regular(
                fontSize: 24.sp,
                fontFamily: AppFontFamily.secondary,
              ),
            ),
            16.w.verticalSpace,
            horizontalDivider(),
            24.w.verticalSpace,
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                Icons.groups_rounded,
                size: 36.sp,
                color: AppColors.primary.withValues(alpha: 0.65),
              ),
            ),
            16.w.verticalSpace,
            Text(
              "Pro Punter required",
              style: semiBold(
                fontSize: 17.sp,
                fontFamily: AppFontFamily.secondary,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            10.w.verticalSpace,
            Text(
              AppStrings.nonSubscribedCreateClubMessage,
              style: regular(
                fontSize: 14.sp,
                color: AppColors.primary.withValues(alpha: 0.65),
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            24.w.verticalSpace,
            AppFilledButton(
              text: "Subscribe to Pro",
              onTap: () {
                context.pop();
                context.pushNamed(
                  kIsWeb
                      ? WebRoutes.manageSubscriptionScreen.name
                      : AppRoutes.manageSubscriptionScreen.name,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
