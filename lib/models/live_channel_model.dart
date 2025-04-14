import 'package:cloud_firestore/cloud_firestore.dart';

class LiveChannelModel {
  final String name;
  final String region;
  final String url;
  final String logo;
  final String language;
  final int viewCount;
  final DateTime viewedAt;

  LiveChannelModel({
    required this.name,
    required this.region,
    required this.url,
    required this.logo,
    required this.language,
    required this.viewCount,
    required this.viewedAt,
  });

  factory LiveChannelModel.fromJson(Map<String, dynamic> json) {
    return LiveChannelModel(
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      url: json['url'] ?? '',
      logo: json['logo'] ?? '',
      language: json['language'] ?? '',
      viewCount: json['viewCount'] ?? 0,
      viewedAt: (json['viewedAt'] != null && json['viewedAt'] is Timestamp)
          ? (json['viewedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'LiveChannelModel(name: $name, region: $region, language: $language)';
  }
}
