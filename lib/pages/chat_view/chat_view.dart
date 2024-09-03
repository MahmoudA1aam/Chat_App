import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/netework_layer/firestore_utils_message.dart';

import '../../core/utils/formatedatTime.dart';

import '../../models/message_model/message_model.dart';

class ChattView extends StatelessWidget {
  ChattView({
    super.key,
    required this.roomId,
    required this.userName,
    required this.roomTitle,
    required this.userEmail,
  });

  static String routeName = "chatView";
  String userName;
  String userEmail;
  String roomTitle;
  String roomId;

  TextEditingController messageController = TextEditingController();

  final _controller = ScrollController();

  @override
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/image/pattern.png",
              ),
              opacity: 220,
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text(roomTitle), backgroundColor: theme.colorScheme.primary),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot<MessageModel>>(
                stream: FireStoreUtilsMessage.getMessageRealTimeFromFireStore(
                    roomId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.error.toString()),
                        const SizedBox(
                          height: 20,
                        ),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.refresh))
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
                  var messageList = snapshot.data?.docs
                          .map((element) => element.data())
                          .toList() ??
                      [];

                  return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return messageList[index].email == userEmail
                          ? CustomSendMessage(
                              messageModel: messageList[index],
                            )
                          : CustomRecievedMessage(
                              messageModel: messageList[index],
                            );
                    },
                  );
                },
              )),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Message",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  BorderSide(color: theme.colorScheme.primary)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (messageController.text.isNotEmpty) {
                        MessageModel message = MessageModel(
                            content: messageController.text,
                            email: userEmail,
                            senderName: userName,
                            dateTime: DateTime.now().microsecondsSinceEpoch);
                        FireStoreUtilsMessage.addMessageToFireStore(
                            message, roomId);
                        messageController.clear();
                        _controller.animateTo(
                          0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: CircleAvatar(
                        radius: 25,
                        backgroundColor: theme.colorScheme.primary,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 28,
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSendMessage extends StatelessWidget {
  const CustomSendMessage({super.key, required this.messageModel});

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: const EdgeInsets.only(left: 13, right: 8, top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(18)),
            color: theme.colorScheme.primary),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            messageModel.content,
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
          Text(
            formatDateTime(
              messageModel.dateTime,
            ),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ]),
      ),
    );
  }
}

class CustomRecievedMessage extends StatelessWidget {
  const CustomRecievedMessage({super.key, required this.messageModel});

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 13, top: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18)),
                color: Color(0xff4C585C),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageModel.senderName,
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      messageModel.content,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ]),
            ),
            Text(
              formatDateTime(
                messageModel.dateTime,
              ),
              textAlign: TextAlign.end,
              style: TextStyle(color: Color(0xff83949D), fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
