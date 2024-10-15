import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../controllers/recording_controller.dart';

class AudioPlayerWidget extends StatelessWidget {
  final RecordingController recordingController = Get.find<RecordingController>();

  void showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    required double value,
    required Stream<double> stream,
    required Function(double) onChanged,
    required String Function(dynamic value) valueLabel,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: StreamBuilder<double>(
            stream: stream,
            builder: (context, snapshot) {
              double currentValue = snapshot.data ?? value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(valueLabel(currentValue)),
                  Slider(
                    divisions: divisions,
                    min: min,
                    max: max,
                    value: currentValue,
                    onChanged: onChanged,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    recordingController.loadAudio();
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    recordingController.fileName.value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: (){
                      recordingController.recordedBlob = null;
                      recordingController.audioUrl.value = '';
                    }, // Close widget action
                  ),
                ),
              ],
            ),
          ),


          SizedBox(height: 16), // Spacing

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<PlayerState>(
                stream: recordingController.player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (playing != true) {
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 48.0,
                      onPressed: recordingController.player.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 48.0,
                      onPressed: recordingController.player.pause,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.replay),
                      iconSize: 48.0,
                      onPressed: () async {
                        await recordingController.player.seek(Duration.zero);
                        await recordingController.player.stop();
                        await recordingController.player.play();
                      },
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.stop),
                iconSize: 48.0,
                onPressed: recordingController.stopAudio,
              ),

              Row(
                children: [
                  StreamBuilder<double>(
                    stream: recordingController.player.speedStream,
                    builder: (context, snapshot) => IconButton(
                      icon: Text(
                        "${snapshot.data?.toStringAsFixed(1)}x",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                      ),
                      onPressed: () {
                        showSliderDialog(
                          context: context,
                          title: "Adjust speed",
                          divisions: 10,
                          min: 0.5,
                          max: 1.5,
                          value: recordingController.player.speed,
                          stream: recordingController.player.speedStream,
                          onChanged: recordingController.player.setSpeed,
                          valueLabel: (value) {
                            if (value < 1.0) {
                              return "${value.toStringAsFixed(1)}x (slower)";
                            } else if (value > 1.0) {
                              return "${value.toStringAsFixed(1)}x (faster)";
                            } else {
                              return "1.0x (normal)";
                            }
                          },
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.grey[500],),
                    onPressed: () {
                      showSliderDialog(
                        context: context,
                        title: "Adjust volume",
                        divisions: 10,
                        min: 0.0,
                        max: 10.0,
                        value: recordingController.player.volume * 10,
                        stream: recordingController.player.volumeStream
                            .map((volume) => volume * 10),
                        onChanged: (value) {
                          recordingController.player.setVolume(value / 10);
                        },
                        valueLabel: (value) => value.toInt().toString(),
                      );
                    },
                  ),

                  IconButton(
                    onPressed: (){
                      recordingController.downloadRecording();
                    },
                    icon: Icon(Icons.download_sharp, color: Colors.grey[500],),
                  ),
                ],
              ),
            ],
          ),

          Obx(() {
            if (recordingController.errorMessage.isNotEmpty) {
              return Text(
                recordingController.errorMessage.value,
                style: TextStyle(color: Colors.red),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
