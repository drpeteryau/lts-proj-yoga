class YogaPose {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int durationSeconds;
  final List<String> modifications;
  final String instructions;
  final String category; // warmup, main, cooldown

  YogaPose({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.durationSeconds,
    required this.modifications,
    required this.instructions,
    required this.category,
  });
}
