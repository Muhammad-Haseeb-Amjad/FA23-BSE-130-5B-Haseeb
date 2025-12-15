import 'package:flutter/material.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_model.dart';

class InviteSomeoneController extends BaseController {
  final Room? room;
  TextEditingController textEditingController = TextEditingController();
  List<User> users = [];

  InviteSomeoneController(this.room);

  @override
  void onReady() {
    searchUser();
    super.onReady();
  }

  Future<void> searchUser({bool shouldErase = false}) async {
    if (shouldErase) {
      users.clear();
    }
    await RoomService.shared.searchUserForInvitation(
      room?.id ?? 0,
      textEditingController.text,
      users.length,
      (newUsers) {
        users.addAll(newUsers);
        update();
      },
    );
  }

  void inviteUser(User user) {
    startLoading();
    RoomService.shared.inviteUserToRoom(
      user.id ?? 0,
      room?.id ?? 0,
      () {
        stopLoading();
        users.removeWhere((element) => element.id == user.id);
        update();
      },
    );
  }
}
