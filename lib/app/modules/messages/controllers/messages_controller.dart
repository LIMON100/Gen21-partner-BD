import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/chat_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../services/auth_service.dart';

class MessagesController extends GetxController {
  EProviderRepository _eProviderRepository;

  final uploading = false.obs;
  var message = Message([]).obs;
  ChatRepository _chatRepository;
  NotificationRepository _notificationRepository;
  AuthService _authService;
  var messages = <Message>[].obs;
  var chats = <Chat>[].obs;
  File imageFile;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = true.obs;
  final isDone = false.obs;
  ScrollController scrollController = ScrollController();
  final chatTextController = TextEditingController();
  // var chatName = "User".obs;


  MessagesController() {
    _eProviderRepository = EProviderRepository();

    _chatRepository = new ChatRepository();
    _notificationRepository = new NotificationRepository();
    _authService = Get.find<AuthService>();
  }

  @override
  void onInit() async {
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Appliance Repair Company'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Shifting Home'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Pet Car Company'));

    // List<User> _employees = await _eProviderRepository.getUsersByUserId(booking.value.acceptor_provider_id);

    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        await listenForMessages();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    chatTextController.dispose();
  }

  Future createMessage(Message _message) async {
    _message.users.insert(0, _authService.user.value);
    _message.lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    _message.readByUsers = [_authService.user.value.id];

    message.value = _message;

    printWrapped("sjfnsdna createMessage() message: ${message.toString()}");

    _chatRepository.createMessage(_message).then((value) {
      listenForChats();
    });
  }

  Future deleteMessage(Message _message) async {
    messages.remove(_message);
    await _chatRepository.deleteMessage(_message);
  }

  Future refreshMessages() async {
    messages.clear();
    lastDocument = new Rx<DocumentSnapshot>(null);
    await listenForMessages();
  }

  Future<List<Message>> getUserAndProviderMessageId(String customerId) async {
    print("fdafgagtafppp getUserAndProviderMessages() called providerId:$customerId  _authService.user.value.id: ${_authService.user.value.id}");
    var completer = Completer<List<Message>>();
    var messages2 = <Message>[].obs;
    Stream<QuerySnapshot> _userMessages2 = await _chatRepository.getUserMessagesForId(_authService.user.value.id);
    _userMessages2.listen((QuerySnapshot query)  {
      print("sndnfdsnjsd query.toString(): ${query.toString()}");

      if (query.docs.isNotEmpty) {
        printWrapped("fdafgagtaf test query.docs: ${query.docs.toString()}");

        query.docs.forEach((element) {
          messages2.add(Message.fromDocumentSnapshot(element));
        });

        printWrapped("sndnfdsnjsd 1 messages2.length: ${messages2.length} ${messages2.toString()}");

        if (messages2.length > 0) {
          messages2.removeWhere((element) => !element.visibleToUsers.contains(customerId));
        }

        printWrapped("sndnfdsnjsd 2 messages2.length: ${messages2.length} ${messages2.toString()}");

      } else {
        printWrapped("sndnfdsnjsd query empty");
      }
      completer.complete(messages2);
    });

    printWrapped("fdafgagtaf returning messages2 ${messages2.toString()}");
    // return messages2;
    return completer.future;
  }

  Future listenForMessages() async {
    isLoading.value = true;
    isDone.value = false;
    Stream<QuerySnapshot> _userMessages;
    if (lastDocument.value == null) {
      print("djnjfsafns listenForMessages() 1 _userMessages:  ${_authService.user.value.id}");
      _userMessages = _chatRepository.getUserMessages(_authService.user.value.id);
    } else {
      print("djnjfsafns listenForMessages() 2 _userMessages:  ${_authService.user.value.id}");

      _userMessages = _chatRepository.getUserMessagesStartAt(_authService.user.value.id, lastDocument.value);
    }
    _userMessages.listen((QuerySnapshot query) {
      messages.clear();
      if (query.docs.isNotEmpty) {
        query.docs.forEach((element) {
          messages.add(Message.fromDocumentSnapshot(element));
        });
        lastDocument.value = query.docs.last;
      } else {
        isDone.value = true;
      }

    });
    isLoading.value = false;
  }

  listenForChats() async {
    message.value = await _chatRepository.getMessage(message.value);
    printWrapped("sjfnsdna listenForChats() message: ${message.toString()}");
    // makeChatName(message.value);
    message.value.readByUsers.add(_authService.user.value.id);
    _chatRepository.getChats(message.value).listen((event) {
      chats.assignAll(event);
    });
  }

  // makeChatName(Message message){
  //   var userNames = <String>[];
  //   message.users.forEach((element) {
  //     if(element.id != _authService.userId){
  //       userNames.add(element.name);
  //     }
  //   });
  //   String chatName = userNames.join(', ');
  //   if(chatName != ""){
  //     this.chatName.value = chatName;
  //   }
  //   print("sdklfanfd $chatName");
  // }

  addMessage(Message _message, String text) {
    Chat _chat = new Chat(text, DateTime.now().millisecondsSinceEpoch, _authService.user.value.id, _authService.user.value);
    if (_message.id == null) {
      _message.id = UniqueKey().toString();
      createMessage(_message);
    }
    _message.lastMessage = text;
    _message.lastMessageTime = _chat.time;
    _message.readByUsers = [_authService.user.value.id];
    uploading.value = false;
    _chatRepository.addMessage(_message, _chat).then((value) {}).then((value) {
      List<User> _users = [];
      _users.addAll(_message.users);
      _users.removeWhere((element) => element.id == _authService.user.value.id);
      _notificationRepository.sendNotification(_users, _authService.user.value, "App\\Notifications\\NewMessage", text.contains("https://firebasestorage.googleapis.com/")? "Image Attached": text, _message.id);
    });
  }

  Future getImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile pickedFile;

    pickedFile = await imagePicker.pickImage(source: source);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      try {
        uploading.value = true;
        return await _chatRepository.uploadFile(imageFile);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select an image file".tr));
    }
  }
}
