class GaugeTheme {
  final int id;
  final int userId;
  final String name;
  final String authorName;
  final int downloadsCount;
  final int likesCount;
  final bool isLiked;
  final String imageBase64;
  final Map<String, dynamic> conf; // Pełna konfiguracja
  final List<dynamic> images;      // Tablica z linkami

  GaugeTheme({
    required this.id,
    required this.userId,
    required this.name,
    required this.authorName,
    required this.downloadsCount,
    required this.likesCount,
    required this.isLiked,
    required this.imageBase64,
    required this.conf,
    required this.images,
  });

  factory GaugeTheme.fromJson(Map<String, dynamic> json) {
    return GaugeTheme(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? 'Bez nazwy',
      authorName: json['author'] ?? 'Nieznany',
      downloadsCount: json['downloads'] ?? 0,
      likesCount: json['likes'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      imageBase64: json['image'] ?? '',
      conf: json['conf'] ?? {},
      images: json['images'] ?? [],
    );
  }

  // Użyj tej metody przy kopiowaniu (np. do zmiany statusu polubienia)
  GaugeTheme copyWith({bool? isLiked, int? likesCount}) {
    return GaugeTheme(
      id: id,
      userId: userId,
      name: name,
      authorName: authorName,
      downloadsCount: downloadsCount,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      imageBase64: imageBase64,
      conf: conf,
      images: images,
    );
  }
}