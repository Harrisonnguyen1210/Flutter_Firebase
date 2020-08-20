import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/brew.dart';

class DatabaseService {
  final String uId;
  DatabaseService({this.uId});

  // collection reference
  final CollectionReference _brewCollection =
      Firestore.instance.collection('brews');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await _brewCollection
        .document(uId)
        .setData({'sugars': sugars, 'name': name, 'strength': strength});
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((document) => Brew(
        name: document.data['name'] ?? '',
        sugars: document.data['sugars'] ?? 0,
        strength: document.data['strength'] ?? '')).toList();
  }

  Stream<List<Brew>> get brews {
    return _brewCollection.snapshots().map(_brewListFromSnapshot);
  }
}
