// import 'package:audiodoc/models/recording.dart';
// import 'package:flutter/material.dart';
// import 'package:audiodoc/widgets/audio_player_widget.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import 'home_page_controller.dart';
//
// class PlayView extends StatelessWidget {
//   // final HomePageController homePageController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Display recording name at the top
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Playing:',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//
//         IconButton(
//           icon: Icon(Icons.close),
//           onPressed: (){
//             homePageController.selectedRecording.value = false;
//           },
//         ),
//
//         // Audio player controls in the center
//         Expanded(
//           child: AudioPlayerWidget(),
//         ),
//       ],
//     );
//   }
// }
