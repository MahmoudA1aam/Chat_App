import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model/user_model.dart';

class FireStoreUserUtils {
  static CollectionReference<UserModel> getCollection() {
    return FirebaseFirestore.instance
        .collection("users")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) =>
              UserModel.fromFireStore(snapshot.data()!),
          toFirestore: (value, _) => value.toFireStore(),
        );
  }

  static Future<void> addDataUserToFireStore(UserModel model) {
    var collection = getCollection();
    var docRef = collection.doc();

    return docRef.set(model);
  }

  static Future<List<UserModel>> getDataUSerFromFireStore() async {
    var snapshot = await getCollection().get();
    return snapshot.docs.map((element) => element.data()).toList();
  }
}
