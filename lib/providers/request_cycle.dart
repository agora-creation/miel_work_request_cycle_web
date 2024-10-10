import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_request_cycle_web/services/fm.dart';
import 'package:miel_work_request_cycle_web/services/request_cycle.dart';
import 'package:miel_work_request_cycle_web/services/user.dart';

class RequestCycleProvider with ChangeNotifier {
  final RequestCycleService _cycleService = RequestCycleService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required String shopName,
    required String shopUserName,
    required String shopUserEmail,
    required String shopUserTel,
    required String remarks,
  }) async {
    String? error;
    if (shopName == '') return '店舗名は必須入力です';
    if (shopUserName == '') return '使用者名は必須入力です';
    if (shopUserEmail == '') return '使用者メールアドレスは必須入力です';
    if (shopUserTel == '') return '使用者電話番号は必須入力です';
    try {
      await FirebaseAuth.instance.signInAnonymously().then((value) {
        String id = _cycleService.id();
        _cycleService.create({
          'id': id,
          'shopName': shopName,
          'shopUserName': shopUserName,
          'shopUserEmail': shopUserEmail,
          'shopUserTel': shopUserTel,
          'remarks': remarks,
          'approval': 0,
          'approvedAt': DateTime.now(),
          'approvalUsers': [],
          'createdAt': DateTime.now(),
        });
      });
      //通知
      // List<UserModel> sendUsers = [];
      // sendUsers = await _userService.selectList();
      // if (sendUsers.isNotEmpty) {
      //   for (UserModel user in sendUsers) {
      //     _fmService.send(
      //       token: user.token,
      //       title: '社外申請',
      //       body: '自転車置き場使用の申込がありました',
      //     );
      //   }
      // }
    } catch (e) {
      error = '申込に失敗しました';
    }
    return error;
  }
}
