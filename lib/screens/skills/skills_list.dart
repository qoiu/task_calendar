import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:task_calendar/database/skill_queries.dart';
import 'package:task_calendar/modals/create_skill/create_skill_modal.dart';
import 'package:task_calendar/modals/skill_progress_modal.dart';
import 'package:task_calendar/models/skill.dart';
import 'package:task_calendar/screens/skills/components/skill_item.dart';
import 'package:task_calendar/utils/utils.dart';

class SkillsList extends StatefulWidget {
  const SkillsList({super.key});

  @override
  State<SkillsList> createState() => _SkillsListState();
}

class _SkillsListState extends State<SkillsList> {
  List<SkillData> skills = [];

  @override
  void initState() {
    super.initState();
    loadSkills();
  }

  loadSkills()async{
    skills = await skillQueries.getSkills();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            ListView(
                  padding: EdgeInsets.all(20),
                  children: skills
              .indexedMap((index, skill) => [
                if(index==0 || skill.daysLeft!=skills[index-1].daysLeft)...{
                  TextBuilder('Осталось ${skill.daysLeft} дней').titleMedium().build(),
                  const SizedBox(height: 3),
                },
                    GestureDetector(
                      onTap: ()async{
                        var result = await SkillProgressModal(skill: skill).showCenter();
                        if (result == true) {
                          loadSkills();
                        }
                      },
                      onDoubleTap: ()async{
                        var result = await CreateSkillModal(skill: skill).show();
                        if (result == true) {
                          loadSkills();
                        }
                      },
                        child: SkillItem(skill)),
                    const SizedBox(height: 6),
                  ])
              .expand((e) => e)
              .toList(),
                ),
            Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(30),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () async{
                      var result = await const CreateSkillModal().show();
                      if (result == true) {
                        loadSkills();
                      }
                    },
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ));
  }
}
