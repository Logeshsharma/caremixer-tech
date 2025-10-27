import 'package:caremixer/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class TimelineListScreen extends StatelessWidget {
  const TimelineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.greenBright,
        title: Text(
          'TimeLine List',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: const Icon(
          Icons.menu_rounded,
          color: AppColors.white,
        ),
      ),
    );
  }
}
