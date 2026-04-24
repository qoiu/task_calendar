import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/models/skill.dart';
import 'package:task_calendar/utils/utils.dart';

class SkillItem extends StatefulWidget {
  final SkillData skill;
  const SkillItem(this.skill, {super.key});

  @override
  State<SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<SkillItem> {

  SkillData get skill => widget.skill;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: skill.color,
        borderRadius: BorderRadius.circular(20)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextBuilder('${skill.title} ${skill.progress}/${skill.currentLvlTarget}(${skill.nextLvlTarget})').color(skill.textColor).labelMedium().build(),
          TextBuilder('Уровень: ${skill.lvl}').color(skill.textColor).build(),
          LayoutBuilder(
            builder: (context,constraint) {
              return Stack(
                children: [
                  Container(width: double.maxFinite, height: 10, decoration: BoxDecoration(
                      color: skill.color.oppositeExtraColor(-0.2),
                      borderRadius: BorderRadius.circular(10)
                  ),),
                  Container(width: (skill.currentLvlTarget/skill.nextLvlTarget)*constraint.maxWidth, height: 10, decoration: BoxDecoration(
                      color: skill.color.oppositeExtraColor(0.1),
                    borderRadius: BorderRadius.circular(10)
                  )),
                  Container(width: (skill.progress/skill.target)*constraint.maxWidth, height: 10, decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10)
                  ),),
                  if(skill.progress>0)...{
                    Transform.translate(offset: Offset(max((skill.progress /
                        skill.target) * constraint.maxWidth - 5 * skill.progress
                        .toString()
                        .length - 2, 0), 1),
                      child: Text(skill.progress.toString(),
                        style: getTextStyle().bodySmall?.copyWith(
                            fontSize: 8),),)
                  }
                ],
              );
            }
          )
        ],
      ),
    );
  }
}
