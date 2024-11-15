import 'package:audiodoc/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:intl/intl.dart';

import '../../../commons/exception/app_exception.dart';
import '../../../commons/utils/time_ago_util.dart';
import '../../../domain/entity/cue.dart';

class TranscriptionView extends GetView<ViewNoteController> {
  const TranscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    if(controller.note.recording.cues == null){
      if(controller.transcribeState.value.isLoading != true){
        controller.transcribe();
      }
    }

    return Obx(() {
      return controller.transcribeState.value.when(
        initial: () => const SizedBox.shrink(),
        loading: () => _Loading(),
        error: (exception) => _ErrorView(exception: exception),
        data: (data) => _TranscriptionView(),
      );
    });
  }
}

class _TranscriptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewNoteController>();
    final cues = controller.note.recording.getCues();
    final formattedDate = DateFormat('yMMMd').format(controller.note.createdAt);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: SelectionArea(
          child: Column(
            children: [
              Container(
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
                            controller.note.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // InkWell(
                          //     onTap: () {
                          //       controller.refreshCues();
                          //     },
                          //     child: Icon(
                          //       Icons.refresh,
                          //       color: context.theme.colorScheme.onPrimary,
                          //       size: 18,
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          TimeAgoUtil.formatTimeAgo(controller.note.createdAt),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16.0, left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var cue in cues) _MessageCard(cue: cue, cues: controller.note.recording.getCues()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              _SubtitlesSection(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}


//
// class _MessageCard extends StatelessWidget {
//   final Cue cue;
//
//   const _MessageCard({required this.cue, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     bool isSpeaker1 = cue.text.startsWith('Speaker 1');
//     Color backgroundColor = isSpeaker1
//         ? Colors.blue.shade50
//         : Colors.green.shade50;
//     Color speakerColor = isSpeaker1 ? Colors.blue : Colors.green;
//
//     return Align(
//       alignment: isSpeaker1 ? Alignment.centerLeft : Alignment.centerRight,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               isSpeaker1 ? 'Speaker 1' : 'Speaker 2',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: speakerColor,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               cue.text.replaceFirst(RegExp(r'Speaker \d+:\s*'), ''),
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '${_formatDuration(cue.start)} - ${_formatDuration(cue.end)}',
//               style: Theme.of(context).textTheme.bodySmall,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDuration(Duration duration) {
//     return "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
//   }
// }

class _MessageCard extends StatelessWidget {
  final Cue cue;
  final List<Cue> cues;

  const _MessageCard({required this.cue, required this.cues, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract speaker names dynamically
    final speaker = _extractSpeaker(cue.text);
    final speakerColor = _getSpeakerColor(speaker);
    final backgroundColor = _getBackgroundColor(speaker);

    // Check if there are exactly two speakers in the cues
    bool isTwoSpeakers = _areTwoSpeakers(cues);

    return Align(
      alignment: isTwoSpeakers && speaker == 'Speaker 1'
          ? Alignment.centerLeft
          : isTwoSpeakers && speaker == 'Speaker 2'
          ? Alignment.centerRight
          : Alignment.centerLeft, // If more than 2 speakers, align left for all

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor, // Dynamically set background color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              speaker,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: speakerColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              cue.text.replaceFirst(RegExp(r'Speaker \d+:\s*'), ''),
              // Remove speaker prefix
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${_formatDuration(cue.start)} - ${_formatDuration(cue.end)}',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to extract the speaker name dynamically
  String _extractSpeaker(String text) {
    final speakerRegEx = RegExp(r'Speaker (\d+):\s*');
    final match = speakerRegEx.firstMatch(text);
    if (match != null) {
      return 'Speaker ${match.group(1)}';
    }
    return 'Unknown Speaker';
  }
// Helper method to get speaker color dynamically (for 10 speakers)
  Color _getSpeakerColor(String speaker) {
    switch (speaker) {
      case 'Speaker 1':
        return Colors.blue;
      case 'Speaker 2':
        return Colors.green;
      case 'Speaker 3':
        return Colors.red;
      case 'Speaker 4':
        return Colors.purple;
      case 'Speaker 5':
        return Colors.orange;
      case 'Speaker 6':
        return Colors.cyan;
      case 'Speaker 7':
        return Colors.teal;
      case 'Speaker 8':
        return Colors.brown;
      case 'Speaker 9':
        return Colors.indigo;
      case 'Speaker 10':
        return Colors.amber;
      default:
        return Colors.black; // Default color for any undefined speakers
    }
  }

// Helper method to get dynamic background color based on speaker (for 10 speakers)
  Color _getBackgroundColor(String speaker) {
    switch (speaker) {
      case 'Speaker 1':
        return Colors.blue.shade50; // Light blue background for Speaker 1
      case 'Speaker 2':
        return Colors.green.shade50; // Light green background for Speaker 2
      case 'Speaker 3':
        return Colors.red.shade50; // Light red background for Speaker 3
      case 'Speaker 4':
        return Colors.purple.shade50; // Light purple background for Speaker 4
      case 'Speaker 5':
        return Colors.orange.shade50; // Light orange background for Speaker 5
      case 'Speaker 6':
        return Colors.cyan.shade50; // Light cyan background for Speaker 6
      case 'Speaker 7':
        return Colors.teal.shade50; // Light teal background for Speaker 7
      case 'Speaker 8':
        return Colors.brown.shade50; // Light brown background for Speaker 8
      case 'Speaker 9':
        return Colors.indigo.shade50; // Light indigo background for Speaker 9
      case 'Speaker 10':
        return Colors.amber.shade50; // Light amber background for Speaker 10
      default:
        return Colors.grey.shade200; // Default background for undefined speakers
    }
  }

  // Helper method to format duration (used for showing cue timings)
  String _formatDuration(Duration duration) {
    return "${duration.inMinutes.remainder(60).toString().padLeft(
        2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(
        2, '0')}";
  }

  // Helper method to check if there are exactly two speakers in the cues
  bool _areTwoSpeakers(List<Cue> cues) {
    final speakers = <String>{};
    for (var cue in cues) {
      final speaker = _extractSpeaker(cue.text);
      speakers.add(speaker);
    }
    return speakers.length == 2;
  }

}


class _SubtitlesSection extends StatefulWidget {
  final ViewNoteController controller;

  const _SubtitlesSection({required this.controller, super.key});

  @override
  __SubtitlesSectionState createState() => __SubtitlesSectionState();
}

class __SubtitlesSectionState extends State<_SubtitlesSection> {
  bool _isExpanded = false;
  bool _isEditing = false;
  late String _subtitlesText;
  late TextEditingController _textController;
  late List<Cue> listCue;

  @override
  void initState() {
    super.initState();
    _subtitlesText = widget.controller.note.recording.cues ?? "No Subtitles";
    _textController = TextEditingController(text: _subtitlesText);
    listCue = widget.controller.note.recording.getCues();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    widget.controller.updateCues(_textController.text);
    setState(() {
      _subtitlesText = _textController.text;
      _isEditing = false;
    });
  }

  void _cancelChanges() {
    setState(() {
      _isEditing = false;
      _textController.text = _subtitlesText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: context.theme.colors.primary,
            borderRadius: BorderRadius.vertical(top: const Radius.circular(4), bottom: _isExpanded ? Radius.circular(0) : Radius.circular(4)),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtitles",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                _isExpanded ? InkWell(
                  onTap: (){
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: Icon(Icons.edit, color: context.theme.colors.onPrimary,   size: 16,),
                ) : SizedBox.shrink(),
                const SizedBox(width: 10,),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,  color: context.theme.colors.onPrimary,   size: 24,
                ),
              ],
            ),
          ),
        ),

        if (_isExpanded) ...[
          if (_isEditing)
            Column(
              children: [
                TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Edit subtitles",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(0),
                        bottom: Radius.circular(4.0),
                      ),
                      borderSide: BorderSide(color: context.theme.colors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(0),
                        bottom: Radius.circular(4.0),
                      ),
                      borderSide: BorderSide(color: context.theme.colors.primary),
                    ),
                  ),
                  style: context.theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.save, color: context.theme.colors.primary,),
                      onPressed: _saveChanges,
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: context.theme.colors.primary,),
                      onPressed: _cancelChanges,
                    ),
                  ],
                ),
              ],
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                _subtitlesText,
                style: context.theme.textTheme.bodyMedium,
              ),
            ),
        ],
      ],
    );
  }
}



class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final AppException exception;

  const _ErrorView({required this.exception});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(exception.message),
          const SizedBox(height: 8),
          Text(exception.description),
        ],
      ),
    );
  }
}
