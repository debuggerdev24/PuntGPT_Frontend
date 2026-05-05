import 'package:puntgpt_nick/core/app_imports.dart';

class SearchCheckboxField extends StatelessWidget {
  const SearchCheckboxField({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onTap,
    this.verticalPadding,
    this.margin,
  });

  final String title;
  final bool isChecked;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.symmetric(vertical: verticalPadding ?? 18.w),
      child: OnMouseTap(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: semiBold(
                fontSize: (context.isMobileWeb)
                    ? 36.fSize
                    : (kIsWeb)
                    ? 14
                    : 16.sp,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: (context.isMobileWeb)
                  ? 40.sp
                  : (kIsWeb)
                  ? 20
                  : 22.sp,
              height: (context.isMobileWeb)
                  ? 40.sp
                  : (kIsWeb)
                  ? 20
                  : 22.sp,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isChecked
                      ? Colors.green
                      : AppColors.primary.setOpacity(0.15),
                ),
                borderRadius: BorderRadius.circular(1),
                color: isChecked ? Colors.green : Colors.transparent,
              ),
              child: isChecked
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: (context.isMobileWeb)
                          ? 30.sp
                          : (kIsWeb)
                          ? 16
                          : 18.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
