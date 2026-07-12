import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:qoiu_utils/statefull_modal.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:task_calendar/components/text_form_field.dart';
import 'package:task_calendar/modals/create_task/components/subtask_editor.dart';
import 'package:task_calendar/models/skill.dart';
import 'package:task_calendar/models/task_property.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';

import '../../database/main_database.dart';
import '../bottom_sheet_template.dart';

class CreateSkillModal extends StatefulModal {
  final SkillData? skill;

  const CreateSkillModal({this.skill, super.key});

  @override
  State<CreateSkillModal> createState() => _CreateTaskModalState();

  @override
  String get tag => 'createTaskModal';
}

class _CreateTaskModalState extends State<CreateSkillModal> {
  final PageController pageController = PageController();

  TextEditingController titleController = TextEditingController();
  TextEditingController lvlController = TextEditingController();
  TextEditingController lvlPercentController = TextEditingController();
  TextEditingController targetProgressController = TextEditingController();
  TextEditingController startDayController = TextEditingController();
  TextEditingController durationInDaysController = TextEditingController();
  late SkillData skill;

  @override
  void initState() {
    skill = widget.skill ??
        SkillData(title: '', lvl: 1, lvlPercent: 0, target: 100, averageCounter: AverageCounter(0, 0));
    titleController.text =  skill.title;
    lvlController.text = skill.lvl.toString();
    lvlPercentController.text = skill.lvlPercent.toString();
    targetProgressController.text = skill.target.toString();
    startDayController.text = skill.startDay?.toString()??'';
    durationInDaysController.text = skill.durationInDays.toString();

    super.initState();
  }

  List<_CreationItem> widgets = [
    _CreationItem(
        'subtask', 'Список', (e) => SubtaskEditor(e as SubtaskListTaskProperty))
  ];

  @override
  Widget build(BuildContext context) {
    return BottomSheetTemplate(
        tag: widget.tag,
        padding: const EdgeInsets.only(bottom: 20),
        Column(
          children: [
            SmoothPageIndicator(
              controller: pageController,
              count: 2 + skill.properties.length,
              effect: const ExpandingDotsEffect(),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: PageView(
                controller: pageController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        CommonFormField(
                        hint: 'Название',
                          controller: titleController,
                          onChanged: (e) {
                            skill.title = e;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(child: CommonFormField(
                              hint: 'Текущий уровень',
                              controller: lvlController,
                              keyboardType: const TextInputType.numberWithOptions(),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (e) {
                                skill.lvl = int.tryParse(e)??0;
                                lvlController.text = skill.lvl.toString();
                              },
                            ),),
                            Expanded(child: CommonFormField(
                              hint: 'До след. уровня',
                              controller: targetProgressController,
                              keyboardType: const TextInputType.numberWithOptions(),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (e) {
                                skill.target = int.tryParse(e)??0;
                                targetProgressController.text = skill.target.toString();
                              },
                            ),),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(child: CommonFormField(
                              hint: 'Прогрессия',
                              controller: lvlPercentController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                              inputFormatters: [],
                              onChanged: (e) {
                                skill.lvlPercent = double.tryParse(e)??0;
                                lvlPercentController.text = skill.lvlPercent.toString();
                              },
                            ),),
                            Expanded(child: CommonFormField(
                              hint: 'До след. уровня',
                              controller: targetProgressController,
                              keyboardType: const TextInputType.numberWithOptions(),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (e) {
                                skill.lvl = int.tryParse(e)??0;
                                targetProgressController.text = skill.lvl.toString();
                              },
                            ),),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(child: CommonFormField(
                              hint: 'Дней на выполнение',
                              controller: durationInDaysController,
                              keyboardType: const TextInputType.numberWithOptions(),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (e) {
                                skill.durationInDays = int.tryParse(e)??0;
                                durationInDaysController.text = skill.durationInDays.toString();
                              },
                            ),),
                            Expanded(child: CommonFormField(
                              hint: 'Стартовый день',
                              controller: startDayController,
                              keyboardType: const TextInputType.numberWithOptions(),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (e) {
                                skill.startDay = int.tryParse(e);
                                startDayController.text = skill.startDay.toString();
                              },
                            ),),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MainButton(widget.skill==null?'Создать':'Сохранить', () async {
                          if(widget.skill==null) {
                            await DB.skills.add(skill);
                          }else{
                            await DB.skills.update(skill);
                          }
                          Navigator.of(context).pop(true);
                        })
                      ],
                    ),
                  ),
                  // ...skill.properties.map((e) {
                  //   return Container(
                  //       padding: const EdgeInsets.symmetric(horizontal: 20),
                  //       child: widgets
                  //           .where((w) => e.type == w.type)
                  //           .firstOrNull
                  //           ?.let((w) => w.builder(e)));
                  // }),
                  // Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 20),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Wrap(
                  //             children: widgets
                  //                 .map((e) => CloudButton(e.title, onTap: () {
                  //                       skill.addProperty(e.type);
                  //                       [
                  //                         'properties',
                  //                         skill.properties
                  //                             .map((e) => e.type)
                  //                             .toString()
                  //                       ].print();
                  //                       setState(() {});
                  //                     }))
                  //                 .toList())
                  //       ],
                  //     ))
                ],
              ),
            ),
          ],
        ));
  }
}

class _CreationItem {
  final String title;
  final String type;
  final Widget Function(TaskProperty) builder;

  _CreationItem(this.type, this.title, this.builder);
}
