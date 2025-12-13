import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';

class ApiService {
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Category>> getCategories() async {
    final res = await http.get(Uri.parse('$_base/categories.php'));
    if (res.statusCode != 200) {
      throw Exception('Error loading categories');
    }
    final json = jsonDecode(res.body);
    final list = json['categories'] as List<dynamic>? ?? [];
    return list.map((e) => Category.fromJson(e)).toList();
  }

  static Future<List<Meal>> getMealsByCategory(String category) async {
    final res =
    await http.get(Uri.parse('$_base/filter.php?c=$category'));
    if (res.statusCode != 200) {
      throw Exception('Error loading meals');
    }
    final json = jsonDecode(res.body);
    final list = json['meals'] as List<dynamic>? ?? [];
    return list.map((e) => Meal.fromJson(e)).toList();
  }

  static Future<List<Meal>> searchMeals(String query) async {
    final res =
    await http.get(Uri.parse('$_base/search.php?s=$query'));
    if (res.statusCode != 200) {
      throw Exception('Error searching meals');
    }
    final json = jsonDecode(res.body);
    final list = json['meals'] as List<dynamic>? ?? [];
    return list.map((e) => Meal.fromJson(e)).toList();
  }

  static Future<MealDetail> getMealDetail(String id) async {
    final res =
    await http.get(Uri.parse('$_base/lookup.php?i=$id'));
    if (res.statusCode != 200) {
      throw Exception('Error loading details');
    }
    final json = jsonDecode(res.body);
    final list = json['meals'] as List<dynamic>? ?? [];
    if (list.isEmpty) throw Exception('Meal not found');
    return MealDetail.fromJson(list.first);
  }

  static Future<MealDetail> getRandomMeal() async {
    final res =
    await http.get(Uri.parse('$_base/random.php'));
    if (res.statusCode != 200) {
      throw Exception('Error loading random meal');
    }
    final json = jsonDecode(res.body);
    final list = json['meals'] as List<dynamic>? ?? [];
    if (list.isEmpty) throw Exception('Meal not found');
    return MealDetail.fromJson(list.first);
  }
  static bool hasYoutubeLink(MealDetail mealDetail) {
    return mealDetail.youtube != null && mealDetail.youtube!.isNotEmpty;
  }

  static List<String> formatInstructions(String instructions) {
    if (instructions.isEmpty) {
      return ['No instructions available'];
    }

    List<String> steps = instructions.split('\n');
    return steps
        .where((step) => step.trim().isNotEmpty)
        .toList()
        .asMap()
        .entries
        .map((entry) => '${entry.key + 1}. ${entry.value.trim()}')
        .toList();
  }


  static List<String> getMealTags(MealDetail mealDetail) {
    if (mealDetail.tags == null || mealDetail.tags!.isEmpty) {
      return [];
    }
    return mealDetail.tags!.split(',').map((tag) => tag.trim()).toList();
  }
}
