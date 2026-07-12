import 'package:flutter/cupertino.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';
import 'package:task_calendar/screens/menu/components/menu_button.dart';
import 'package:task_calendar/utils/utils.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        height: MediaQuery.heightOf(context)-MediaQuery.of(context).viewPadding.top-10,
        padding: const EdgeInsets.all(10).copyWith(top: MediaQuery.of(context).viewPadding.top+10),
        child: Column(
          children: [
            MainButton(getString().menu_settings_category,  (){}),
            const SizedBox(height: 10),
            MainButton(getString().menu_settings_task, (){}),
            const SizedBox(height: 10),
            MainButton(getString().menu_settings_currency, (){}),
          ],
        ),
      ),
    );
  }
}
