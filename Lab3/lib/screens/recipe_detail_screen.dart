import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/favorite_model.dart';
import '../models/meal_detail_model.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../services/meal_service.dart';
import '../services/notification_service.dart';
import '../widgets/ingredient_list.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String mealId;

  const RecipeDetailScreen({
    Key? key,
    required this.mealId,
  }) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<MealDetail?> _mealDetailFuture;
  bool _isFavorite = false;
  final _firebaseService = FirebaseService();
  //final _notificationService = NotificationService();
  final _mealService = MealService();

  @override
  void initState() {
    super.initState();
    _mealDetailFuture = ApiService.getMealDetail(widget.mealId);
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await _firebaseService.isFavorite(widget.mealId);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite(MealDetail meal) async {
    try {
      if (_isFavorite) {
        await _firebaseService.removeFavorite(meal.id);
        //await _notificationService.showFavoriteRemovedNotification(meal.name);
        setState(() => _isFavorite = false);
      } else {
        final favorite = Favorite(
          mealId: meal.id,
          mealName: meal.name,
          mealThumb: meal.thumb,
          category: meal.category,
          addedDate: DateTime.now(),
        );
        await _firebaseService.addFavorite(favorite);
        //await _notificationService.showFavoriteAddedNotification(meal.name);
        setState(() => _isFavorite = true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _launchYoutube(String url) async {
    final Uri youtubeUrl = Uri.parse(url);
    try {
      if (await canLaunchUrl(youtubeUrl)) {
        await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch YouTube')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        elevation: 0,
      ),
      body: FutureBuilder<MealDetail?>(
        future: _mealDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Meal not found'));
          }

          final meal = snapshot.data!;
          final tags = _mealService.getMealTags(meal);
          final instructions = _mealService.formatInstructions(meal.instructions);
          final hasYoutube = _mealService.hasYoutubeLink(meal);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      meal.thumb,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 250,
                          color: Colors.grey,
                          child: const Icon(Icons.broken_image, size: 80),
                        );
                      },
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () => _toggleFavorite(meal),
                        backgroundColor:
                        _isFavorite ? Colors.red : Colors.white,
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.white : Colors.red,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(meal.category),
                            backgroundColor: Colors.orange,
                          ),
                          Chip(
                            label: Text(meal.area),
                            backgroundColor: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (hasYoutube)
                        ElevatedButton.icon(
                          onPressed: () => _launchYoutube(meal.youtube!),
                          icon: const Icon(Icons.play_circle),
                          label: const Text('Watch on YouTube'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (tags.isNotEmpty) ...[
                        const Text(
                          'Tags',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: tags
                              .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.purple,
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      IngredientList(
                        ingredients: meal.ingredients,
                        measures: meal.measures,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: instructions
                            .map((instruction) => Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            instruction,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.8,
                              color: Colors.grey,
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
