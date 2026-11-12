import 'package:cloud_firestore/cloud_firestore.dart';
import 'shared_pref_service.dart';

/// Cache-first helper for Cloud Firestore queries and document reads.
///
/// Uses Firestore's local persistent cache (`Source.cache`) when a cached entry
/// is available and within its configured TTL, falling back to `Source.serverAndCache`
/// only when the cache is missing or stale.
class FirestoreCacheService {
  FirestoreCacheService._internal();
  static final FirestoreCacheService _instance =
      FirestoreCacheService._internal();
  factory FirestoreCacheService() => _instance;

  static const Duration channelsTtl = Duration(hours: 6);
  static const Duration newsTtl = Duration(minutes: 15);
  static const Duration savedListTtl = Duration(minutes: 5);

  static const String _tsPrefix = 'fs_cache_v2_ts_';
  static const String _emptyPrefix = 'fs_cache_v2_empty_';

  final SharedPrefService _prefs = SharedPrefService();

  bool _isFresh(String cacheKey, Duration ttl) {
    final lastFetchMs = _prefs.getInt('$_tsPrefix$cacheKey');
    if (lastFetchMs == null) return false;
    final ageMs = DateTime.now().millisecondsSinceEpoch - lastFetchMs;
    return ageMs >= 0 && ageMs < ttl.inMilliseconds;
  }

  Future<void> _markFetched(String cacheKey, {required bool isEmpty}) async {
    await _prefs.setInt(
      '$_tsPrefix$cacheKey',
      DateTime.now().millisecondsSinceEpoch,
    );
    await _prefs.setBool('$_emptyPrefix$cacheKey', isEmpty);
  }

  /// Invalidates the TTL metadata for [cacheKey] so the next read refreshes from server.
  Future<void> invalidate(String cacheKey) async {
    await _prefs.removeKey('$_tsPrefix$cacheKey');
    await _prefs.removeKey('$_emptyPrefix$cacheKey');
  }

  /// Fetches [query] from Firestore's local disk cache if fresh within [ttl],
  /// otherwise fetches from server (with offline cache fallback) and updates TTL.
  Future<QuerySnapshot<Map<String, dynamic>>> getQueryWithCache({
    required Query<Map<String, dynamic>> query,
    required String cacheKey,
    required Duration ttl,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _isFresh(cacheKey, ttl)) {
      try {
        final cached = await query.get(const GetOptions(source: Source.cache));
        final expectedEmpty = _prefs.getBool('$_emptyPrefix$cacheKey') ?? false;
        if (cached.docs.isNotEmpty || expectedEmpty) {
          return cached;
        }
      } catch (_) {
        // Cache miss or unavailable; fall through to serverAndCache.
      }
    }

    final snapshot =
        await query.get(const GetOptions(source: Source.serverAndCache));
    if (!snapshot.metadata.isFromCache) {
      await _markFetched(cacheKey, isEmpty: snapshot.docs.isEmpty);
    }
    return snapshot;
  }

  /// Fetches a single [docRef] from Firestore's local disk cache first,
  /// falling back to the server only if the document is not cached locally.
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentWithCache(
    DocumentReference<Map<String, dynamic>> docRef,
  ) async {
    try {
      final cached = await docRef.get(const GetOptions(source: Source.cache));
      if (cached.exists) {
        return cached;
      }
    } catch (_) {
      // Cache miss; fall through to serverAndCache.
    }
    return docRef.get(const GetOptions(source: Source.serverAndCache));
  }
}
