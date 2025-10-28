import 'package:caremixer/data/models/timeline_event.dart';
import 'package:caremixer/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

// Build a *timeline view* that displays a list of items (e.g., notes or audit messages).

// *Requirements:*

// - Each entry shows a *title, **timestamp, and **message*. - DONE
// - Items are displayed in a vertical *timeline style* (with a connector line and dots/nodes). Line - DONE
// - Support at least 10 sample entries (hardcoded JSON or mock data is fine). - DONE

// *Bonus points:*

// - Different icons or colors depending on message type (note vs audit). - DONE
// - Smooth scroll or subtle transitions. - DONE

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
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      // Items are displayed in a vertical *timeline style
      child: ListView.builder(
        // Smooth scroll
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        // Support at least 10 sample entries
        itemCount: timelineData.length,
        itemBuilder: (context, index) {
          return _timelineEventWidget(
            event: timelineData[index],
            context: context,
          );
        },
      ),
    );
  }

  Widget _timelineEventWidget({
    required TimelineEvent event,
    required BuildContext context,
  }) {
    bool isLast = timelineData.last == event;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator - with a connector line and nodes
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Different icons or colors depending on message type
                color: event.type == 'audit'
                    ? AppColors.peachLight
                    : AppColors.greenLight,
              ),
            ),
            if (!isLast)
              Container(
                width: 1,
                height: 60,
                color: Colors.grey,
              ),
          ],
        ),
        const SizedBox(width: 10),

        // Content - Each entry shows a *title, **timestamp, and **message*
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title, style: Theme.of(context).textTheme.titleMedium),
              _textRow(label: 'Message: ', value: event.message),
              _textRow(label: 'Time: ', value: event.time),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textRow({
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(label),
        Text(value),
      ],
    );
  }
}