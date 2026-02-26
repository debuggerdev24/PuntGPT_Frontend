import 'dart:ui';
import 'package:puntgpt_nick/core/app_imports.dart';

class AppCheckBox extends StatelessWidget {
  const AppCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size,
    this.duration = const Duration(milliseconds: 280),
    this.label,
    this.borderRadius = 0.0,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double? size;
  final Duration duration;
  final Widget? label;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return OnMouseTap(
      onTap: () => onChanged(!value),
      child: Semantics(
        container: true,
        role: value
            ? SemanticsRole.menuItemCheckbox
            : SemanticsRole.menuItemCheckbox,
        checked: value,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              width: size ?? 22.w.clamp(18, 24),
              height: size ?? 22.w.clamp(18, 24),
              duration: duration,
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: value
                      ? AppColors.primary
                      : AppColors.primary.setOpacity(0.1),
                  width: 1.6,
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(1.6),
              child: AnimatedSwitcher(
                duration: duration,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: value
                    ? ImageWidget(
                        type: ImageType.svg,
                        path: AppAssets.done,

                        key: const ValueKey('checked'),
                        color: AppColors.primary,
                      )
                    : const SizedBox.shrink(key: ValueKey('unchecked')),
              ),
            ),
            if (label != null) ...[
              SizedBox(width: 10.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: (Responsive.isMobileWeb(context)) ? 0 : 2.5,
                  ),
                  child: label!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
