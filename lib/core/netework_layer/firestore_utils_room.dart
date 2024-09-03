import 'package:cloud_firestore/cloud_firestore.dart';


import '../../models/room_model/room_mode.dart';

class FireStoreUtilsRoom{
static CollectionReference<RoomModel> getCollectionRoom() {
return FirebaseFirestore.instance
    .collection("AllRooms")
    .withConverter<RoomModel>(
fromFirestore: (snapshot, _) =>
RoomModel.fromFireStore(snapshot.data()!),
toFirestore: (value, _) => value.toFireStore(),
);
}

static Future<void> addRoomToFireStore(RoomModel model) {
var collection = getCollectionRoom();
var docRef = collection.doc();
model.roomId = docRef.id;
return docRef.set(model);
}

static Stream<QuerySnapshot<RoomModel>> getRoomRealTimeFromFireStore() {
var snapshot = getCollectionRoom().snapshots();
return snapshot;
}
}