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

  factory Source.fromMap(Map<String, dynamic>? map, {String? fallbackLink}) {
    if (map == null) return Source();

    final rawIcon = map['source_icon'] as String?;
    final rawSourceUrl = map['source_url'] as String?;

    return Source(
      sourceIcon: _resolveSourceIcon(
        rawIcon: rawIcon,
        sourceUrl: rawSourceUrl,
        fallbackLink: fallbackLink,
      ),
      sourceId: map['source_id'],
      sourceName: map['source_name'],
      sourceUrl: rawSourceUrl,
    );
  }

  static String? _resolveSourceIcon({
    required String? rawIcon,
    required String? sourceUrl,
    String? fallbackLink,
  }) {
    final trimmed = rawIcon?.trim();
    final iconUri =
        (trimmed != null && trimmed.isNotEmpty) ? Uri.tryParse(trimmed) : null;
    final iconHost = iconUri?.host.toLowerCase() ?? '';
    final isDeadOrMissing = trimmed == null ||
        trimmed.isEmpty ||
        iconHost == 'n.bytvi.com' ||
        iconHost == 'bytvi.com' ||
        iconHost.endsWith('.bytvi.com');

    if (!isDeadOrMissing) {
      return trimmed;
    }

    final publisherHost =
        _extractHost(sourceUrl) ?? _extractHost(fallbackLink);
    if (publisherHost == null || publisherHost.isEmpty) {
      return null;
    }
    return 'https://www.google.com/s2/favicons?domain=${Uri.encodeQueryComponent(publisherHost)}&sz=64';
  }

  static String? _extractHost(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final uri = Uri.tryParse(url.trim());
    final host = uri?.host.trim();
    if (host == null || host.isEmpty) return null;
    return host;
  }

  Map<String, dynamic> toMap() {
    return {
      'source_icon': sourceIcon,
      'source_id': sourceId,
      'source_name': sourceName,
      'source_url': sourceUrl,
    };
  }
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
      source: map['source'] != null
          ? Source.fromMap(
              map['source'],
              fallbackLink: map['link'] as String?,
            )
          : null,
      title: map['title'],
      views: map['views'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'article_id': articleId,
      'category': category,
      'country': country,
      'description': description,
      'image_url': imageUrl,
      'language': language,
      'link': link,
      'pubDate': pubDate,
      'source': source?.toMap(),
      'title': title,
      'views': views,
    };
  }
}
