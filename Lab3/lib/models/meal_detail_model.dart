class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String thumb;
  final String instructions;
  final String? youtube;
  final List<String> ingredients;
  final List<String> measures;
  final String? tags;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.thumb,
    required this.instructions,
    required this.ingredients,
    required this.measures,
    this.youtube,
    this.tags,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final meas = json['strMeasure$i'];
      if (ing != null && ing.toString().trim().isNotEmpty) {
        ingredients.add(ing.toString());
        measures.add(meas?.toString() ?? '');
      }
    }

    return MealDetail(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      thumb: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      youtube: json['strYoutube'],
      tags: json['strTags'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}
