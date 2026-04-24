import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:qoiu_utils/statefull_modal.dart';
import 'package:task_calendar/database/skill_queries.dart';
import 'package:task_calendar/models/skill.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';
import 'package:task_calendar/utils/utils.dart';

import 'center_modal_template.dart';

class SkillProgressModal extends StatefulModal {
  final SkillData skill;

  const SkillProgressModal({required this.skill, super.key});

  @override
  State<SkillProgressModal> createState() => _CreateTaskModalState();

  @override
  String get tag => 'createTaskModal';
}

class _CreateTaskModalState extends State<SkillProgressModal> {
  SkillData get skill => widget.skill;

  int progress = 0;

  @override
  void initState() {
    progress = skill.averageCounter.avg.floor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const height = 40.0;
    return CenterModalTemplate(
        tag: widget.tag,
        padding: const EdgeInsets.all(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            TextBuilder(skill.title).titleMedium().build(),
            const SizedBox(height: 10),
            TextBuilder(
                'Прогресс: ${skill.progress + progress} / ${skill.nextLvlTarget}')
                .build(),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: height,
              child: LayoutBuilder(
                  builder: (context, constraint) {
                    double text1Offset = max(
                            (skill.progress / skill.target) *
                                constraint.maxWidth - 10 * skill.progress
                                .toString()
                                .length - 2, 0);
                    return GestureDetector(
                      onHorizontalDragUpdate: (delta){
                        progress+=(delta.delta.dx/2).toInt();
                        ['progress',progress].print();
                        ['skill progress',skill.progress].print();
                        progress = max(-skill.progress, min(progress, skill.nextLvlTarget-skill.progress));
                        setState(() {});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(height),
                        child: Stack(
                          children: [
                            Container(width: double.maxFinite,
                              height: height,
                              decoration: BoxDecoration(
                                  color: skill.color.oppositeExtraColor(-0.2),
                                  borderRadius: BorderRadius.circular(height)
                              ),),
                            Container(width: (skill.currentLvlTarget /
                                skill.nextLvlTarget) * constraint.maxWidth,
                                height: height,
                                decoration: BoxDecoration(
                                    color: skill.color.oppositeExtraColor(0.1),
                                    borderRadius: BorderRadius.circular(height)
                                )),
                            Container(width: ((skill.progress+progress) / skill.target) *
                                constraint.maxWidth,
                              height: height,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(height)
                              ),),
                            Container(width: (skill.progress / skill.target) *
                                constraint.maxWidth,
                              height: height,
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(height)
                              ),),
                            if(progress<0)...{
                              Container(width: ((skill.progress + progress) / skill.target) *
                                  constraint.maxWidth,
                                height: height,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(height)
                                ),),
                            },
                            if(progress>=0)...{
                              if(progress>0)...{
                                Transform.translate(offset: Offset(max(
                                    ((skill.progress + progress) /
                                        skill.target) *
                                        constraint.maxWidth - 7 * progress
                                        .toString()
                                        .length - 2,
                                    text1Offset + 10 + 7 * progress
                                        .toString()
                                        .length), height / 2 - 10),
                                  child: Text(progress.toString(),
                                    style: getTextStyle().bodySmall?.copyWith(
                                        fontSize: 14, color: Colors.white),),)
                              },
                              Transform.translate(offset: Offset(text1Offset, height/2-10),
                                child: Text(skill.progress.toString(),
                                  style: getTextStyle().bodySmall?.copyWith(
                                      fontSize: 14),),),
                            }else...{
                              Transform.translate(offset: Offset(max(
                                  ((skill.progress + progress) / skill.target) *
                                      constraint.maxWidth - 5 * progress
                                      .toString()
                                      .length - 2, 0), height/2-10),
                                child: Text(progress.toString(),
                                  style: getTextStyle().bodySmall?.copyWith(
                                      fontSize: 14, color: Colors.white),),),
                            }
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
            const SizedBox(height: 10),
            // Slider(
            //     value: progress * 1.0,
            //     min: 0,
            //     max: skill.nextLvlTarget - skill.progress*1.0,
            //     onChanged: (a) {
            //       progress = a.toInt();
            //       setState(() {});
            //     }),
            const SizedBox(height: 10),
            MainButton('Сохранить', () async {
              skill.progress += progress;
              await skillQueries.update(skill);
              Navigator.of(context).pop(true);
            })
          ],
        ));
  }
}