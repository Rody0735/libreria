class Book {
  Book({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.authors,
    this.imageLinks,
    this.description = '',
    this.pageCount = 0,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String>? authors;
  final Map<String, Uri>? imageLinks;
  final String description;
  final int pageCount;
  bool isFavorite;

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    return Book(
      id: json['id'] as String,
      title: volumeInfo['title'] as String? ?? '',
      subtitle: volumeInfo['subtitle'] as String? ?? '',
      authors: (volumeInfo['authors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageLinks: (volumeInfo['imageLinks'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Uri.parse(e as String)),
      ),
      description: volumeInfo['description'] as String? ?? '',
      pageCount: (volumeInfo['pageCount'] as num?)?.toInt() ?? 0,
      isFavorite: (json['isFavorite'] as bool? ?? false),
    );
  }

  // Metodi per la conversione specifica per il database
  factory Book.fromDbJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      authors: (json['authors'] as String).isNotEmpty
          ? (json['authors'] as String).split(',')
          : null,
      imageLinks: json['imageLinks'] != null
          ? (json['imageLinks'] as String)
              .split(',')
              .asMap()
              .map((i, e) => MapEntry(i.toString(), Uri.parse(e)))
          : null,
      description: json['description'] as String,
      pageCount: json['pageCount'] as int,
      isFavorite: (json['isFavorite'] as int) == 1,
    );
  }

  Map<String, dynamic> toDbJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'authors': authors?.join(',') ?? '',
        'imageLinks': imageLinks?.values.map((uri) => uri.toString()).join(','),
        'description': description,
        'pageCount': pageCount,
        'isFavorite': isFavorite ? 1 : 0,
      };
}
