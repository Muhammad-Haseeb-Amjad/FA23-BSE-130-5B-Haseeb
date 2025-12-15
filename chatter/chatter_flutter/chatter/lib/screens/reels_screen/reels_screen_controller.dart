import 'dart:async';
import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/api_service/reel_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/logger.dart';
import 'package:untitled/common/managers/my_debouncer.dart';
import 'package:untitled/enums/reel_page_type.dart';
import 'package:untitled/models/reel_model.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/reels_screen/reel/reel_page_controller.dart';

class ReelsScreenController extends BaseController {
  RxMap<int, CachedVideoPlayerPlus> videoControllers = <int, CachedVideoPlayerPlus>{}.obs;

  RxList<Reel> reels = <Reel>[].obs;
  RxInt position = 0.obs;

  String? hashtag;
  User? user;
  ReelPageType reelPageType;

  PageController pageController = PageController();
  Future<void> Function()? onFetchMoreData;
  Future<void> Function()? onRefresh;

  TextEditingController commentTextController = TextEditingController();

  ReelsScreenController({
    required this.reels,
    required this.position,
    this.user,
    this.hashtag,
    required this.reelPageType,
    required this.onFetchMoreData,
    required this.onRefresh,
  });

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: position.value);
  }

  @override
  void onClose() {
    super.onClose();
    disposeAllController();
  }

  Future<void> _fetchMoreData() async {
    if (position >= reels.length - 3) {
      Future.delayed(Duration(seconds: 1), () async {
        await onFetchMoreData?.call().then((value) {
          _initializeControllerAtIndex(position.value + 1);
        });
      });
    }
  }

  void pauseAllPlayers() {
    videoControllers.forEach((key, value) {
      value.controller.pause();
    });
  }

  void initVideoPlayer() async {
    /// Initialize 1st video
    await _initializeControllerAtIndex(position.value);

    /// Play 1st video
    _playControllerAtIndex(position.value);

    /// Initialize 2nd vide
    if (position >= 0) {
      await _initializeControllerAtIndex(position.value - 1);
    }
    await _initializeControllerAtIndex(position.value + 1);
  }

  void _playNextReel(int index) {
    _stopControllerAtIndex(index - 1); // Ensure previous reel is stopped
    _disposeControllerAtIndex(index - 2); // Dispose the older controller
    _playControllerAtIndex(index); // Play the new reel
    _initializeControllerAtIndex(index + 1); // Preload the next reel
  }

  void _playPreviousReel(int index) {
    _stopControllerAtIndex(index + 1); // Ensure next reel is stopped
    _disposeControllerAtIndex(index + 2); // Dispose the older controller
    _playControllerAtIndex(index); // Play the previous reel
    _initializeControllerAtIndex(index - 1); // Preload the previous reel
  }

  Future _initializeControllerAtIndex(int index) async {
    if (reels.length > index && index >= 0) {
      /// Create new controller
      late CachedVideoPlayerPlus playerPlus;
      if (reels[index].id == -1) {
        playerPlus = CachedVideoPlayerPlus.file(
          File((reels[index].content ?? '')),
        );
      } else {
        playerPlus = CachedVideoPlayerPlus.networkUrl(
          Uri.parse((reels[index].content ?? '')),
        );
      }
      await playerPlus.initialize();

      /// Add to [controllers] list
      videoControllers[index] = playerPlus;

      Loggers.info('🚀🚀🚀 INITIALIZED $index');
      Loggers.info('############################################################');
    }
  }

  void _playControllerAtIndex(int index) async {
    if (reels.length > index && index >= 0) {
      CachedVideoPlayerPlus? playerPlus = videoControllers[index];
      if (playerPlus != null && playerPlus.controller.value.isInitialized == true) {
        playerPlus.controller.play();
        playerPlus.controller.setLooping(true);
        videoControllers.refresh();
        MyDebouncer.shared.run(milliseconds: 3000, () {
          _increaseViewsCount(reels[index]);
        });
        Loggers.info('🚀🚀🚀 PLAYING $index');
      } else {
        await _initializeControllerAtIndex(index);
        _playControllerAtIndex(index);
      }
    }
  }

  void _increaseViewsCount(Reel? reel) async {
    int reelId = reel?.id?.toInt() ?? -1;
    if (reel == null) {
      return Loggers.error('Post not found');
    }
    if (reelId == -1) {
      return;
    }

    bool status = await ReelService.shared.increaseViewCount(reelId: reelId);
    if (status) {
      reel.viewsCount = (reel.viewsCount ?? 0) + 1;
      reels[reels.indexWhere((element) => element.id == reelId)] = reel;
    }
  }

  void _stopControllerAtIndex(int index) {
    if (reels.length > index && index >= 0) {
      final playerPlus = videoControllers[index];
      if (playerPlus != null) {
        playerPlus.controller.pause();
        playerPlus.controller.seekTo(const Duration()); // Reset position
        Loggers.info('🚀🚀🚀 STOPPED $index');
      }
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (reels.length > index && index >= 0) {
      final CachedVideoPlayerPlus? playerPlus = videoControllers[index];
      if (playerPlus != null) {
        _stopControllerAtIndex(index); // Ensure the video is stopped before disposal
        playerPlus.dispose();
        videoControllers.remove(index);
        Loggers.info('🚀🚀🚀 DISPOSED $index');
      }
    }
  }

  Future<void> disposeAllController() async {
    for (var playerPlus in videoControllers.values) {
      playerPlus.controller.pause(); // Pause the controller before disposing
      playerPlus.controller.dispose(); // Dispose the controller
    }
    videoControllers.clear(); // Clear the controllers map after disposing
  }

  void onPageChanged(int index) {
    if (index > position.value) {
      _fetchMoreData();

      _playNextReel(index);
    } else {
      _playPreviousReel(index);
    }
    position.value = index;
  }

  void updatePageController(bool reset) {
    if (reset) {
      if (pageController.hasClients) {
        pageController.jumpToPage(0); // Reset to first page
      } else {
        pageController = PageController(initialPage: 0);
      }
    }
  }

  void addComment() async {
    if (commentTextController.text.isEmpty) return;
    Reel reel = reels[position.value];
    if (Get.isRegistered<ReelController>(tag: reel.id?.toString() ?? '')) {
      var reelController = Get.find<ReelController>(tag: reel.id?.toString() ?? '');

      await ReelService.shared.addComment(comment: commentTextController.text, reelId: reel.id ?? 0);
      stopLoading();

      commentTextController.clear();
      reelController.reel.update((val) {
        val?.commentsCount = (reelController.reel.value?.commentsCount ?? 0) + 1;
      });
    }
  }

  void onRefreshPage() async {
    await onRefresh?.call();
    position.value = 0;
    await disposeAllController();
    initVideoPlayer();
  }
}
