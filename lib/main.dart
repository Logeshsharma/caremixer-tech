import 'package:caremixer/ui/timeline_list/widgets/timeline_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TimelineListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
