import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/message_model/message_model.dart';

class FireStoreUtilsMessage {
  static CollectionReference<MessageModel> getCollection(String roomId) {
    return FirebaseFirestore.instance
        .collection("Rooms")
        .doc(roomId)
        .collection("Messages")
        .withConverter<MessageModel>(
          fromFirestore: (snapshot, _) =>
              MessageModel.fromFireStore(snapshot.data()!),
          toFirestore: (value, _) => value.toFireStore(),
        );
  }

  static Future<void> addMessageToFireStore(
      MessageModel messageModel, String roomId) {
    var collection = getCollection(roomId);
    var docRef = collection.doc();

    return docRef.set(messageModel);
  }

  static Stream<QuerySnapshot<MessageModel>> getMessageRealTimeFromFireStore(
      String roomId) {
    var snapshot = getCollection(roomId).orderBy("dateTime",descending: true).snapshots();
    return snapshot;
  }
}
