class YogaPose {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final String imageUrl;
  final String? videoAsset;     // Optional - local video file
  final String? videoUrl;       // Optional - network video URL
  final int durationSeconds;
  final List<String> modifications;
  final String instructions;
  final String category;

  YogaPose({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.imageUrl,
    this.videoAsset,              // Optional parameter
    this.videoUrl,                // Optional parameter
    required this.durationSeconds,
    required this.modifications,
    required this.instructions,
    required this.category,
  });
}