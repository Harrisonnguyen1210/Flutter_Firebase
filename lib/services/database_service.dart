import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uId;
  DatabaseService({this.uId});

  // collection reference
  final CollectionReference _brewCollection = Firestore.instance.collection('brews');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await _brewCollection.document(uId).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength
    });
  }
  
}