import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/core/widgets/app_text_field.dart';


class AppTextFieldDropdown extends StatelessWidget {
  const AppTextFieldDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChange,
    required this.hintText,
    this.hintStyle,
    this.textStyle,
    this.errorStyle,
    this.borderRadius,
    this.validator,
    this.autoValidateMode,
    this.margin,
    this.enabled,
  });

  final List<String> items;
  final String? selectedValue;
  final Function(String) onChange;
  final String hintText;
  final TextStyle? hintStyle, textStyle, errorStyle;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final bool? enabled;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: selectedValue);

    return GestureDetector(
      onTap: enabled ?? true ? () => _showDropdownMenu(context) : null,
      child: AbsorbPointer(
        child: AppTextField(
          controller: controller,
          hintText: hintText,
          validator: validator,
          textStyle: textStyle,
          hintStyle: hintStyle,
          errorStyle: errorStyle,
          enabled: enabled ?? true,
          margin: margin,
          borderRadius: borderRadius,
          autovalidateMode: autoValidateMode,
          trailingIcon: AppAssets.arrowDown,
        ),
      ),
    );
  }

  Future<void> _showDropdownMenu(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    // Calculate available space below and above
    final spaceBelow = screenHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;
    final maxDropdownHeight = 300.0;
    final minSpaceRequired = 150.0; // Minimum space needed to open below
    
    // Determine if dropdown should open above or below
    // Only open above if there's really not enough space below (less than minSpaceRequired)
    // AND there's more space above than below
    final shouldOpenAbove = spaceBelow < minSpaceRequired && spaceAbove > spaceBelow;
    
    // Calculate position - show below by default, above if needed
    // Ensure the dropdown doesn't go off-screen
    double topPosition;
    double actualDropdownHeight;
    
    if (shouldOpenAbove) {
      // Position above: bottom of dropdown should be just above the top of the field
      // Use available space above, but don't go too far up
      final usableSpaceAbove = spaceAbove.clamp(0.0, maxDropdownHeight);
      actualDropdownHeight = usableSpaceAbove < maxDropdownHeight ? usableSpaceAbove : maxDropdownHeight;
      
      // Position so bottom of dropdown is just above top of field (with 4px gap)
      final gap = 4.0;
      topPosition = (offset.dy - actualDropdownHeight - gap).clamp(0.0, screenHeight - actualDropdownHeight);
    } else {
      // Position below: start from bottom of field
      final usableSpaceBelow = spaceBelow.clamp(0.0, maxDropdownHeight);
      actualDropdownHeight = usableSpaceBelow < maxDropdownHeight ? usableSpaceBelow : maxDropdownHeight;
      topPosition = (offset.dy + size.height).clamp(0.0, screenHeight - actualDropdownHeight);
    }
    
    // Ensure dropdown doesn't go off screen horizontally
    final leftPosition = offset.dx.clamp(0.0, screenWidth - size.width);

    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (BuildContext dialogContext) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dismissible background
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  behavior: HitTestBehavior.opaque,
                ),
              ),
              // Dropdown menu
              Positioned(
                left: leftPosition,
                top: topPosition,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(borderRadius ?? 0),
                  color: AppColors.white,
                  child: Container(
                    width: size.width,
                    constraints: BoxConstraints(
                      maxHeight: actualDropdownHeight,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius ?? 0),
                      color: AppColors.white,
                      border: Border.all(
                        color: AppColors.primary.setOpacity(0.1),
                      ),
                    ),
                    child: items.length > 0 && (actualDropdownHeight < maxDropdownHeight || items.length > 5)
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final isSelected = item == selectedValue;

                              return InkWell(
                                onTap: () {
                                  onChange(item);
                                  Navigator.pop(dialogContext);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.setOpacity(0.1)
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    item,
                                    style:
                                        textStyle ??
                                        medium(
                                          fontSize: 16.sp.clamp(14, 18),
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.black,
                                        ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: items.map((item) {
                              final isSelected = item == selectedValue;
                              return InkWell(
                                onTap: () {
                                  onChange(item);
                                  Navigator.pop(dialogContext);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.setOpacity(0.1)
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    item,
                                    style:
                                        textStyle ??
                                        medium(
                                          fontSize: 16.sp.clamp(14, 18),
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.black,
                                        ),
                                  ),
                                ),
                              );
                            }).toList(),
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
}
