import 'package:country_picker/country_picker.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/account/profile_model.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/services/account/account_api_service.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';

class AccountProvider extends ChangeNotifier {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();
  TextEditingController currentPassCtr = TextEditingController();
  TextEditingController newPassCtr = TextEditingController();
  TextEditingController confirmPassCtr = TextEditingController();
  TextEditingController addressLine1Ctr = TextEditingController();
  TextEditingController addressLine2Ctr = TextEditingController();
  TextEditingController suburbCtr = TextEditingController();
  TextEditingController postCodeCtr = TextEditingController();

  /// Selected country for phone (national number in phoneCtr). Used for profile update.
  Country? _selectedPhoneCountry;
  Country? get selectedPhoneCountry => _selectedPhoneCountry;
  set selectedPhoneCountry(Country? value) {
    _selectedPhoneCountry = value;
    notifyListeners();
  }

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
    if (LocaleStorageService.acccessToken.isEmpty) return;
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
        addressLine1Ctr.text = profile.addressLine1 ?? '';
        addressLine2Ctr.text = profile.addressLine2 ?? '';
        suburbCtr.text = profile.suburb ?? '';
        postCodeCtr.text = profile.postCode ?? '';
        _parsePhoneAndCountry(profile.phone);
        notifyListeners();
      },
    );
  }

  /// Parses E.164 phone (e.g. +61412345678) into selectedPhoneCountry + national digits in phoneCtr.
  void _parsePhoneAndCountry(String fullPhone) {
    final digits = fullPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      selectedPhoneCountry = null;
      phoneCtr.clear();
      return;
    }
    final country = _findCountryByPhoneCode(digits);
    if (country != null) {
      selectedPhoneCountry = country;
      final codeLen = (country.phoneCode).replaceAll(RegExp(r'[^0-9]'), '').length;
      phoneCtr.text = codeLen < digits.length ? digits.substring(codeLen) : '';
    } else {
      selectedPhoneCountry = null;
      phoneCtr.text = digits;
    }
  }

  Country? _findCountryByPhoneCode(String digits) {
    for (var len = 3; len >= 1; len--) {
      if (digits.length >= len) {
        final code = digits.substring(0, len);
        final iso = _phoneCodeToIso[code];
        if (iso != null) {
          try {
            final c = CountryService().findByCode(iso);
            if (c != null) return c;
          } catch (_) {}
        }
      }
    }
    return null;
  }

  static const Map<String, String> _phoneCodeToIso = {
    '1': 'us', '7': 'ru', '20': 'eg', '27': 'za', '30': 'gr', '31': 'nl', '32': 'be', '33': 'fr', '34': 'es', '36': 'hu', '39': 'it', '40': 'ro', '41': 'ch', '43': 'at', '44': 'gb', '45': 'dk', '46': 'se', '47': 'no', '48': 'pl', '49': 'de', '51': 'pe', '52': 'mx', '53': 'cu', '54': 'ar', '55': 'br', '56': 'cl', '57': 'co', '58': 've', '60': 'my', '61': 'au', '62': 'id', '63': 'ph', '64': 'nz', '65': 'sg', '66': 'th', '81': 'jp', '82': 'kr', '84': 'vn', '86': 'cn', '90': 'tr', '91': 'in', '92': 'pk', '93': 'af', '94': 'lk', '98': 'ir',
  };

  //todo update profile
  bool isUpdateProfileLoading = false;
  Future<void> updateProfile({
    required Function() onSuccess,
    required Function(String error) onFailed,
    required Function() onNoChanges,
  }) async {
    final name = nameCtr.text.trim();
    final email = emailCtr.text.trim();
    final phone = _selectedPhoneCountry != null
        ? '+${_selectedPhoneCountry!.phoneCode}${phoneCtr.text.replaceAll(RegExp(r'[^0-9]'), '')}'
        : phoneCtr.text.trim();
    final countryName = _selectedPhoneCountry?.name ?? profile.country ?? '';
    final addr1 = addressLine1Ctr.text.trim();
    final addr2 = addressLine2Ctr.text.trim();
    final sub = suburbCtr.text.trim();
    final post = postCodeCtr.text.trim();

    final noChanges =
        name == profile.name.trim() &&
        email == profile.email.trim() &&
        phone == profile.phone.trim() &&
        countryName == (profile.country ?? '').trim() &&
        addr1 == (profile.addressLine1 ?? '').trim() &&
        addr2 == (profile.addressLine2 ?? '').trim() &&
        sub == (profile.suburb ?? '').trim() &&
        post == (profile.postCode ?? '').trim();

    if (noChanges) {
      onNoChanges.call();
      return;
    }
    isUpdateProfileLoading = true;
    notifyListeners();
    final data = {
      "name": name,
      "phone": phone,
      "email": email,
      "address_line_1": addr1,
      "address_line_2": addr2,
      "suburb": sub,
      "post_code": post,
      "country": countryName,
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
