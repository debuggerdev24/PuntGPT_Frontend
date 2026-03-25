import 'package:flutter_svg/flutter_svg.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Consumer<AccountProvider>(
        builder: (context, provider, child) {
          bool readOnly = (provider.isEdit) ? false : true;
          return Stack(
            children: [
              //todo screen
              Column(
                children: [
                  //todo top bar
                  topBar(context, provider),
                  //todo personal details
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 25.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          28.h.verticalSpace,
                          //todo --------------> name
                          Text(
                            "Name",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.nameCtr,
                            hintText: "Enter Your Name",
                            textInputAction: TextInputAction.next,
                            textStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 32.sp
                                  : 16.sp,
                            ),
                            readOnly: readOnly,
                            hintStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                            validator: (value) =>
                                FieldValidators().name(value, "Name"),
                          ),
                          //todo --------------> email
                          14.h.verticalSpace,
                          Text(
                            "Email",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.emailCtr,
                            hintText: "Enter Your Email",
                            textInputAction: TextInputAction.next,
                            textStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 32.sp
                                  : 16.sp,
                            ),
                            readOnly: readOnly,
                            hintStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                            validator: (value) =>
                                FieldValidators().email(value),
                          ),
                          //* --------------> phone
                          14.w.verticalSpace,
                          Text(
                            "Phone",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                          ),
                          6.h.verticalSpace,
                          if (readOnly)
                            AppTextField(
                              controller: provider.phoneCtr,
                              hintText: "Enter Phone",
                              readOnly: true,
                              textInputAction: TextInputAction.next,
                              textStyle: medium(
                                fontSize: (context.isBrowserMobile)
                                    ? 32.sp
                                    : 16.sp,
                              ),
                              hintStyle: medium(
                                fontSize: (context.isBrowserMobile)
                                    ? 28.sp
                                    : 14.sp,
                              ),
                            )
                          else
                            PhoneCountryFieldForAccount(
                              provider: provider,
                              readOnly: false,
                            ),
                          //todo --------------> address
                          14.h.verticalSpace,
                          Text(
                            "Address Line 1",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.addressLine1Ctr,
                            hintText: "Enter Address Line 1",
                            readOnly: readOnly,
                            textInputAction: TextInputAction.next,
                            textStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 32.sp
                                  : 16.sp,
                            ),
                            hintStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                            validator: (value) => FieldValidators().required(
                              value,
                              "Address Line 1",
                            ),
                          ),
                          14.h.verticalSpace,
                          Text(
                            "Address Line 2",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.addressLine2Ctr,
                            hintText: "Enter Address Line 2",
                            readOnly: readOnly,
                            textInputAction: TextInputAction.next,
                            textStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 32.sp
                                  : 16.sp,
                            ),
                            hintStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                            validator: (value) => FieldValidators().required(
                              value,
                              "Address Line 2",
                            ),
                          ),
                          14.h.verticalSpace,
                          Text(
                            "State",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                          ),
                          6.w.verticalSpace,
                          AppTextField(
                            controller: provider.stateCtr,
                            hintText: "Enter State",
                            readOnly: readOnly,
                            textInputAction: TextInputAction.next,
                            textStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 32.sp
                                  : 16.sp,
                            ),
                            hintStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                            validator: (value) =>
                                FieldValidators().required(value, "State"),
                          ),
                          14.w.verticalSpace,
                          Text(
                            "Suburb",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.suburbCtr,
                            hintText: "Enter Suburb",
                            readOnly: readOnly,
                            textInputAction: TextInputAction.next,
                            textStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 32.sp
                                  : 16.sp,

                            ),
                            hintStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                            validator: (value) =>
                                FieldValidators().required(value, "Suburb"),
                          ),
                          14.h.verticalSpace,
                          Text(
                            "Post Code",
                            style: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                          ),
                          6.h.verticalSpace,
                          AppTextField(
                            controller: provider.postCodeCtr,
                            hintText: "Enter Post Code",
                            readOnly: readOnly,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 32.sp
                                  : 16.sp,
                            ),
                            hintStyle: medium(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 14.sp,
                            ),
                            validator: (value) {
                              final r = FieldValidators().required(
                                value,
                                "Post Code",
                              );
                              if (r != null) return r;
                              final min = FieldValidators().minLength(value, 3);
                              if (min != null) return min;
                              return FieldValidators().maxLength(value, 10);
                            },
                          ),
                          // Spacer(),
                          if (provider.isEdit)
                            AppFilledButton(
                              text: "Save Changes",
                              textStyle: semiBold(
                                fontSize: (context.isBrowserMobile)
                                    ? 28.sp
                                    : 18.sp,
                                color: AppColors.white,
                              ),
                              onTap: () {
                                deBouncer.run(() {
                                  if (_formKey.currentState!.validate()) {
                                    provider.updateProfile(
                                      onSuccess: () {
                                        AppToast.success(
                                          context: context,
                                          message:
                                              "Profile updated successfully.",
                                        );
                                      },
                                      onFailed: (error) {
                                        AppToast.success(
                                          context: context,
                                          message: error,
                                        );
                                      },
                                      onNoChanges: () {
                                        AppToast.info(
                                          context: context,
                                          message: "No changes found.",
                                        );
                                      },
                                    );
                                    provider.setIsEdit = false;
                                  }
                                });
                              },
                              margin: EdgeInsets.only(top: 22.w),
                            ),

                          AppOutlinedButton(
                            text: "Change Password",
                            onTap: () {
                              context.pushNamed(AppRoutes.changePassword.name);
                            },

                            textStyle: semiBold(
                              fontSize: (context.isBrowserMobile)
                                  ? 28.sp
                                  : 18.sp,
                            ),
                            margin: EdgeInsets.only(
                              bottom: 16.w,
                              top: 16.w, //220
                            ), //
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //* progress indicator
              if (provider.isUpdateProfileLoading) FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget topBar(BuildContext context, AccountProvider provider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 7.w, 25.w, 7.w),

          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal Details",
                    style: regular(
                      fontSize: (context.isBrowserMobile) ? 40.sp : 24.sp,
                      fontFamily: AppFontFamily.secondary,
                      height: 1.11,
                    ),
                  ),
                  Text(
                    "Manage your name, email, etc.",
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 26.sp : 14.sp,

                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              Spacer(),
              if (provider.isEdit)
                TextButton(
                  onPressed: () {
                    _formKey.currentState?.reset();

                    provider.setIsEdit = !(provider.isEdit);
                  },

                  child: Text(
                    "Cancel",
                    style: bold(
                      fontSize: (context.isBrowserMobile) ? 32.sp : 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                )
              else
                OnMouseTap(
                  child: GestureDetector(
                    onTap: () {
                      provider.setIsEdit = !(provider.isEdit);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      spacing: (context.isBrowserMobile) ? 8 : 6.w,
                      children: [
                        SvgPicture.asset(
                          AppAssets.edit,
                          width: (context.isBrowserMobile) ? 32.w : 16.w,
                        ),
                        Text(
                          "Edit",
                          style: bold(
                            fontSize: (context.isBrowserMobile) ? 32.sp : 17.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}
