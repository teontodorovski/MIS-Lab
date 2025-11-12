import 'package:flutter/material.dart';
import 'package:mis_lab1/models/exam.dart';

import '../models/exam.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;

  const ExamCard({super.key, required this.exam});
  String _formatDate(DateTime dt) {
    final months = ['јан', 'феб', 'мар', 'апр', 'мај', 'јун', 'јул', 'авг', 'сеп', 'окт', 'ноем', 'дек'];
    return '${dt.day}. ${months[dt.month - 1]} ${dt.year}';
  }
  String _formatTime(DateTime dt) => '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/details", arguments: exam);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: exam.isPassed ? Colors.grey: Colors.cyan.shade900, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(exam.subjectName, style: TextStyle(fontSize: 20)),
              Divider(),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16.0, color: exam.isPassed ? Colors.grey: Colors.cyan[900]),
                  SizedBox(width: 8.0),
                  Text(_formatDate(exam.dateTime), style: TextStyle(fontSize: 14.0, color: Colors.grey[700])),
                  SizedBox(width: 8.0),
                  Icon(Icons.access_time, size: 16.0, color: exam.isPassed ? Colors.grey: Colors.cyan[900]),
                  SizedBox(width: 8.0),
                  Text(_formatTime(exam.dateTime), style: TextStyle(fontSize: 14.0, color: Colors.grey[700])),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, size: 16.0, color: exam.isPassed ? Colors.grey:
                  Colors.cyan[900]),
                  const SizedBox(width: 8.0),
                  Expanded(child: Text(exam.examLabs.join(', '), style: TextStyle(fontSize: 14.0, color: Colors.grey[700]))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
