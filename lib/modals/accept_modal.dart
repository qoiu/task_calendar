import 'package:flutter/cupertino.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/navigation.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/statefull_modal.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';

import 'bottom_sheet_template.dart';

class AcceptModal extends StatelessModal {
  final String title;
  final String? description;
  final String? successBtn;
  final Color? color;

  const AcceptModal(
      {required this.title,
      this.color,
      this.successBtn,
      this.description,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetTemplate(
        title: title,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null) ...{
              TextBuilder(description!)
                  .bodyMedium()
                  .fontWeight(FontWeight.w500)
                  .build(),
              const SizedBox(
                height: 30,
              ),
            },
            Row(
              children: [
                Expanded(
                  child: MainButton(
                    successBtn ?? 'Принять',
                    () => Navigator.of(rootNavigatorKey.currentContext!)
                        .pop(true),
                    color: color ?? getColorScheme().outline,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MainButton(
                    'Отклонить',
                    () => Navigator.of(rootNavigatorKey.currentContext!)
                        .pop(false),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  @override
  String get tag => 'accept';
}
