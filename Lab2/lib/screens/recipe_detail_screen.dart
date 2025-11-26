import 'package:flutter/material.dart';
import '../models/meal_detail_model.dart';
import '../services/meal_service.dart';
import '../widgets/ingredient_list.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String mealId;
  final MealDetail? initialMeal;

  const RecipeDetailScreen({
    super.key,
    required this.mealId,
    this.initialMeal,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final _service = MealService();
  MealDetail? _meal;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialMeal != null) {
      _meal = widget.initialMeal;
      _loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final meal = await _service.getMealDetail(widget.mealId);
      setState(() {
        _meal = meal;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _openYoutube() async {
    if (_meal?.youtube == null || _meal!.youtube!.isEmpty) return;
    final uri = Uri.parse(_meal!.youtube!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_meal?.name ?? 'Recipe'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : _meal == null
          ? const Center(child: Text('No data'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(_meal!.thumb),
            ),
            const SizedBox(height: 12),
            Text(
              _meal!.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(_meal!.category),
                ),
                Chip(
                  label: Text(_meal!.area),
                ),
              ],
            ),
            if (_meal!.tags != null &&
                _meal!.tags!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('Tags: ${_meal!.tags!}'),
              ),
            const SizedBox(height: 16),
            Text(
              'Ingredients',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            IngredientList(
              ingredients: _meal!.ingredients,
              measures: _meal!.measures,
            ),
            const SizedBox(height: 16),
            Text(
              'Instructions',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_meal!.instructions),
            const SizedBox(height: 16),
            if (_meal!.youtube != null &&
                _meal!.youtube!.isNotEmpty)
              ElevatedButton.icon(
                onPressed: _openYoutube,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Watch on YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}
