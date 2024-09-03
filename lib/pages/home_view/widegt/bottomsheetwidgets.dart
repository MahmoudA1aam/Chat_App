import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import 'package:whatsapp/models/room_model/room_mode.dart';

import '../../../core/netework_layer/firestore_utils_room.dart';
import '../../../core/services/snackbar_sevice.dart';

import '../../../core/widegts/cutsom_textField.dart';

class BottomSheetWidegt extends StatefulWidget {
  BottomSheetWidegt({super.key});

  @override
  State<BottomSheetWidegt> createState() => _BottomSheetWidegtState();
}

class _BottomSheetWidegtState extends State<BottomSheetWidegt> {
  final TextEditingController roomNameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  File? file;
  String? imageUrl;

  @override
  void initState() {
    pickImage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(20),
      color: Colors.white,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Add New Room",
                style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  pickImage();
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: file == null
                          ? Image.asset(
                              "assets/image/live-chat2.png",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              file!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Icon(Icons.add_a_photo)
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              CustomTextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "You Must Provide Room Name";
                    } else {
                      return null;
                    }
                  },
                  controller: roomNameController,
                  hintText: "Room Name"),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      if (formKey.currentState!.validate()) {
                        EasyLoading.show();
                        if (imageUrl!.isEmpty) {
                          EasyLoading.show();
                        }

                        RoomModel roomModel = RoomModel(
                            title: roomNameController.text,
                            description: descriptionController.text,
                            image: imageUrl);
                        await FireStoreUtilsRoom.addRoomToFireStore(roomModel);

                        EasyLoading.dismiss();

                        SnackBarService.showSuccessMessage(
                            "Room Created  successfully");
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  child: Text(
                    "Add",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    String filename = DateTime.now().microsecondsSinceEpoch.toString();
    if (imageGallery != null) {
      setState(() {
        file = File(imageGallery!.path);
      });
      var refRoot = FirebaseStorage.instance.ref();
      var refDireImage = refRoot.child("images/mountains.jpg");
      var refImageUpload = refDireImage.child(filename);

      await refImageUpload.putFile(File(imageGallery.path));
      imageUrl = await refImageUpload.getDownloadURL();
    }
  }
}
