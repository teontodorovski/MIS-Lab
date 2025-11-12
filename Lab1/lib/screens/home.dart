import 'package:flutter/material.dart';
import 'package:mis_lab1/models/exam.dart';

import '../models/exam.dart';
import '../widgets/exam_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Exam> getSortedExams() {
    final exams = getExam();
    exams.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return exams;
  }
  List<Exam> getExam() =>  [
    Exam(subjectName: 'Интернет Технологии', dateTime: DateTime(2025,10,19,15), examLabs: ['138', '107']),
    Exam(subjectName: 'Интернет Програмирање', dateTime: DateTime(2025,11,16,10), examLabs: ['13', '2', '3']),
    Exam(subjectName: 'Структурно Програмирање', dateTime: DateTime(2025,10,14,8), examLabs: ['138', '107', '13', '2']),
    Exam(subjectName: 'Бази на податоци', dateTime: DateTime(2025,11,13,10), examLabs: ['138']),
    Exam(subjectName: 'Калкулус', dateTime: DateTime(2025,10,12,12), examLabs: ['Б3.2', 'Б2.2', "АМФ МФ"]),
    Exam(subjectName: 'Маркетинг', dateTime: DateTime(2025,11,18,18), examLabs: ['200аб']),
    Exam(subjectName: 'Веб Програмирање', dateTime: DateTime(2025,11,21,17), examLabs: ['13', '107']),
    Exam(subjectName: 'Компјутерски мрежи', dateTime: DateTime(2025,11,22,14), examLabs: ['138', '200в']),
    Exam(subjectName: 'Криптографија', dateTime: DateTime(2025,11,20,9), examLabs: ['107']),
    Exam(subjectName: 'Веројатност и статистика', dateTime: DateTime(2025,10,17,13), examLabs: ['138', '200аб'])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ExamGrid(exam: getSortedExams()),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.cyan.shade900,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Вкупно испити: ',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${getExam().length}',
                      style: TextStyle(color: Colors.cyan[900], fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}