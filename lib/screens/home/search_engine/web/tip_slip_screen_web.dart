import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/search_engine/tip_slip_model.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_section_shimmers_web.dart';

class TipSlipScreenWeb extends StatelessWidget {
  const TipSlipScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    // final bodyWidth = context.isBrowserMobile
    //     ? double.maxFinite
    //     : 700;
    // final twentyResponsive = context.isDesktop
    //     ? 20.sp
    //     : context.isTablet
    //     ? 28.sp
    //     : (context.isBrowserMobile)
    //     ? 36.sp
    //     : 20.sp;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: (context.isMobileView)
                ? 0
                : (context.isTablet)
                ? 100
                : 200,
          ),
          child: Consumer<SearchEngineProvider>(
            builder: (context, provider, child) {
              if (provider.tipSlips == null) {
                return WebSectionShimmers.tipSlipScreenShimmer(
                  context: context,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  topBar(context: context),
                  ...provider.tipSlips!
                      .asMap()
                      .entries
                      .map(
                        (entry) => _tipSlipItemWeb(
                          context: context,
                          tipSlip: entry.value,
                          index: entry.key,
                          provider: provider,
                        ),
                      ),
                  SizedBox(height: 60),
                ],
              );
            },
          ),
        ),
        //* askPuntGPT button website
        Align(
          alignment: Alignment.bottomRight,
          child: askPuntGPTButtonWeb(context: context),
        ),
      ],
    );
  }

  Widget _tipSlipItemWeb({
    required BuildContext context,
    required TipSlipModel tipSlip,
    required int index,
    required SearchEngineProvider provider,
  }) {
    final selection = tipSlip.selection;
    final horizontalMargin = (context.isMobileView) ? 12.0 : 30.0;
    return OnMouseTap(
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10,
          left: horizontalMargin,
          right: horizontalMargin,
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(5),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: (selection.silksImage.isNotEmpty)
                  ? ImageWidget(
                      path: selection.silksImage,
                      type: ImageType.svg,
                      width: 26,
                      height: 26,
                      placeholder: Shimmer.fromColors(
                        baseColor: AppColors.shimmerBaseColor,
                        highlightColor: AppColors.shimmerHighlightColor,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.image_not_supported_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
              // Text(
              //     selection.number.toString(),
              //     style: semiBold(fontSize: 12),
              //   ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${selection.number}. ${selection.horseName} (${selection.barrier})",
                    style: semiBold(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3),
                  Text(
                    "${selection.trackName} • R${selection.raceNumber} • ${selection.distance}m",
                    style: medium(
                      fontSize: 12,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            OnMouseTap(
              onTap: launchUnibetUrl,
              child: ImageWidget(
                path: AppAssets.unibatLogo,
                height: 24,
                type: ImageType.asset,
              ),
            ),
            SizedBox(width: 6),
            Text(selection.unibetFixedOddsWin, style: bold(fontSize: 15)),
            SizedBox(width: 6),
            OnMouseTap(
              onTap: () {
                showDeleteTipSlipConfirmationDialog(
                  context: context,
                  onConfirmDelete: () {
                    final removedId = tipSlip.id;
                    provider.removeTipSlipAt(index);
                    AppToast.success(
                      context: context,
                      message: "Removed from tip slip successfully",
                    );
                    provider.removeFromTipSlip(tipSlipId: removedId.toString());
                  },
                );
              },
              child: Icon(Icons.delete_outline_rounded, color: AppColors.red),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteTipSlipConfirmationDialog({
    required BuildContext context,
    required VoidCallback onConfirmDelete,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            "Are you sure you want\nto remove this tip?",
            style: regular(color: AppColors.black, fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(dialogContext);
              },
              child: Text(
                "Cancel",
                style: regular(color: AppColors.black, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop(dialogContext);
                onConfirmDelete.call();
              },
              child: Text(
                "Yes",
                style: regular(color: AppColors.red, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget topBar({required BuildContext context}) {
    double horizontalPadding = (!context.isMobileView) ? 0 : 18;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: (!context.isMobileView) ? 60 : 13,
            bottom: 14,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Row(
            spacing: 14,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: (!context.isMobileWeb)
                      ? 4
                      : (context.isMobileWeb)
                      ? 2
                      : 0,
                ),
                child: OnMouseTap(
                  onTap: () {
                    WebRouter.indexedStackNavigationShell!.goBranch(2);
                  },
                  child: Icon(Icons.arrow_back_ios_rounded, size: 14),
                ),
              ),
              Text(
                "Tip Slip",
                style: regular(
                  fontSize: 22,
                  fontFamily: AppFontFamily.secondary,
                  height: 1,
                ),
              ),
              SizedBox(width: 25),
            ],
          ),
        ),
        horizontalDivider(),
        SizedBox(height: 20),
      ],
    );
  }
}
