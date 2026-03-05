import 'package:puntgpt_nick/core/app_imports.dart';
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
