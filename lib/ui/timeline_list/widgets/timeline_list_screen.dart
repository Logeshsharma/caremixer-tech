import 'package:caremixer/data/models/timeline_event.dart';
import 'package:caremixer/ui/core/constants/app_colors.dart';
import 'package:caremixer/ui/core/ui/header.dart';
import 'package:flutter/material.dart';

class TimelineListScreen extends StatelessWidget {
  const TimelineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'Timeline'),
            Expanded(
              child: _TimelineContent(),
            ),
          ],
        ),
      ),
    );
  }
}


// Content
class _TimelineContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 24),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: timelineData.length,
      itemBuilder: (context, index) {
        return _TimelineEventCard(
          event: timelineData[index],
          isFirst: index == 0,
          isLast: index == timelineData.length - 1,
        );
      },
    );
  }
}

class _TimelineEventCard extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  const _TimelineEventCard({
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isAudit = event.type == 'audit';
    final eventColor =
        isAudit ? AppColors.timelineAudit : AppColors.timelineNote;
    final bgColor = isAudit ? AppColors.timelineAuditBg : AppColors.timelineNoteBg;
    final lightColor =
        isAudit ? AppColors.timelineAuditLight : AppColors.timelineNoteLight;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineLine(
            isFirst: isFirst,
            isLast: isLast,
          ),
          Expanded(
            child: _EventCard(
              event: event,
              eventColor: eventColor,
              bgColor: bgColor,
              lightColor: lightColor,
              isAudit: isAudit,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineLine extends StatelessWidget {
  final bool isFirst;
  final bool isLast;

  const _TimelineLine({
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      child: Column(
        children: [
          if (!isFirst)
            Container(
              height: 16,
              width: 2,
              color: Colors.grey,
            ),
          if (isFirst)
            const SizedBox(height: 16),
          if (!isFirst && !isLast)
            const SizedBox(height: 0),
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final TimelineEvent event;
  final Color eventColor;
  final Color bgColor;
  final Color lightColor;
  final bool isAudit;

  const _EventCard({
    required this.event,
    required this.eventColor,
    required this.bgColor,
    required this.lightColor,
    required this.isAudit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 40),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isAudit
                              ? Icons.shield_outlined
                              : Icons.event_note_outlined,
                          color: eventColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              size: 12,
                              color: eventColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event.time,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: eventColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.divider),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    event.message,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: -16,
            top: 12,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
             
              ),
              child: Icon(
                isAudit ? Icons.shield_outlined : Icons.event_note_outlined,
                color: eventColor,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
