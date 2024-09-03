import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp/models/room_model/room_mode.dart';

import 'package:whatsapp/pages/home_view/widegt/bottomsheetwidgets.dart';
import 'package:whatsapp/pages/home_view/widegt/room_item.dart';

import 'package:whatsapp/pages/login_view/login_view.dart';

import '../../core/netework_layer/firestore_utils_room.dart';

import '../../core/utils/shareddata.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static String routeName = "Home";

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  File? file;

  // Color(0xFFE5E6EC)
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var dataUser = ModalRoute.of(context)!.settings.arguments as DataUser;
    return Scaffold(
      backgroundColor:const  Color(0xFF1E1E2A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:const  Text("Rooms"),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginView.routeName);
              },
              icon: const Icon(
                Icons.exit_to_app_sharp,
                size: 30,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewTask(context);
        },
        backgroundColor: theme.colorScheme.primary,
        child:const  Icon(
          Icons.add,
          size: 35,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<RoomModel>>(
        stream: FireStoreUtilsRoom.getRoomRealTimeFromFireStore(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.error.toString()),
                const SizedBox(
                  height: 20,
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }
          var roomList =
              snapshot.data?.docs.map((element) => element.data()).toList() ??
                  [];

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 20),
                    itemCount: roomList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 30,
                            crossAxisSpacing: 20,
                            childAspectRatio: 7 / 9,
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return RoomItem(
                        roomModel: roomList[index],
                        dataUser: dataUser,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void addNewTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetWidegt(),
    );
  }
}
