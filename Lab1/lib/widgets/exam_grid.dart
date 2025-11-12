import 'package:flutter/material.dart';
import 'package:mis_lab1/widgets/exam_card.dart';
import '../models/exam.dart';

class ExamGrid extends StatefulWidget {
  final List<Exam> exam;

  const ExamGrid({super.key, required this.exam});

  @override
  State<StatefulWidget> createState() => _ExamGridState();
}

class _ExamGridState extends State<ExamGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 300/101
      ),
      itemCount: widget.exam.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ExamCard(exam: widget.exam[index]);
      },
    );
  }
}
