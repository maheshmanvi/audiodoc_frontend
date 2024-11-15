import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/widgets/audio_player/audio_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';

import '../../pages/view_note/view_note_controller.dart';


class SubtitlesView extends StatefulWidget {
  const SubtitlesView({super.key});

  @override
  State<SubtitlesView> createState() => _SubtitlesViewState();
}

class _SubtitlesViewState extends State<SubtitlesView> {
  AudioPlayerViewController audioPlayerViewController = Get.find<AudioPlayerViewController>();
  ViewNoteController viewNoteController = Get.find<ViewNoteController>();
  // late ViewNoteController viewNoteController;

  @override
  Widget build(BuildContext context) {
    // viewNoteController = Get.put(ViewNoteController(context, id: ''));
    // viewNoteController = (Get.isRegistered<ViewNoteController>()) ? Get.find<ViewNoteController>() : Get.put(ViewNoteController(context, id: ''));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtitles',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
              return viewNoteController.transcribeState.value.when(
                initial: () => SizedBox.shrink(),
                loading: () => Center(
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: context.theme.colors.primaryTint50,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Please wait subtitles loading...",
                          style: TextStyle(color: context.theme.colors.primaryTint50,),
                        ),
                      ],
                    ),
                  ),
                ),
                error: (exception) => Text(
                  "Failed to load subtitles",
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                data: (data) {
                  viewNoteController.update();
                  audioPlayerViewController.areCuesLoaded.value = true;
                  // if (audioPlayerViewController.isPlaying.value && audioPlayerViewController.areCuesLoaded.value && isRecordingUrl) {
                  if (audioPlayerViewController.areCuesLoaded.value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                          child: Text(
                            softWrap: true,
                            audioPlayerViewController.getCurrentSubtitle(),
                            maxLines: 2,
                            // textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(height: 60,);
                },
              );
            }
          ),
        ],
      ),
    );
  }

}
