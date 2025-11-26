import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final List<String> ingredients;
  final List<String> measures;

  const IngredientList({
    super.key,
    required this.ingredients,
    required this.measures,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final ing = ingredients[index];
        final meas = index < measures.length ? measures[index] : '';
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('• $meas $ing'),
        );
      },
    );
  }
}
