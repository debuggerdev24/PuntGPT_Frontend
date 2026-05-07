import 'package:puntgpt_nick/core/app_imports.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.padding,
    this.height,
    this.width,
    this.borderRadius,
    this.borderColor,
    this.textStyle,
    this.margin,
    this.isExpand,
    this.child,
    this.color,
  });

  final EdgeInsetsGeometry? padding, margin;
  final double? height, width, borderRadius;
  final Widget? child;
  final String text;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final Color? borderColor;
  final bool? isExpand;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: margin,
          padding: padding ?? EdgeInsets.symmetric(vertical: 12.wSize, horizontal: 15.wSize),

          height: height,
          width: (width == null)
              ? (isExpand ?? true)
                    ? double.maxFinite
                    : null
              : width,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            color: color ?? AppColors.white,
            border: Border.all(color: borderColor ?? AppColors.primary),
          ),

          alignment: AlignmentGeometry.center,
          child:
              child ??
              Text(
                text,
                textAlign: TextAlign.center,
                style:
                
                    textStyle ??
                    semiBold(fontSize: (kIsWeb) ? 16 : 18.sp, color: AppColors.primary),
              ),
        ),
      ),
    );
  }
}
