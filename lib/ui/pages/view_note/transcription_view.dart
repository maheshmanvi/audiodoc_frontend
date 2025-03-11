import 'package:audiodoc/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:intl/intl.dart';

import '../../../commons/exception/app_exception.dart';
import '../../../commons/utils/time_ago_util.dart';
import '../../../domain/entity/cue.dart';
import '../../widgets/snackbar/app_snackbar.dart';

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

/*class _TranscriptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewNoteController>();
    controller.initializeCues();
    final formattedDate = DateFormat('yMMMd').format(controller.note.createdAt);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
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
                  _Header(controller: controller, onRefresh: () {controller.refreshCues();},),
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
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: controller.cues.map((cue) {
                        return Obx(() {
                          if (controller.editingCueId.value == cue.sequence) {
                            return _EditingContainer(
                              cue: cue,
                              controller: controller,
                              onSave: (updatedText) {
                                controller.updateCue(cue.sequence, updatedText);
                              },
                              onCancel: () {
                                controller.editingCueId.value = null;
                              },
                            );
                          } else {
                            return _MessageCard(
                              cue: cue,
                              controller: controller,
                              // onEdit: () => controller.editingCueId.value = cue.sequence,
                              // onEdit: () => controller.editCue(cue.sequence),
                              onEdit: () {
                                controller.editCue(cue.sequence);
                              },
                              onRemove: () => controller.removeCue(cue.sequence),
                            );
                          }
                        });
                      }).toList(),
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
    );
  }
}*/

class _TranscriptionView extends StatefulWidget {
  @override
  _TranscriptionViewState createState() => _TranscriptionViewState();
}

class _TranscriptionViewState extends State<_TranscriptionView> {
  late ViewNoteController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ViewNoteController>();
    controller.initializeCues();
  }

  void removeCue(int sequence) {
    // try {
    //   // Find the cue to remove by sequence number
    //   // final cueToRemove = controller.cues.firstWhere((cue) => cue.sequence == sequence, orElse: () => null);
    //
    //   if (cueToRemove != null) {
    //     // Remove the cue from the list
    //     controller.cues.remove(cueToRemove);
    //
    //     // Reassign sequence numbers to remaining cues
    //     for (int i = 0; i < controller.cues.length; i++) {
    //       controller.cues[i].sequence = i + 1; // Reassign sequence to be in order
    //     }
    //
    //     // Update the cues string
    //     final updatedCuesString = _convertCuesToString(controller.cues);
    //
    //     // Update the database with the new cues string
    //     controller.updateCues(updatedCuesString).then((_) {
    //       controller.refreshCues(); // Refresh the cues to update UI
    //     }).catchError((error) {
    //       AppSnackBar.showErrorToast(Get.context!, message: 'Failed to delete cue');
    //     });
    //   } else {
    //     print("Cue not found for sequence $sequence");
    //   }
    // } catch (e) {
    //   // Handle errors if any (cue not found, etc.)
    //   print("Error deleting cue: $e");
    // }
  }


  String _convertCuesToString(List<Cue> cues) {
    final cueStrings = cues.map((cue) {
      final start = _durationToString(cue.start);
      final end = _durationToString(cue.end);
      return '${cue.sequence}\n${_convertTimeFormat(start)} --> ${_convertTimeFormat(end)}\n${cue.text}\n';
    }).join('\n');

    return cueStrings;
  }


  // Converts a Duration to a string in "HH:MM:SS" format
  String _durationToString(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds % 1000).toString().padLeft(3, '0');

    return '$hours:$minutes:$seconds.$milliseconds';
  }

  // Converts a string in "HH:MM:SS" format to Duration
  Duration _stringToDuration(String time) {
    final parts = time.split(':');
    if (parts.length == 3) {
      final timeParts = parts[2].split('.');
      if (timeParts.length == 2) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(timeParts[0]);
        final milliseconds = int.parse(timeParts[1]);

        return Duration(hours: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds);
      } else {
        return Duration.zero; // Invalid time format (missing milliseconds)
      }
    }
    return Duration.zero; // Default to 0 duration if invalid
  }


  // Convert dot (.) to comma (,) for time format used in the database
  String _convertTimeFormat(String time) {
    return time.replaceAll('.', ',');
  }


  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yMMMd').format(controller.note.createdAt);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
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
                  _Header(controller: controller, onRefresh: () { controller.refreshCues(); },),
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
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: controller.cues.map((cue) {
                        return Obx(() {
                          if (controller.editingCueId.value == cue.sequence) {
                            return _EditingContainer(
                              cue: cue,
                              controller: controller,
                              onSave: (updatedText) {
                                controller.updateCue(cue.sequence, updatedText);
                              },
                              onCancel: () {
                                controller.editingCueId.value = null;
                              },
                            );
                          } else {
                            return _MessageCard(
                              cue: cue,
                              controller: controller,
                              onEdit: () {
                                controller.editCue(cue.sequence);
                              },
                              onRemove: () => removeCue(cue.sequence),
                            );
                          }
                        });
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 20),
            // _SubtitlesSection(controller: controller),
          ],
        ),
      ),
    );
  }
}


class _Header extends StatefulWidget {
  final ViewNoteController controller;
  final VoidCallback onRefresh;

  const _Header({required this.controller, required this.onRefresh, Key? key})
      : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.controller.note.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              widget.onRefresh();
            },
            child: Icon(
              Icons.refresh,
              color: context.theme.colorScheme.onPrimary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}


class _MessageCard extends StatefulWidget {
  final Cue cue;
  final ViewNoteController controller;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _MessageCard({
    required this.cue,
    required this.controller,
    required this.onEdit,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<_MessageCard> {
  bool isHovered = false;
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final cue = widget.cue;

    return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) {
            setState(() {
              isHovered = false;
              isMenuOpen = false;
            });
          },
          child: Align(
            alignment: controller.numberOfSpeakers.value == 2
                ? (cue.speakerNumber == 1 ? Alignment.centerLeft : Alignment.centerRight)
                : Alignment.centerLeft,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.controller.getBackgroundColor(cue.speakerName),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 150,
                    maxWidth: 500,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cue.speakerName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.controller.getSpeakerColor(cue.speakerName),
                          // color: speakerColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cue.text
                            .replaceFirst(RegExp(r'^.*?:\s*'), '')
                            .trim(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.formatDurationWithoutMilliSeconds(cue.start)} - ${controller.formatDurationWithoutMilliSeconds(cue.end)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                // More actions button (Edit, Remove)
                if(isHovered && !isMenuOpen)
                  Positioned(
                    top: 14,
                    right: 4,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18),
                      onSelected: (value) {
                        print("SELECTED");
                        if (value == 'edit') {
                          print("Editing cue: ${cue.sequence}");
                          controller.editCue(cue.sequence);
                        } else if (value == 'remove') {
                          widget.onRemove();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit, size: 16),
                              const SizedBox(width: 4),
                              Text("Edit", style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          onTap: (){
                            print("Editing cue: ${cue.sequence}");
                            controller.editCue(cue.sequence);
                          },
                        ),
                        PopupMenuItem(
                          value: 'remove',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, size: 16),
                              const SizedBox(width: 4),
                              Text("Remove", style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          onTap: (){
                            final index = controller.cues.indexOf(cue);
                            print("Removing cue of sequence ${cue.sequence} at index: $index");
                            controller.removeCue(index);
                          },
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        );

  }
}


class _EditingContainer extends StatefulWidget {
  final Cue cue;
  final ViewNoteController controller;
  final Function(Cue updatedText) onSave;
  final VoidCallback onCancel;

  const _EditingContainer({
    required this.cue,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    Key? key,
  }) : super(key: key);

  @override
  _EditingContainerState createState() => _EditingContainerState();
}

class _EditingContainerState extends State<_EditingContainer> {
  late TextEditingController _textController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.cue.text);
    _startTimeController = TextEditingController(text: _durationToString(widget.cue.start));
    _endTimeController = TextEditingController(text: _durationToString(widget.cue.end));

  }

  @override
  void dispose() {
    _textController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  // Converts a Duration to a string in "HH:MM:SS" format
  String _durationToString(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds % 1000).toString().padLeft(3, '0');

    return '$hours:$minutes:$seconds.$milliseconds';
  }

  // Converts a string in "HH:MM:SS" format to Duration
  Duration _stringToDuration(String time) {
    final parts = time.split(':');
    if (parts.length == 3) {
      final timeParts = parts[2].split('.');
      if (timeParts.length == 2) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(timeParts[0]);
        final milliseconds = int.parse(timeParts[1]);

        return Duration(hours: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds);
      } else {
        return Duration.zero; // Invalid time format (missing milliseconds)
      }
    }
    return Duration.zero; // Default to 0 duration if invalid
  }

  // Time picker to select a time and convert to Duration
  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime(1970, 1, 1,
          int.parse(controller.text.split(':')[0]),
          int.parse(controller.text.split(':')[1]))
      ),
    );
    if (selectedTime != null) {
      final formattedTime = _durationToString(
          Duration(hours: selectedTime.hour, minutes: selectedTime.minute)
      );
      controller.text = formattedTime;
    }
  }

  // Helper method to convert cue list to string format
  String _convertCuesToString(List<Cue> cues) {
    final cueStrings = cues.map((cue) {
      final start = _durationToString(cue.start);
      final end = _durationToString(cue.end);
      return '${cue.sequence}\n${_convertTimeFormat(start)} --> ${_convertTimeFormat(end)}\n${cue.text}\n';
    }).join('\n');

    return cueStrings;
  }

  // Convert dot (.) to comma (,) for time format used in the database
  String _convertTimeFormat(String time) {
    return time.replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _textController,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Edit Cue Text',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          // Start Time Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _startTimeController,
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _endTimeController,
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ],
          ),

         /* const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _endTimeController,
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () => _selectTime(_endTimeController),
              ),
            ],
          ),*/

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.cue.text = _textController.text;

                  // Convert the start and end times from the text fields back to Duration
                  widget.cue.start = _stringToDuration(_startTimeController.text);
                  widget.cue.end = _stringToDuration(_endTimeController.text);

                  widget.onSave( widget.cue); // Notify the parent to save changes

                  // Convert updated cues to string
                  final updatedCuesString = _convertCuesToString(widget.controller.cues);

                  // Call the updateCues method to save in the database
                  widget.controller.updateCues(updatedCuesString).then((_) {
                    // Successfully updated in database, update UI
                    widget.controller.refreshCues();
                  }).catchError((error) {
                    // Handle error (show error message)
                    AppSnackBar.showErrorToast(context, message: 'Failed to update cues');
                  });

                  widget.onCancel(); // Exit edit mode
                },
                child: Text('Save'),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                onPressed: widget.onCancel,
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
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
