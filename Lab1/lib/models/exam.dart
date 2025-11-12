class Exam {
  String subjectName;
  DateTime dateTime;
  List<String> examLabs;

  Exam({required this.subjectName, required this.dateTime, required this.examLabs});

  bool get isPassed => DateTime.now().isAfter(dateTime);

  String getDaysAndHoursUntil() {
    if (isPassed) return 'Испитот е завршен';
    final diff = dateTime.difference(DateTime.now());
    final days = diff.inDays;
    final hours = diff.inHours.remainder(24);
    return '$days дена, $hours часа';
  }
}