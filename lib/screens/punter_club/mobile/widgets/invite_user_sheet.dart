import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/punt_club/user_invites_list.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/punter_club_shimmers.dart';

class InviteUserSheet extends StatelessWidget {
  const InviteUserSheet({super.key, this.showInviteLater = false});
  final bool? showInviteLater;

  @override
  Widget build(BuildContext context) {
    return Consumer<PuntClubProvider>(
      builder: (context, provider, child) {
        // Show shimmer while user list is loading
        if (provider.userInvitesList == null) {
          return SizedBox(
            height: context.screenHeight - 0.15.sh,
            child: PunterClubShimmers.inviteUserSheetShimmer(context: context),
          );
        }
        if (provider.userInvitesList!.isEmpty) {
          return const Center(child: Text("No users to invite"));
        }

        final filtered = provider.filteredUserList;
        final isSearching = provider.searchNameCtr.text.trim().isNotEmpty;
        final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
        final selectedIds = provider.selectedIds;
        final hasSelection = selectedIds.isNotEmpty;

        return SizedBox(
          height: context.screenHeight - 0.15.sh,
          child: Stack(
            children: [
              Padding(
                // bottom padding = keyboard height so content lifts above keyboard
                padding: EdgeInsets.fromLTRB(25.w, 5, 25.w, keyboardHeight),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        //* Title
                        Text(
                          "Invite Users",
                          style: regular(
                            fontSize: 24.twentyFourSp(context),
                            fontFamily: AppFontFamily.secondary,
                          ),
                        ),
                        20.h.verticalSpace,
                        horizontalDivider(),
                        20.h.verticalSpace,
                        // Search field
                        AppTextField(
                          controller: provider.searchNameCtr,
                          hintText: "Search by username",
                          trailingIcon: AppAssets.searchIcon,
                        ),
                        8.w.verticalSpace,
                        // User list
                        Expanded(
                          child: filtered.isEmpty
                              ? Center(
                                  child: Text(
                                    isSearching
                                        ? 'No users found for "${provider.searchNameCtr.text.trim()}"'
                                        : "No users to invite",
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final user = filtered[index];
                                    final isSelected = selectedIds.contains(
                                      user.id,
                                    );
                                    final canInvite = _canInvite(
                                      user.membershipStatus,
                                    );
                                    return _userBox(
                                      context: context,
                                      user: user,
                                      isSelected: isSelected,
                                      canInvite: canInvite,
                                      onTap: canInvite
                                          ? () => provider.toggleUser(user.id)
                                          : () {},
                                    );
                                  },
                                ),
                        ),
                        // Send button — visible only when at least one user is selected
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) =>
                              SizeTransition(
                                sizeFactor: animation,
                                axisAlignment: -1,
                                child: child,
                              ),
                          child: hasSelection
                              ? AppFilledButton(
                                  key: ValueKey(selectedIds.length),
                                  margin: EdgeInsets.only(top: 8.w, bottom: 4),
                                  text: selectedIds.length == 1
                                      ? "Send Invite"
                                      : "Send to All (${selectedIds.length})",
                                  onTap: () {
                                    provider.inviteUser(
                                      onSuccess: () {
                                        context.pop();
                                        AppToast.success(
                                          context: context,
                                          message: "Invite sent successfully",
                                        );
                                      },
                                      groupId: (provider.groupId.isEmpty)
                                          ? provider
                                                .chatGroupsList![provider
                                                    .selectedGroup]
                                                .id
                                                .toString()
                                          : provider.groupId,
                                      userIds: selectedIds
                                          .map((id) => id.toString())
                                          .toList(),

                                      context: context,
                                    );
                                  },
                                )
                              : const SizedBox.shrink(),
                        ),
                        if (showInviteLater == true)
                          AppOutlinedButton(
                            margin: EdgeInsets.only(top: 8.w, bottom: 16.w),
                            text: "Invite Later",
                            onTap: () {
                              provider.resetInviteState();
                              context.pop();
                            },
                          ),
                      ],
                    ),
                    //* Back arrow
                    Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18.eighteenSp(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.isInvitingUser) FullPageIndicator(),
            ],
          ),
        );
      },
    );
  }

  //* True when user can be invited/reinvited (show invite button and allow selection).
  static bool _canInvite(String? status) {
    final normalized = _normalizedStatus(status);
    return normalized == '' || normalized == "left";
  }

  //* Maps API status values to canonical: invited, accepted, rejected, left, expired, reinvited.
  static String _normalizedStatus(String? status) {
    if (status == null || status.trim().toLowerCase() == 'null') {
      return '';
    }
    if (status == "left") {
      return "left";
    }
    return status;
  }

  Widget _userBox({
    required BuildContext context,
    required UserInvitesList user,
    required bool isSelected,
    required bool canInvite,
    required VoidCallback onTap,
  }) {
    final height = (context.isBrowserMobile) ? 96.w : 48.w;
    final width = (context.isBrowserMobile) ? 68.w : 48.w;
    final status = _normalizedStatus(user.membershipStatus);
    final displayName = "@${user.name.trim()}";

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(top: 8.w),
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.green.withValues(alpha: 0.5)
                : AppColors.primary.withValues(alpha: 0.15),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            //* Avatar
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: AppColors.greyColor),
              child: ImageWidget(type: ImageType.svg, path: AppAssets.userIcon),
            ),
            (context.isBrowserMobile)
                ? 80.w.horizontalSpace
                : 15.w.horizontalSpace,
            //* Username
            Expanded(
              child: Text(
                displayName,
                style: semiBold(fontSize: 16.sixteenSp(context)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //* Right: status label or invite button
            _buildRightAction(
              context: context,
              status: status,
              isSelected: isSelected,
              canInvite: canInvite,
              height: height,
              width: width,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightAction({
    required BuildContext context,
    required String status,
    required bool isSelected,
    required bool canInvite,
    required double height,
    required double width,
  }) {
    if (isSelected && canInvite) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: AppColors.green),
        child: Icon(
          Icons.check_rounded,
          color: AppColors.white,
          size: (context.isBrowserMobile) ? 36 : 22,
        ),
      );
    }
    Logger.info("Status: $status");

    if (!canInvite && status.isNotEmpty && status != "left") {
      return _buildStatusLabel(context: context, status: status);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status == "left") ...[
          Text(
            'Left',
            style: semiBold(
              fontSize: (context.isBrowserMobile) ? 24.sp : 13.sp,
              color: AppColors.primary.withValues(alpha: 0.55),
            ),
          ),
          10.w.horizontalSpace,
        ],
        Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.w),
          decoration: BoxDecoration(color: AppColors.primary),
          child: ImageWidget(
            path: AppAssets.addMember,
            type: ImageType.asset,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLabel({
    required BuildContext context,
    required String status,
  }) {
    final isDeclined = status == 'rejected';
    final isInvited = status == 'invited';
    final isAccepted = status == 'accepted';
    final isLeft = status == 'left';
    final isExpired = status == 'expired';

    String label;
    Color color;
    if (isDeclined) {
      label = 'Declined';
      color = AppColors.redButton;
    } else if (isInvited) {
      label = 'Invited';
      color = AppColors.primary.withValues(alpha: 0.55);
    } else if (isAccepted) {
      label = 'Accepted';
      color = Colors.green;
    } else if (isLeft) {
      label = 'Left';
      color = AppColors.primary.withValues(alpha: 0.55);
    } else if (isExpired) {
      label = 'Expired';
      color = AppColors.redButton;
    } else {
      // Unknown status: show capitalized so every status is visible
      label = status.isEmpty
          ? '—'
          : (status[0].toUpperCase() + status.substring(1));
      color = AppColors.primary.withValues(alpha: 0.55);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: semiBold(
            fontSize: (context.isBrowserMobile) ? 24.sp : 13.sp,
            color: color,
          ),
        ),
        if (isDeclined || isExpired) ...[
          6.w.horizontalSpace,
          Icon(
            Icons.info_outline_rounded,
            size: (context.isBrowserMobile) ? 22.w : 18.w,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ],
        12.w.horizontalSpace,
      ],
    );
  }
}
