class Favorite {
  final String mealId;
  final String mealName;
  final String mealThumb;
  final String category;
  final DateTime addedDate;

  Favorite({
    required this.mealId,
    required this.mealName,
    required this.mealThumb,
    required this.category,
    required this.addedDate,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      mealId: json['mealId'] ?? '',
      mealName: json['mealName'] ?? '',
      mealThumb: json['mealThumb'] ?? '',
      category: json['category'] ?? '',
      addedDate: DateTime.parse(json['addedDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealId': mealId,
      'mealName': mealName,
      'mealThumb': mealThumb,
      'category': category,
      'addedDate': addedDate.toIso8601String(),
    };
  }
}
