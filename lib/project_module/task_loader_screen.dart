import 'package:flutter/material.dart';

class TaskLoaderScreen extends StatefulWidget {
  const TaskLoaderScreen({super.key});

  @override
  State<TaskLoaderScreen> createState() => _TaskLoaderScreenState();
}

class _TaskLoaderScreenState extends State<TaskLoaderScreen> {

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  init()async{
    await Future.delayed(const Duration(milliseconds: 3000));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator()):const Placeholder();
  }
}
