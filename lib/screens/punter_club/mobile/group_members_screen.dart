import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/widgets/punter_club_shimmers.dart';

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PuntClubProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _topBar(context: context, provider: provider),
            horizontalDivider(),
            Expanded(
              child: provider.groupMembersList == null
                  ? PunterClubShimmers.groupMembersScreenShimmer(
                      context: context,
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: horizontalDivider(),
                      ),
                      itemCount: provider.groupMembersList!.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= provider.groupMembersList!.length) {
                          return SizedBox();
                        }
                        final groupMember = provider.groupMembersList![index];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 0.w,
                          ),
                          title: Text(
                            groupMember.userName,

                            style: semiBold(fontSize: 18.sp, height: 0),
                          ),
                          subtitle: Text(
                            "Joined on ${DateFormatter.formatWithTime(groupMember.joinedAt)}",
                            style: medium(
                              fontSize: 15.sp,
                              height: 0,
                              color: AppColors.primary.withValues(alpha: 0.6),
                            ),
                          ),
                          leading: ImageWidget(
                            path: AppAssets.userIcon,
                            type: ImageType.svg,
                            width: 25.w,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _topBar({
    required BuildContext context,
    required PuntClubProvider provider,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        13.w,
        (context.isBrowserMobile) ? 35.w : 25.w,
        11.w,
      ),

      // padding: EdgeInsets.symmetric(
      //   horizontal: (context.isBrowserMobile) ? 35.w : 25.w,
      //   vertical: 22.w,
      // ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 22.w, right: 12.w),
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Icon(Icons.arrow_back_ios_rounded, size: 16.w),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Group Members",
                style: regular(
                  fontSize: (context.isBrowserMobile) ? 38.sp : 24.sp,
                  fontFamily: AppFontFamily.secondary,
                  height: 1,
                ),
              ),
              Text(
                "${provider.groupMembersList?.length} Member",
                style: semiBold(
                  height: 1.6,
                  fontSize: (context.isBrowserMobile) ? 30.sp : 14.sp,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Spacer(),
          ImageWidget(path: AppAssets.groupIcon, type: ImageType.svg),
        ],
      ),
    );
  }
}
