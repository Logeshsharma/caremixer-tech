class TimelineEvent {
  final String time;
  final String type;
  final String title;
  final String message;

  TimelineEvent({
    required this.time,
    required this.type,
    required this.title,
    required this.message,
  });
}

// Sample data
final List<TimelineEvent> timelineData = [
  TimelineEvent(
      time: "09:00 AM",
      type: "audit",
      title: "User logged in",
      message: "User logged in successfully!"),
  TimelineEvent(
      time: "09:15 AM",
      type: "note",
      title: "Added a note",
      message: "Call client"),
  TimelineEvent(
      time: "09:30 AM",
      type: "audit",
      title: "File upload",
      message: "File 'report.pdf' uploaded"),
  TimelineEvent(
      time: "10:00 AM",
      type: "audit",
      title: "Password changed",
      message: "Password changed successfully!"),
  TimelineEvent(
      time: "10:15 AM",
      type: "note",
      title: "Meeting notes",
      message: "Discuss project X"),
  TimelineEvent(
      time: "10:30 AM",
      type: "audit",
      title: "User logged out",
      message: "User logged out successfully"),
  TimelineEvent(
      time: "11:00 AM",
      type: "note",
      title: "Reminder",
      message: "Submit invoice"),
  TimelineEvent(
      time: "11:30 AM",
      type: "audit",
      title: "Settings updated",
      message: "Profile settings updated successfully"),
  TimelineEvent(
      time: "12:00 PM",
      type: "note",
      title: "Lunch break",
      message: "Time for lunch!"),
  TimelineEvent(
      time: "12:30 PM",
      type: "audit",
      title: "New user registered",
      message: "A new user account has been created"),
];
