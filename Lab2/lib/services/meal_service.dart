import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';
import 'api_service.dart';

class MealService {
  Future<List<Meal>> getMealsForCategory(String category) {
    return ApiService.getMealsByCategory(category);
  }

  Future<List<Meal>> searchMealsByName(String query) {
    return ApiService.searchMeals(query);
  }

  Future<MealDetail> getMealDetail(String id) {
    return ApiService.getMealDetail(id);
  }

  Future<MealDetail> getRandomMeal() {
    return ApiService.getRandomMeal();
  }
}
