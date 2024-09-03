import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/shareddata.dart';

import '../../../models/room_model/room_mode.dart';
import '../../chat_view/chat_view.dart';

class RoomItem extends StatelessWidget {
  RoomItem({super.key, required this.roomModel, required this.dataUser});

  final RoomModel roomModel;
  final DataUser dataUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ChattView(
                  roomId: roomModel.roomId ?? "",
                  userName: dataUser.name,
                  roomTitle: roomModel.title,
                  userEmail: dataUser.email);
            },
          ));
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black87,
                            spreadRadius: -2,
                            blurStyle: BlurStyle.normal,
                            blurRadius: 8,
                            offset: Offset(10.0, 11.0)),
                      ]),
                  child: roomModel.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            roomModel.image ?? "",
                            height: 120,
                            width: 145,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CircularProgressIndicator())),
            ),
            SizedBox(height: 7,),
            Text(
              roomModel.title,
              style: const TextStyle(
                  fontSize: 20,

                  color: Colors.white),
            )
          ],
        ));
  }
}
