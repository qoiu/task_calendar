import 'package:flutter/cupertino.dart';
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          MenuButton(title: getString().menu_settings_category, onTap: (){}),
          const SizedBox(height: 10),
          MenuButton(title: getString().menu_settings_task, onTap: (){}),
          const SizedBox(height: 10),
          MenuButton(title: getString().menu_settings_currency, onTap: (){}),
        ],
      ),
    );
  }
}
