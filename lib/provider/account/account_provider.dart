import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/account/profile_model.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/services/account/account_api_service.dart';

class AccountProvider extends ChangeNotifier {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();
  TextEditingController currentPassCtr = TextEditingController();
  TextEditingController newPassCtr = TextEditingController();
  TextEditingController confirmPassCtr = TextEditingController();

  late ProfileModel profile;
  late List<SubscriptionPlanModel> plans;
  int selectedPlanId = 0;
  bool _currentPassObscure = true,
      _newPassObscure = true,
      _confirmPassObscure = true,
      _isEdit = false,
      _isShowCurrentPlan = false,
      _isShowSelectedPlan = false,
      _isShowChangePassword = false;

  bool get showCurrentPlan => _isShowCurrentPlan;
  bool get showChangePassword => _isShowChangePassword;
  bool get showSelectedPlan => _isShowSelectedPlan;

  int _selectedTab = 0;
  int get selectedAccountTabWeb => _selectedTab;

  void setIsShowSelectedPlan({required bool showSelectedPlan, int? planIndex}) {
    _isShowSelectedPlan = !_isShowSelectedPlan;
    selectedPlanId = planIndex ?? 1;
    notifyListeners();
  }

  set setIsShowCurrentPlan(bool value) {
    _isShowCurrentPlan = !_isShowCurrentPlan;
    notifyListeners();
  }

  set setIsShowChangePassword(bool value) {
    _isShowChangePassword = !_isShowChangePassword;
    notifyListeners();
  }

  set setAccountTabIndex(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  bool get currentPassObscure => _currentPassObscure;
  bool get newPassObscure => _newPassObscure;
  bool get confirmPassObscure => _confirmPassObscure;
  bool get isEdit => _isEdit;

  set setIsEdit(bool value) {
    _isEdit = value;
    notifyListeners();
  }

  void resetPasswordVisibility() {
    _currentPassObscure = true;
    _newPassObscure = true;
    _confirmPassObscure = true;
    notifyListeners();
  }

  set currentPassObscure(bool value) {
    _currentPassObscure = value;
    notifyListeners();
  }

  set newPassObscure(bool value) {
    _newPassObscure = value;
    notifyListeners();
  }

  set confirmPassObscure(bool value) {
    _confirmPassObscure = value;
    notifyListeners();
  }

  Future<void> getProfile() async {
    final result = await AccountApiService.instance.getProfile();
    result.fold(
      (l) {
        Logger.info("Error in get profile methode${l.errorMsg}");
      },
      (r) {
        final data = r["data"];
        profile = ProfileModel.fromJson(data);
        nameCtr.text = profile.name;
        emailCtr.text = profile.email;
        phoneCtr.text = profile.phone;
        notifyListeners();
      },
    );
  }

  //todo update profile
  bool isUpdateProfileLoading = false;
  Future<void> updateProfile({
    required Function() onSuccess,
    required Function(String error) onFailed,
    required Function() onNoChanges,
  }) async {
    //todo check the profile has been changed or not.
    final name = nameCtr.text.trim();
    final email = emailCtr.text.trim();
    final phone = phoneCtr.text.trim();

    final noChanges =
        name == profile.name.trim() &&
        email == profile.email.trim() &&
        phone == profile.phone.trim();

    if (noChanges) {
      onNoChanges.call();
      return;
    }
    isUpdateProfileLoading = true;
    notifyListeners();
    final data = {
      "name": nameCtr.text.trim(),
      "phone": phoneCtr.text.trim(),
      "email": emailCtr.text.trim(),
    };
    final result = await AccountApiService.instance.updateProfile(data: data);
    result.fold(
      (l) {
        onFailed.call(l.errorMsg);
        Logger.error(l.errorMsg);
      },
      (r) {
        onSuccess.call();
        getProfile();
      },
    );
    isUpdateProfileLoading = false;
    notifyListeners();
  }

  //todo update password
  bool isUpdatePasswordLoading = false;
  Future<void> updatePassword({
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    isUpdatePasswordLoading = true;
    notifyListeners();
    final data = {
      "current_password": currentPassCtr.text.trim(),
      "new_password": newPassCtr.text.trim(),
      "confirm_password": confirmPassCtr.text.trim(),
    };
    final result = await AccountApiService.instance.updatePassword(data: data);
    result.fold(
      (l) {
        onError.call(l.errorMsg);
      },
      (r) {
        onSuccess.call();
      },
    );
    newPassCtr.clear();
    currentPassCtr.clear();
    confirmPassCtr.clear();
    isUpdatePasswordLoading = false;
    notifyListeners();
  }

  // todo get subscription plans
  Future<void> getSubscriptionPlans({
    // required Function onSuccess,
    required Function(String error) onFailed,
  }) async {
    final result = await AccountApiService.instance.getSubscriptionPlans();

    result.fold(
      (l) {
        onFailed.call(l.errorMsg);
      },
      (r) {
        final data = r["data"] as List; //data
        plans = data.map((e) => SubscriptionPlanModel.fromJson(e)).toList();
        notifyListeners();
      },
    );
  }
}
