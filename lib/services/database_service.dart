import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/brew.dart';

class DatabaseService {
  final String uId;
  DatabaseService({this.uId});

  // collection reference
  final CollectionReference _brewCollection =
      Firestore.instance.collection('brews');

  Future<void> updateUserData(Map<String, dynamic> brewData) async {
    return await _brewCollection.document(uId).setData({
      'sugars': brewData['sugars'],
      'name': brewData['name'],
      'strength': brewData['strength']
    });
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((document) => Brew(
            name: document.data['name'] ?? '',
            sugars: document.data['sugars'] ?? 0,
            strength: document.data['strength'] ?? ''))
        .toList();
  }

  Stream<List<Brew>> get brews {
    return _brewCollection.snapshots().map(_brewListFromSnapshot);
  }
}
