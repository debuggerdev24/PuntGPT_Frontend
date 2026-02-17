import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/widgets/on_button_tap.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';

import '../../../../../provider/home/search_engine/search_engine_provider.dart';

class HomeScreenTabWeb extends StatelessWidget {
  const HomeScreenTabWeb({super.key, required this.selectedIndex, this.onTap});

  final int selectedIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
Logger.info(
      "is Physical Mobile ${context.isPhysicalMobile} ${context.screenWidth}",
    );
    Logger.info(
      "is Browser Mobile  ${context.isBrowserMobile} ${context.screenWidth}",
    );
    Logger.info("is Tablet ${context.isTablet} ${context.screenWidth}");
    Logger.info("is Desktop ${context.isDesktop} ${context.screenWidth}");
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton(
          context: context,
          index: 0,
          text: "PuntGPT Search Engine",
          isSelected: selectedIndex == 0,
        ),
        _tabButton(
          context: context,
          index: 1,
          text: "Classic Form Guide",
          isSelected: selectedIndex == 1,
        ),
      ],
    );
  }

  Widget _tabButton({
    required BuildContext context,
    required int index,
    required String text,
    required bool isSelected,
  }) {

    return OnMouseTap(
      onTap: () {
        context.read<SearchEngineProvider>().changeTab = index;
        if (onTap != null && index == 0) {
          onTap!.call();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: (kIsWeb) ? 45.w : 18.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          text,

          textAlign: TextAlign.center,
          style: bold(
            fontSize:context.isDesktop ? 16.sp : context.isTablet ? 22.sp : (context.isPhysicalMobile) ? 30.sp : 28.sp,
            color: isSelected ? AppColors.white : AppColors.primary,

          ),
        ),
      ),
    );
  }
}
