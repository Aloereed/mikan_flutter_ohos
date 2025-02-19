import 'package:flutter/material.dart';

import '../internal/extension.dart';
import '../internal/http.dart';
import '../internal/repo.dart';
import 'base_model.dart';

class RegisterModel extends BaseModel {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _qqController = TextEditingController();

  TextEditingController get userNameController => _userNameController;

  TextEditingController get passwordController => _passwordController;

  TextEditingController get emailController => _emailController;

  TextEditingController get qqController => _qqController;

  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  bool _loading = false;

  bool get loading => _loading;

  bool _showPassword = false;

  bool get showPassword => _showPassword;

  set showPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  Future<void> submit(VoidCallback registerSuccess) async {
    _loading = true;
    notifyListeners();
    final Resp tokenResp = await Repo.refreshRegisterToken();
    if (!tokenResp.success) {
      _loading = false;
      notifyListeners();
      return '获取注册参数失败'.toast();
    }
    final String token = tokenResp.data;
    if (token.isNullOrBlank) {
      _loading = false;
      notifyListeners();
      return '获取注册参数为空，请稍候重试'.toast();
    }
    final Map<String, dynamic> registerParams = {
      'UserName': _userNameController.text,
      'Password': _passwordController.text,
      'ConfirmPassword': _confirmPasswordController.text,
      'Email': _emailController.text,
      'QQ': _qqController.text,
      '__RequestVerificationToken': token,
    };
    final Resp resp = await Repo.register(registerParams);
    _loading = false;
    notifyListeners();
    if (resp.success) {
      '注册成功'.toast();
      registerSuccess.call();
    } else {
      '注册失败，请稍候重试 ${resp.msg ?? ''}'.toast();
    }
  }

  @override
  Future<void> dispose() async {
    _userNameController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _qqController.dispose();
    super.dispose();
  }
}
