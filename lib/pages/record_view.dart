import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/recording_controller.dart';
import '../widgets/audio_player_widget.dart';


class RecordView extends StatelessWidget {
  final RecordingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (controller.isRecording.value) {
                        await controller.stopRecording();
                      } else {
                        await controller.startRecording();
                      }
                    },
                    icon: Icon(
                      controller.isRecording.value ? Icons.stop : Icons.mic,
                      size: 48,
                      color: controller.isRecording.value ? Colors.red : Colors
                          .blue,
                    ),
                  ),

                  // Pause/Resume Button
                  IconButton(
                    onPressed: () async {
                      if(controller.isRecording.value){
                        if (controller.isPaused.value) {
                          await controller.resumeRecording();
                        } else {
                          await controller.pauseRecording();
                        }
                      }
                    },

                    icon: Icon(
                      controller.isPaused.value ? Icons.play_arrow : Icons.pause,
                      size: 48,
                      color: controller.isPaused.value ? Colors.green : Colors
                          .orange,
                    ),
                  ),
                ],
              );
            }),

            Obx(() {
              return Text(
                controller.isRecording.value
                    ? (controller.isPaused.value ? "Paused..." : "Recording...")
                    : "Press mic to start recording",
                style: TextStyle(fontSize: 18),
              );
            }),

            Divider(height: 60, color: Colors.grey[300],),

            Obx(() => controller.audioUrl.value.isNotEmpty || controller.audioSelectedForPlaying.value
                  ? AudioPlayerWidget()
                  : Center(
                child: Container(
                  height: 178,
                  alignment: Alignment.center,
                  child: Text(
                    'No audio recorded yet',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16,),

            Obx(() {
              if (controller.audioUrl.value.isNotEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1, // Border width
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.fileNameController,
                          onChanged: (newValue) {
                            controller.fileName.value = newValue;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            hintText: 'Enter file name',
                            fillColor: Colors.white.withOpacity(0.5),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // No border
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),

                      // Save Button
                      Obx(() {
                        String buttonText;
                        Color buttonColor;
                        bool isButtonDisabled = false;

                        if (controller.isSaving.value) {
                          buttonText = 'Saving...';
                          buttonColor = Colors.grey;
                          isButtonDisabled = true;
                        } else if (controller.isSaved.value) {
                          buttonText = 'Saved successfully!';
                          buttonColor = Colors.green.withOpacity(0.6);
                          isButtonDisabled = true;
                        } else {
                          buttonText = 'Save';
                          buttonColor = Colors.blue;
                        }

                        return TextButton(
                          onPressed: isButtonDisabled ? null : () async {
                            await controller.saveRecording();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: buttonColor,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            minimumSize: Size(48, 48),
                          ),
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
