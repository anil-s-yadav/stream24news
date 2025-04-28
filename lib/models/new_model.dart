class Source {
  final String? sourceIcon;
  final String? sourceId;
  final String? sourceName;
  final String? sourceUrl;

  Source({
    this.sourceIcon,
    this.sourceId,
    this.sourceName,
    this.sourceUrl,
  });

  factory Source.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Source();

    return Source(
      sourceIcon: map['source_icon'],
      sourceId: map['source_id'],
      sourceName: map['source_name'],
      sourceUrl: map['source_url'],
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'source_icon': sourceIcon,
  //     'source_id': sourceId,
  //     'source_name': sourceName,
  //     'source_url': sourceUrl,
  //   };
  // }
}

class Article {
  final String? articleId;
  final List<String>? category;
  final List<String>? country;
  final String? description;
  final String? imageUrl;
  final String? language;
  final String? link;
  final String? pubDate;
  final Source? source;
  final String? title;
  final int? views;

  Article({
    this.articleId,
    this.category,
    this.country,
    this.description,
    this.imageUrl,
    this.language,
    this.link,
    this.pubDate,
    this.source,
    this.title,
    this.views,
  });

  factory Article.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Article();

    return Article(
      articleId: map['article_id'],
      category:
          map['category'] != null ? List<String>.from(map['category']) : null,
      country:
          map['country'] != null ? List<String>.from(map['country']) : null,
      description: map['description'],
      imageUrl: map['image_url'],
      language: map['language'],
      link: map['link'],
      pubDate: map['pubDate'],
      source: map['source'] != null ? Source.fromMap(map['source']) : null,
      title: map['title'],
      views: map['views'],
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'article_id': articleId,
  //     'category': category,
  //     'country': country,
  //     'description': description,
  //     'language': language,
  //     'link': link,
  //     'pubDate': pubDate,
  //     'source': source?.toMap(),
  //     'title': title,
  //     'views': views,
  //   };
  // }
}
