import 'package:flutter/material.dart';

import '../models/exam.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exam = ModalRoute.of(context)!.settings.arguments as Exam;
    String formatDateTime(DateTime dt) {
      final months = ['јан', 'феб', 'мар', 'апр', 'мај', 'јун', 'јул', 'авг', 'сеп', 'окт', 'ноем', 'дек'];
      return '${dt.day}. ${months[dt.month - 1]} ${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: Colors.cyan.shade50,
      appBar: AppBar(
        title: Text(exam.subjectName.toUpperCase()),
        centerTitle: true,
        backgroundColor: exam.isPassed ? Colors.grey : Colors.cyan.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: exam.isPassed ? Colors.grey : Colors.cyan.shade900),
                const SizedBox(width: 10.0),
                Text(formatDateTime(exam.dateTime), style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.location_on, color: exam.isPassed ? Colors.grey : Colors.cyan.shade900),
                const SizedBox(width: 10.0),
                Expanded(child: Text(exam.examLabs.join(', '), style: const TextStyle(fontSize: 18))),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: exam.isPassed ? Colors.red[100] : Colors.green[100],
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: exam.isPassed ? Colors.red[400]! : Colors.green[400]!, width: 2.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Преостанато време', style: TextStyle(fontSize: 14.0)),
                  const SizedBox(height: 8.0),
                  Text(exam.getDaysAndHoursUntil(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: exam.isPassed ? Colors.red[700] : Colors.green[700])),
                ],
              ),
            ),
            Center(
              child: Chip(
                label: Text(exam.isPassed ? 'Завршен испит' : 'Иден испит', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.white)),
                backgroundColor: exam.isPassed ? Colors.grey : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
