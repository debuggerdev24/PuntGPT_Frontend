import 'package:country_picker/country_picker.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';

class PhoneCountryField extends StatelessWidget {
  const PhoneCountryField({
    super.key,
    required this.provider,
    this.hintText = 'Mobile number',
    this.hintStyle,
  });

  final AuthProvider provider;
  final String hintText;
  final TextStyle? hintStyle;

  /// Max digits for the selected country from [Country.example]. Falls back to 15 if unknown.
  static int _maxLengthForCountry(Country country) {
    final example = country.example.toString();
    final digits = example.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? 15 : digits.length;
  }

  void _openCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        provider.selectedPhoneCountry = country;
        final maxLen = _maxLengthForCountry(country);
        final digits = provider.phoneCtr.text.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length > maxLen) {
          provider.phoneCtr.text = digits.substring(0, maxLen);
          provider.phoneCtr.selection = TextSelection.collapsed(
            offset: provider.phoneCtr.text.length,
          );
        }
      },
      countryListTheme: CountryListThemeData(
        flagSize: 24,
        backgroundColor: AppColors.white,
        textStyle: medium(fontSize: 16.sp, color: AppColors.primary),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.black, width: 1.7),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final country =
            authProvider.selectedPhoneCountry ??
            CountryService().findByCode("au")!;
        final maxLen = _maxLengthForCountry(country);

        return TextFormField(
          controller: authProvider.phoneCtr,
          keyboardType: TextInputType.phone,
          maxLength: maxLen,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(maxLen),
          ],
          validator: (_) => FieldValidators().phoneNumberForCountry(
            authProvider.phoneCtr.text.trim(),
            country,
          ),

          style: medium(fontSize: 16.fSize),
          decoration: InputDecoration(
            hintText: (country.fullExampleWithPlusSign ?? '')
                .replaceFirst('+${country.phoneCode}', '')
                .trim(),
            hintStyle:
                hintStyle ??
                medium(
                  fontSize: 14.fSize,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
            counterText: '',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.adaptiveSpacing(context),
              vertical: 17.adaptiveSpacing(context),
            ),
            filled: true,
            fillColor: AppColors.white,
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: 23.adaptiveSpacing(context),
                right: 8.adaptiveSpacing(context),
              ),
              child: Text(
                '+${country.phoneCode}',
                style: medium(
                  fontSize: 16.fSize,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
            // suffixIconConstraints: BoxConstraints(
            //   minHeight: 28.adaptiveSpacing(context),
            //   maxHeight: 28.adaptiveSpacing(context),
            //   minWidth: 48.adaptiveSpacing(context),
            //   maxWidth: 80.adaptiveSpacing(context),
            // ),
            suffixIcon: InkWell(
              onTap: () => _openCountryPicker(context),
              borderRadius: BorderRadius.zero,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                  borderRadius: BorderRadius.circular(3),

                ),
                margin: EdgeInsets.only(
                  right: 10.adaptiveSpacing(context),
                  top: 10.adaptiveSpacing(context),
                  bottom: 10.adaptiveSpacing(context),
                ),
                padding: EdgeInsets.only(
                  left: 6.adaptiveSpacing(context),
                  right: 3.adaptiveSpacing(context),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6.adaptiveSpacing(context),
                  children: [
                    Text(
                      country.flagEmoji,
                      style: const TextStyle(fontSize: 18),
                    ),

                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.primary),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
            errorStyle: medium(fontSize: 14.fSize, color: AppColors.red),
          ),
        );
      },
    );
  }
}

/// Same as [PhoneCountryField] but for [AccountProvider] (personal details). Supports [readOnly].
class PhoneCountryFieldForAccount extends StatelessWidget {
  const PhoneCountryFieldForAccount({
    super.key,
    required this.provider,
    this.readOnly = false,
    this.hintText = 'Mobile number',
    this.hintStyle,
  });

  final AccountProvider provider;
  final bool readOnly;
  final String hintText;
  final TextStyle? hintStyle;

  static int _maxLengthForCountry(Country country) {
    final example = country.example.toString();
    final digits = example.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? 15 : digits.length;
  }

  void _openCountryPicker(BuildContext context) {
    if (readOnly) return;
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        provider.selectedPhoneCountry = country;
        final maxLen = _maxLengthForCountry(country);
        final digits = provider.phoneCtr.text.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length > maxLen) {
          provider.phoneCtr.text = digits.substring(0, maxLen);
          provider.phoneCtr.selection = TextSelection.collapsed(
            offset: provider.phoneCtr.text.length,
          );
        }
      },
      countryListTheme: CountryListThemeData(
        flagSize: 24,
        backgroundColor: AppColors.white,
        textStyle: medium(fontSize: 16.sp, color: AppColors.primary),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.black, width: 1.7),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, _) {
        final country =
            accountProvider.selectedPhoneCountry ??
            CountryService().findByCode('au')!;
        final maxLen = _maxLengthForCountry(country);

        return TextFormField(
          controller: accountProvider.phoneCtr,
          keyboardType: TextInputType.phone,
          maxLength: maxLen,
          readOnly: readOnly,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(maxLen),
          ],
          validator: readOnly
              ? null
              : (_) => FieldValidators().phoneNumberForCountry(
                  accountProvider.phoneCtr.text.trim(),
                  country,
                ),
          style: medium(fontSize: context.isBrowserMobile ? 28.sp : 16.sp),
          decoration: InputDecoration(
            hintText: (country.fullExampleWithPlusSign ?? '')
                .replaceFirst('+${country.phoneCode}', '')
                .trim(),
            hintStyle:
                hintStyle ??
                medium(
                  fontSize: context.isBrowserMobile ? 28.sp : 14.sp,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
            counterText: '',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 17.adaptiveSpacing(context),
            ),
            filled: true,
            fillColor: AppColors.white,
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 23.w, right: 8.w),
              child: Text(
                '+${country.phoneCode}',
                style: medium(
                  fontSize: context.isBrowserMobile ? 28.sp : 16.sp,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
            suffixIconConstraints: readOnly
                ? null
                : BoxConstraints(
                    minHeight: 28.adaptiveSpacing(context),
                    maxHeight: 28.adaptiveSpacing(context),
                    minWidth: 48.adaptiveSpacing(context),
                    maxWidth: 80.adaptiveSpacing(context),
                  ),
            suffixIcon: readOnly
                ? null
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _openCountryPicker(context),
                      borderRadius: BorderRadius.zero,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              country.flagEmoji,
                              style: TextStyle(
                                fontSize: context.isBrowserMobile
                                    ? 22.sp
                                    : 18.sp,
                              ),
                            ),
                            4.w.horizontalSpace,
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: context.isBrowserMobile ? 22.w : 18.w,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
            errorStyle: medium(
              fontSize: context.isBrowserMobile ? 24.sp : 13.sp,
              color: AppColors.red,
            ),
          ),
        );
      },
    );
  }
}
