import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/chat_section_web.dart';

class PunterClubChatSectionWeb extends StatelessWidget {
  const PunterClubChatSectionWeb({super.key});

  @override
  Widget build(BuildContext context) {
    
    final twelveResponsive = context.isDesktop
        ? 12.sp
        : context.isTablet
        ? 20.sp
        : (context.isBrowserMobile)
        ? 28.sp
        : 12.sp;
    final fourteenResponsive = context.isDesktop
        ? 14.sp
        : context.isTablet
        ? 22.sp
        : (context.isBrowserMobile)
        ? 26.sp
        : 14.sp;

    return Consumer<AccountProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.isDesktop ? 24.w : 30.w,
                  vertical: context.isDesktop ? 11.w : 17.w,
                ),
                child: topBar(
                  context: context,
                  twelveResponsive: twelveResponsive,
                  fourteenResponsive: fourteenResponsive,
                ),
              ),
              horizontalDivider(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ChatSectionWeb(),
                    ChatSectionWeb(),
                    ChatSectionWeb(),
                  ],
                ),
              ),
              horizontalDivider(),
              TextField(
                style: regular(fontSize: 16.sixteenSp(context)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefix: SizedBox(width: 25.w),
                  hintText: "Type your message...",
                  hintStyle: medium(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.sixteenSp(context),
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Container(
                height: 40.w,
                color: AppColors.primary,
                width: double.infinity,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget topBar({
    required BuildContext context,
    required double twelveResponsive,
    required double fourteenResponsive,
    // required double sixteenResponsive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "‘PuntGPT Legends’",
              style: regular(
                fontSize: context.isDesktop ? 24.sp : (context.isBrowserMobile) ? 24.sp : 30.sp,
                fontFamily: AppFontFamily.secondary,
                height: 1.35,
              ),
            ),
            Text(
              "11 members",
              style: semiBold(
                fontSize: twelveResponsive,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        Spacer(),
        OnMouseTap(
          onTap: () {
            showModalSideSheet(
              context: context,
              useRootNavigator: false,
              width: context.isDesktop ? 530.w : 580.w,
              withCloseControll: true,
              body: _inviteUserSheet(
                // sixteenResponsive: sixteenResponsive,
                context: context,
              ),
            );
          },
          child: Row(
            children: [
              ImageWidget(
                path: AppAssets.addClubMember,
                type: ImageType.svg,
                color: AppColors.primary,
                height: context.isDesktop ? 20.w : 28.w,
              ),
              context.isDesktop ? 10.w.horizontalSpace : 20.w.horizontalSpace,
              Text(
                "Add New Members",
                style: semiBold(fontSize: fourteenResponsive),
              ),
            ],
          ),
        ),
        28.w.horizontalSpace,
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (TapDownDetails details) {
              // Get the widget's RenderBox
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;

              // Get widget's position relative to the screen
              final Offset offset = renderBox.localToGlobal(Offset.zero);

              // Get widget's size
              final Size size = renderBox.size;

              // Get screen size for boundary calculation
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;

              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromLTWH(
                  offset.dx +
                      (context.isDesktop
                          ? -5.w
                          : context.isTablet
                          ? 0.w
                          : context.isBrowserMobile
                          ? 10.w
                          : 35.w),
                  offset.dy - 20,
                  size.width, // Width of widget
                  0,
                ),
                Offset.zero & overlay.size, // Screen bounds
              );

              popUpMenu(
                context: context,
                position: position,
                
              );
            },
            child: ImageWidget(
              height: context.isDesktop ? 20.w : 28.w,
              path: AppAssets.option,
              type: ImageType.svg,
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> popUpMenu({
    required BuildContext context,
    required RelativeRect position,
  }) {
    return showMenu(
      context: context,
      position: position,
      color: AppColors.white,
      shadowColor: AppColors.primary,
      items: <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () {
            showModalSideSheet(
              context: context,
              useRootNavigator: false,
              width: context.isDesktop ? 530.w : 580.w,
              withCloseControll: true,
              body: _inviteUserSheet(
                context: context,
                
              ),
            );
          },
          value: "view",

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "View Members",
                style: semiBold(fontSize: 14.responsiveTextSize()),
              ),
              Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
        const PopupMenuDivider(height: 0),

        PopupMenuItem(
          value: "rename",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Change Name",
                style: semiBold(fontSize: 14.responsiveTextSize()),
              ),
              Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
        const PopupMenuDivider(height: 0),
        PopupMenuItem(
          value: "leave",
          child: AppOutlinedButton(
            isExpand: false,
            padding: EdgeInsets.symmetric(
              vertical: 12.responsiveTextSize(),
              horizontal: 20.responsiveSize(),
            ),
            margin: EdgeInsets.only(top: 35.w, bottom: 20.w),
            text: "Leave Group",
            textStyle: semiBold(
              fontSize: 14.responsiveTextSize(),
              color: AppColors.redButton,
            ),
            borderColor: AppColors.redButton,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _inviteUserSheet({
    required BuildContext context,
    // required double sixteenResponsive,
  }) {
    return ColoredBox(
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invite Users",
              style: regular(
                fontSize: context.isDesktop ? 20.sp : 30.sp,
                fontFamily: AppFontFamily.secondary,
                height: 1.35,
              ),
            ),
            21.w.verticalSpace,
            horizontalDivider(),
            21.w.verticalSpace,
            AppTextField(
              controller: TextEditingController(),
              hintText: "Search by username",
              trailingIcon: AppAssets.searchIcon,
              //(Icons.search),
            ),
            24.verticalSpace,
            _userBox(context: context),
            10.verticalSpace,
            _userBox(context: context),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _userBox({
    required BuildContext context,
  }) {
    final boxSize = context.isDesktop
        ? 48.w
        : context.isTablet
        ? 75.w
        : 68.w;
    return Container(
      height: boxSize,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            height: boxSize,
            width: boxSize,
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: context.isDesktop ? 12.w : 18.w,
            ),
            decoration: BoxDecoration(color: AppColors.greyColor),
            child: ImageWidget(type: ImageType.svg, path: AppAssets.userIcon),
          ),
          14.w.horizontalSpace,
          Text(
            "@otherpropunter_1",
            style: semiBold(
              fontSize: 16.sixteenSp(context),
              fontStyle: FontStyle.italic,
            ),
          ),
          Spacer(),
          Container(
            height: boxSize,
            width: boxSize,
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,

              vertical: context.isDesktop ? 12.w : 16.w,
            ),
            decoration: BoxDecoration(color: AppColors.primary),
            child: ImageWidget(path: AppAssets.addUser, type: ImageType.svg),
          ),
        ],
      ),
    );
  }
}
