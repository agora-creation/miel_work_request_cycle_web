import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_request_cycle_web/models/user.dart';
import 'package:miel_work_request_cycle_web/services/fm.dart';
import 'package:miel_work_request_cycle_web/services/mail.dart';
import 'package:miel_work_request_cycle_web/services/request_cycle.dart';
import 'package:miel_work_request_cycle_web/services/user.dart';

class RequestCycleProvider with ChangeNotifier {
  final RequestCycleService _cycleService = RequestCycleService();
  final UserService _userService = UserService();
  final MailService _mailService = MailService();
  final FmService _fmService = FmService();

  Future<String?> check({
    required String companyName,
    required String companyUserName,
    required String companyUserEmail,
    required String companyUserTel,
    required String companyAddress,
  }) async {
    String? error;
    if (companyName == '') return '店舗名は必須入力です';
    if (companyUserName == '') return '使用者名は必須入力です';
    if (companyUserEmail == '') return '使用者メールアドレスは必須入力です';
    if (companyUserTel == '') return '使用者電話番号は必須入力です';
    if (companyAddress == '') return '住所は必須入力です';
    return error;
  }

  Future<String?> create({
    required String companyName,
    required String companyUserName,
    required String companyUserEmail,
    required String companyUserTel,
    required String companyAddress,
  }) async {
    String? error;
    if (companyName == '') return '店舗名は必須入力です';
    if (companyUserName == '') return '使用者名は必須入力です';
    if (companyUserEmail == '') return '使用者メールアドレスは必須入力です';
    if (companyUserTel == '') return '使用者電話番号は必須入力です';
    if (companyAddress == '') return '住所は必須入力です';
    try {
      await FirebaseAuth.instance.signInAnonymously().then((value) {
        String id = _cycleService.id();
        _cycleService.create({
          'id': id,
          'companyName': companyName,
          'companyUserName': companyUserName,
          'companyUserEmail': companyUserEmail,
          'companyUserTel': companyUserTel,
          'companyAddress': companyAddress,
          'lockNumber': '',
          'approval': 0,
          'approvedAt': DateTime.now(),
          'approvalUsers': [],
          'createdAt': DateTime.now(),
        });
        String message = '''
★★★このメールは自動返信メールです★★★

自転車置き場使用申込が完了いたしました。
以下申込内容を確認し、ご返信させていただきますので今暫くお待ちください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【店舗名】$companyName
【使用者名】$companyUserName
【使用者メールアドレス】$companyUserEmail
【使用者電話番号】$companyUserTel
【住所】$companyAddress

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
        _mailService.create({
          'id': _mailService.id(),
          'to': companyUserEmail,
          'subject': '【自動送信】自転車置き場使用申込完了のお知らせ',
          'message': message,
          'createdAt': DateTime.now(),
          'expirationAt': DateTime.now().add(const Duration(hours: 1)),
        });
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList();
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          _fmService.send(
            token: user.token,
            title: '社外申請',
            body: '自転車置き場使用の申込がありました',
          );
        }
      }
    } catch (e) {
      error = '申込に失敗しました';
    }
    return error;
  }
}
