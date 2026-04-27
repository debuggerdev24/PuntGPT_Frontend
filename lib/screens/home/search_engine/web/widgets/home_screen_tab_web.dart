import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';

class HomeScreenTabWeb extends StatelessWidget {
  const HomeScreenTabWeb({super.key, required this.selectedIndex, this.onTap});

  final int selectedIndex;
  final VoidCallback? onTap;

    @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.isMobileWeb(context)
          ? double.maxFinite
          : 350,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _tabButton(
              context: context,
              index: 0,
              text: "PuntGPT\nSearch Engine",
              isSelected: selectedIndex == 0,
            ),
            _tabButton(
              context: context,
              index: 1,
              text: "Classic Form Guide",
              isSelected: selectedIndex == 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton({
    required BuildContext context,
    required int index,
    required String text,
    required bool isSelected,
  }) {
    return Expanded(
      child: OnMouseTap(
        onTap: () {
          final provider = context.read<SearchEngineProvider>();
          provider.changeTab = index;
          if (index == 1) {
            final classicFormProvider = context.read<ClassicFormProvider>();
            classicFormProvider.getClassicFormGuide();
            classicFormProvider.getNextToGo();
          }
          if (onTap != null && index == 0) {
            onTap!.call();
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: (context.isMobileWeb) ? 26 : 14,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            border: Border.all(color: AppColors.primary),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: bold(
              fontSize: 13.5,
              // context.isDesktop
              //     ? 16.sp
              //     : context.isTablet
              //     ? 22.sp
              //     : (context.isMobileWeb)
              //     ? 30.sp
              //     : 15.sp,
              color: isSelected ? AppColors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
