import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:untitled/common/api_service/moderator_service.dart';
import 'package:untitled/common/api_service/reel_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/managers/share_manager.dart';
import 'package:untitled/common/widgets/functions.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/reel_model.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/feed_screen/feed_screen_controller.dart';
import 'package:untitled/screens/follow_button/follow_controller.dart';
import 'package:untitled/utilities/const.dart';

import '../sheets/confirmation_sheet.dart';

class ProfileController extends FeedScreenController {
  User? user;
  final int userID;
  String followBtnID = "follow_btn";

  double maxExtent = 250.0;
  double currentExtent = 250.0;
  double _lastReportedOpacity = -1.0;
  final bool isFromTabBar;
  final idForImage = '${DateTime.now().microsecondsSinceEpoch}';

  RxInt selectedPage = 0.obs;
  RxList<Reel> reels = RxList();

  PageController pageController = PageController(initialPage: 0);
  VoidCallback? _profileScrollListener;

  // ScrollController newScrollController = ScrollController();

  ProfileController(this.userID, this.isFromTabBar);

  void updateEverything() {
    update([scrollID]);
    update();
  }

  void updateMyProfile() {
    if (user?.id == SessionManager.shared.getUserID()) {
      user = SessionManager.shared.getUser();
      update();
      update([scrollID]);
    }
  }

  void getStories() {
    UserService.shared.fetchProfile(userID, (user) {
      this.user = user;

      if (user.id == SessionManager.shared.getUserID()) {
        SessionManager.shared.setUser(user);
      }
      update();
      update([scrollID]);
    });
  }

  Future<void> getProfile({bool isForRefresh = false}) async {
    if (!isForRefresh && !isFromTabBar) {
      startLoading();
    }
    await UserService.shared.fetchProfile(userID, (user) {
      this.user = user;

      if (Get.isRegistered<FollowController>(tag: '${user.id}')) {
        var controller = Get.find<FollowController>(tag: '${user.id}');
        controller.user.value = user;
      }

      if (user.id == SessionManager.shared.getUserID()) {
        SessionManager.shared.setUser(user);
      }
      update();
      update([scrollID]);
      stopLoading();
    });
  }

  @override
  void onReady() {
    super.onReady();
    user = User(id: userID);
    getProfile();
    if (!(user?.isBlockedByMe() ?? false)) {
      fetchUserPosts(userID: userID);
      fetchReels();
    }
    _profileScrollListener ??= () {
      if (scrollController == null || !scrollController!.hasClients) return;
      currentExtent = maxExtent - scrollController!.offset;
      if (currentExtent < 0) currentExtent = 0.0;
      if (currentExtent > maxExtent) currentExtent = maxExtent;
      // Compute opacity using the same formula as profile_screen.dart
      final temp = currentExtent * 0.28;
      final size = temp < 35.0 ? 35.0 : temp;
      final o = (-1 * (size - 70)) * 0.02857143;
      final newOpacity = (1 - (o > 1.0 ? 1.0 : o)).clamp(0.0, 1.0);
      // Only rebuild when opacity changes meaningfully — eliminates jank
      if ((newOpacity - _lastReportedOpacity).abs() > 0.02) {
        _lastReportedOpacity = newOpacity;
        update([scrollID]);
      }
    };
    scrollController?.addListener(_profileScrollListener!);
  }

  bool isAllReelsFetched = false;

  Future<void> fetchReels({bool shouldRefresh = false}) async {
    if (shouldRefresh) {
      isAllReelsFetched = false;
      reels.clear();
    }
    if (isAllReelsFetched) return;
    var newReels = await ReelService.shared
        .fetchReelsByUser(userId: userId, start: reels.length);
    reels.addAll(newReels);
    if (newReels.length < Limits.pagination) {
      isAllReelsFetched = true;
    }
  }

  void blockByModerator() {
    Future.delayed(const Duration(milliseconds: 1), () {
      Get.bottomSheet(ConfirmationSheet(
        desc: LKeys.blockUserGloballyByModeratorDesc,
        buttonTitle: LKeys.block,
        onTap: () {
          ModeratorService.shared.blockUser(
              userId: userId,
              completion: () async {
                user?.followingStatus =
                    await FollowController.unfollow(user)?.followingStatus;
                posts.clear();
                updateEverything();
                Get.back();
              });
        },
      ));
    });
  }

  void blockUnblock() {
    if (user?.isBlockedByMe() ?? false) {
      unblockUser(user, () {
        fetchUserPosts(userID: (user?.id ?? 0).toInt());
        updateEverything();
      });
    } else {
      blockUser(user, () async {
        user = await FollowController.unfollow(user);
        posts.clear();
        updateEverything();
      });
    }
  }

  @override
  void onClose() {
    Functions.changStatusBar(StatusBarStyle.white);
    if (_profileScrollListener != null) {
      scrollController?.removeListener(_profileScrollListener!);
    }
    pageController.dispose();
    super.onClose();
  }

  void shareProfile() {
    ShareManager.shared
        .shareTheContent(key: ShareKeys.user, value: user?.id?.toInt() ?? 0);
  }

  void onChangeSegment(int value) {
    selectedPage.value = value;
    // controller.jumpToPage(value);
  }

  void deleteReel(Reel reel) {
    Get.bottomSheet(ConfirmationSheet(
      desc: LKeys.deleteReelDesc.tr,
      buttonTitle: LKeys.delete.tr,
      onTap: () {
        reels.removeWhere((element) => element.id == reel.id);
        ReelService.shared.deleteReel(reelId: reel.id ?? 0);
      },
    ));
  }

  void deleteReelByModerator(Reel reel) {
    Get.bottomSheet(ConfirmationSheet(
      desc: LKeys.deleteReelDesc,
      buttonTitle: LKeys.delete,
      onTap: () {
        reels.removeWhere((element) => element.id == reel.id);
        ModeratorService.shared.deleteReel(reelId: reel.id ?? 0);
      },
    ));
  }
}
