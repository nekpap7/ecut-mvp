import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String id;
  final String name;
  final String address;
  final double rating;
  final double lat;
  final double lng;
  final List<String> services;
  final String? photoUrl;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.lat,
    required this.lng,
    required this.services,
    this.photoUrl,
  });

  factory Store.fromSnap(DocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data()!;
    final gp = data['location'] as GeoPoint; // Firestore GeoPoint
    return Store(
      id: d.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      lat: gp.latitude,
      lng: gp.longitude,
      services: (data['services'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      photoUrl: data['photoUrl'] as String?,
    );
  }
}

class StoreService {
  final _col = FirebaseFirestore.instance.collection('stores').withConverter<Map<String, dynamic>>(
    fromFirestore: (snap, _) => snap.data() ?? {},
    toFirestore: (data, _) => data,
  );

  /// Αν περάσεις service, φιλτράρει με array-contains (π.χ. "Κούρεμα").
  Stream<List<Store>> streamStores({String? service}) {
    Query<Map<String, dynamic>> q = _col;
    if (service != null && service.isNotEmpty) {
      q = q.where('services', arrayContains: service);
    }
    return q.snapshots().map((s) => s.docs.map((d) => Store.fromSnap(d)).toList());
  }
}
