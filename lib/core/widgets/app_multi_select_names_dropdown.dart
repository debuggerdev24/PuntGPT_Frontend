import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';

/// Multi-select from a flat string list (jockey / trainer). Summary is comma-separated.
class AppMultiSelectNamesDropdown extends StatelessWidget {
  const AppMultiSelectNamesDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.summaryFromProvider,
    required this.selectedFromProvider,
    required this.onToggle,
    required this.onClearAll,
    this.margin,
    this.borderRadius,
    this.enabled,
  });

  final List<String> items;
  final String hintText;
  final String Function(SearchEngineProvider p) summaryFromProvider;
  final List<String> Function(SearchEngineProvider p) selectedFromProvider;
  final void Function(SearchEngineProvider p, String name) onToggle;
  final void Function(SearchEngineProvider p) onClearAll;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final bool? enabled;

  Future<void> _openSheet(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;
    final fieldSize = box.size;
    final fieldTopLeft = box.localToGlobal(Offset.zero);

    final screenH = MediaQuery.sizeOf(context).height;
    final screenW = MediaQuery.sizeOf(context).width;

    final top = fieldTopLeft.dy + fieldSize.height;
    final maxHeight = (screenH - top - 24).clamp(200.0, screenH * 0.55);
    final left = fieldTopLeft.dx.clamp(0.0, screenW - fieldSize.width);

    await showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (dialogContext) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  behavior: HitTestBehavior.opaque,
                ),
              ),
              Positioned(
                left: left,
                top: top,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
                  color: AppColors.white,
                  child: Container(
                    width: fieldSize.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
                      color: AppColors.backGroundColor,
                      border: Border.all(
                        color: AppColors.primary.setOpacity(0.12),
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxHeight),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 8.w),
                        child: Consumer<SearchEngineProvider>(
                          builder: (context, provider, _) {
                            final selected = selectedFromProvider(provider);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (selected.isNotEmpty)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 12.w,
                                        bottom: 4.h,
                                      ),
                                      child: GestureDetector(
                                        onTap: () =>
                                            onClearAll(provider),
                                        child: Text(
                                          'Clear all',
                                          style: medium(
                                            fontSize: 14.sp.clamp(12, 16),
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (items.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Text(
                                      'No items available',
                                      style: medium(
                                        fontSize: 14.sp.clamp(14, 18),
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        for (final name in items)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 8.h,
                                            ),
                                            child: _NamePickRow(
                                              label: name,
                                              isSelected:
                                                  selected.contains(name),
                                              onToggle: () =>
                                                  onToggle(provider, name),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                8.w.verticalSpace,
                                horizontalDivider(),
                                8.w.verticalSpace,
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext),
                                  child: Text(
                                    'Done',
                                    style: semiBold(
                                      fontSize: 16.sp.clamp(14, 18),
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, _) {
        final summary = summaryFromProvider(provider);
        final controller = TextEditingController(text: summary);

        return GestureDetector(
          onTap: (enabled ?? true) ? () => _openSheet(context) : null,
          child: AbsorbPointer(
            child: AppTextField(
              controller: controller,
              hintText: hintText,
              enabled: enabled ?? true,
              margin: margin,
              borderRadius: borderRadius,
              trailingIcon: AppAssets.arrowDown,
            ),
          ),
        );
      },
    );
  }
}

class _NamePickRow extends StatelessWidget {
  const _NamePickRow({
    required this.label,
    required this.isSelected,
    required this.onToggle,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final nameStyle = semiBold(
      fontSize: 15.sp.clamp(14, 17),
      color: AppColors.black,
      fontFamily: AppFontFamily.primary,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.wSize),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.setOpacity(0.12)),
      ),
      child: InkWell(
        onTap: onToggle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Text(label, style: nameStyle)),
            Checkbox(
              value: isSelected,
              checkColor: AppColors.white,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: (_) => onToggle(),
            ),
          ],
        ),
      ),
    );
  }
}
