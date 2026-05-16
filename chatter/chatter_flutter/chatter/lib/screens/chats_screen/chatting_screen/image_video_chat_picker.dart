import 'dart:io';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/image_video_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_controller.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/firebase_const.dart';

class ImageVideoOptionPicker extends StatelessWidget {
  final Function() onVideoTap;
  final Function() onImageTap;

  const ImageVideoOptionPicker({super.key, required this.onVideoTap, required this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const ShapeDecoration(
            color: cBlack,
            shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius.only(topLeft: SmoothRadius(cornerRadius: 30, cornerSmoothing: cornerSmoothing), topRight: SmoothRadius(cornerRadius: 30, cornerSmoothing: cornerSmoothing))),
          ),
          padding: const EdgeInsets.all(25),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Spacer(),
                    XMarkButton(),
                  ],
                ),
                Text(
                  LKeys.howDoYouWant.tr,
                  style: MyTextStyle.gilroyBold(size: 22, color: cWhite),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    btn(title: LKeys.image, onTap: onImageTap),
                    const SizedBox(width: 10),
                    btn(title: LKeys.video, onTap: onVideoTap),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget btn({required String title, required Function() onTap}) {
    return Expanded(
      child: CommonSheetButton(
        title: title.tr,
        onTap: onTap,
      ),
    );
  }
}

class WriteDescriptionSheet extends StatefulWidget {
  final XFile file;
  final ChattingController controller;
  final MessageType type;

  const WriteDescriptionSheet({super.key, required this.file, required this.controller, required this.type});

  @override
  State<WriteDescriptionSheet> createState() => _WriteDescriptionSheetState();
}

class _WriteDescriptionSheetState extends State<WriteDescriptionSheet> {
  XFile? thumbnail;
  bool _isSending = false;

  setImage() async {
    if (widget.type == MessageType.video) {
      ImageVideoManager.shared.extractThumbnail(videoPath: widget.file.path).then((value) {
        thumbnail = XFile(value.path);
        if (mounted) setState(() {});
      });
    } else {
      thumbnail = widget.file;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    setImage();
    super.initState();
  }

  void _onSendTap() {
    if (_isSending) return;
    setState(() { _isSending = true; });

    if (widget.type == MessageType.image) {
      // Image: upload then send (images are small, acceptable to wait briefly)
      widget.controller.startLoading();
      PostService.shared.uploadFile(widget.file, (url) {
        widget.controller.stopLoading();
        Get.back();
        widget.controller.commonSend(type: MessageType.image, content: url);
      });
    } else {
      // Video: WhatsApp-like flow —
      // 1. Immediately close the preview sheet.
      // 2. Insert a pending local message in chat right away.
      // 3. Upload video + thumbnail in background with progress.
      // 4. When done, update the pending message with real URLs.
      final localVideoPath = widget.file.path;
      final localThumbPath = thumbnail?.path ?? '';
      final caption = widget.controller.messageTextController.text;
      final localId = DateTime.now().microsecondsSinceEpoch.toString();

      // Close preview immediately — do NOT await upload.
      Get.back();

      // Add a local pending message so the user sees it instantly.
      widget.controller.addPendingVideoMessage(
        localId: localId,
        localVideoPath: localVideoPath,
        localThumbPath: localThumbPath,
        caption: caption,
      );

      // Upload video in background using progress-aware method.
      PostService.shared.uploadFileWithProgress(
        widget.file,
        onProgress: (pct) {
          // Video upload counts as 90% of total progress; thumb is the last 10%.
          widget.controller.updatePendingVideoProgress(localId, pct * 0.9);
        },
      ).then((videoURL) {
        if (videoURL == null) {
          widget.controller.failPendingVideoMessage(localId: localId);
          return;
        }
        if (localThumbPath.isNotEmpty) {
          PostService.shared.uploadFileWithProgress(XFile(localThumbPath)).then((thumbURL) {
            widget.controller.completePendingVideoMessage(
              localId: localId,
              videoURL: videoURL,
              thumbnailURL: thumbURL ?? '',
            );
          }).catchError((_) {
            // Thumb upload failed — still complete with empty thumb URL.
            widget.controller.completePendingVideoMessage(
              localId: localId,
              videoURL: videoURL,
              thumbnailURL: '',
            );
          });
        } else {
          widget.controller.completePendingVideoMessage(
            localId: localId,
            videoURL: videoURL,
            thumbnailURL: '',
          );
        }
      }).catchError((_) {
        widget.controller.failPendingVideoMessage(localId: localId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cWhite,
      child: Column(
        children: [
          TopBarForInView(
            title: '',
            backIcon: Icons.close_rounded,
            child: GestureDetector(
              onTap: _isSending ? null : _onSendTap,
              child: Opacity(
                opacity: _isSending ? 0.5 : 1.0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 7, bottom: 5),
                  decoration: BoxDecoration(color: cPrimary, borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    LKeys.send.tr.toUpperCase(),
                    style: MyTextStyle.gilroySemiBold(color: cBlack, size: 14),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      height: 130,
                      decoration: const ShapeDecoration(
                        shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 8, cornerSmoothing: cornerSmoothing))),
                        color: cLightBg,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      child: TextField(
                        controller: widget.controller.messageTextController,
                        textCapitalization: TextCapitalization.sentences,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        style: MyTextStyle.gilroyRegular(color: cDarkText.withValues(alpha: 0.6)),
                        decoration: InputDecoration(hintText: LKeys.writeHere.tr, hintStyle: MyTextStyle.gilroyRegular(color: cLightText.withValues(alpha: 0.6)), border: InputBorder.none, counterText: '', isDense: true, contentPadding: const EdgeInsets.all(0)),
                        cursorColor: cPrimary,
                        maxLength: null,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(height: 15),
                    (thumbnail?.path ?? '') == ''
                        ? Container()
                        : ClipSmoothRect(
                            radius: const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing)),
                            child: Image.file(
                              File(thumbnail?.path ?? ''),
                              fit: BoxFit.cover,
                              height: Get.width - 20,
                              width: Get.width - 20,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
