import 'package:flutter/material.dart';
import 'package:miel_work_request_cycle_web/common/functions.dart';
import 'package:miel_work_request_cycle_web/common/style.dart';
import 'package:miel_work_request_cycle_web/providers/request_cycle.dart';
import 'package:miel_work_request_cycle_web/screens/step3.dart';
import 'package:miel_work_request_cycle_web/widgets/custom_button.dart';
import 'package:miel_work_request_cycle_web/widgets/dotted_divider.dart';
import 'package:miel_work_request_cycle_web/widgets/form_label.dart';
import 'package:miel_work_request_cycle_web/widgets/form_value.dart';
import 'package:miel_work_request_cycle_web/widgets/link_text.dart';
import 'package:miel_work_request_cycle_web/widgets/responsive_box.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Step2Screen extends StatefulWidget {
  final String companyName;
  final String companyUserName;
  final String companyUserEmail;
  final String companyUserTel;
  final String companyAddress;

  const Step2Screen({
    required this.companyName,
    required this.companyUserName,
    required this.companyUserEmail,
    required this.companyUserTel,
    required this.companyAddress,
    super.key,
  });

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<RequestCycleProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                '自転車置き場使用申込フォーム',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 24),
              ResponsiveBox(
                children: [
                  const Text('以下の申込内容で問題ないかご確認ください。'),
                  const SizedBox(height: 16),
                  const DottedDivider(),
                  const SizedBox(height: 16),
                  const Text(
                    '申込者情報',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '店舗名',
                    child: FormValue(widget.companyName),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '使用者名',
                    child: FormValue(widget.companyUserName),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '使用者メールアドレス',
                    child: FormValue(widget.companyUserEmail),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '使用者電話番号',
                    child: FormValue(widget.companyUserTel),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '住所',
                    child: FormValue(widget.companyAddress),
                  ),
                  const SizedBox(height: 16),
                  const DottedDivider(),
                  const SizedBox(height: 32),
                  CustomButton(
                    type: ButtonSizeType.lg,
                    label: '上記内容で申し込む',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await cycleProvider.create(
                        companyName: widget.companyName,
                        companyUserName: widget.companyUserName,
                        companyUserEmail: widget.companyUserEmail,
                        companyUserTel: widget.companyUserTel,
                        companyAddress: widget.companyAddress,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const Step3Screen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: LinkText(
                      label: '入力に戻る',
                      color: kBlueColor,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
