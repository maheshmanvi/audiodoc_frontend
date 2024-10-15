import 'package:audiodoc/pages/home_page_controller.dart';
import 'package:audiodoc/pages/play_view.dart';
import 'package:audiodoc/pages/record_view.dart';
import 'package:audiodoc/utils/DateFormatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recording_controller.dart';

class HomeView extends StatelessWidget {
  final RecordingController recordingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AudioDoc', style: TextStyle(fontWeight: FontWeight.w500,),),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        toolbarHeight: 48,
      ),

      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.lightBlue[50],
              child: Obx(() {
                return ListView.separated(
                  itemCount: recordingController.recordings.length,
                  itemBuilder: (context, index) {
                    var recording = recordingController.recordings[index];
                    return ListTile(
                      title: Text(recording.recordingName),
                      subtitle: Text(DateFormatter.formatDate(recording.createdDate.toIso8601String())),
                      onTap: () {
                        recordingController.playRecording(recording);
                        // Get.to(() => PlayView(recording: homePageController.selectedRecording.value!!,));
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                );
              }),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.lightGreen[50],
              child: RecordView(),
            ),
          ),
        ],
      ),
    );
  }
}
