import 'package:puntgpt_nick/core/app_imports.dart';

class SearchCheckboxField extends StatelessWidget {
  const SearchCheckboxField({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onTap,
    this.verticalPadding,
  });

  final String title;
  final bool isChecked;
  final VoidCallback? onTap;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 18.w),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: semiBold(
                fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: (context.isBrowserMobile) ? 40.sp : 22.sp,
              height: (context.isBrowserMobile) ? 40.sp : 22.sp,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isChecked ? Colors.green : AppColors.primary.setOpacity(0.15),
                ),
                borderRadius: BorderRadius.circular(1),
                color: isChecked ? Colors.green : Colors.transparent,
              ),
              child: isChecked
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: (context.isBrowserMobile) ? 30.sp : 18.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
