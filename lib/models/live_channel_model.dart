import 'package:cloud_firestore/cloud_firestore.dart';

class LiveChannelModel {
  final String channelDocId;
  final String name;
  final String region;
  final String url;
  final String logo;
  final String language;
  final int viewCount;
  final DateTime viewedAt;

  LiveChannelModel({
    required this.channelDocId,
    required this.name,
    required this.region,
    required this.url,
    required this.logo,
    required this.language,
    required this.viewCount,
    required this.viewedAt,
  });

  factory LiveChannelModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return LiveChannelModel(
      channelDocId: doc.id, // <-- assign document ID here
      name: data['name'] ?? '',
      region: data['region'] ?? '',
      url: data['url'] ?? '',
      logo: data['logo'] ?? '',
      language: data['language'] ?? '',
      viewCount: data['viewCount'] ?? 0,
      viewedAt: (data['viewedAt'] != null && data['viewedAt'] is Timestamp)
          ? (data['viewedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'LiveChannelModel(name: $name, region: $region, language: $language)';
  }
}
