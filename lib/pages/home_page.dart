import 'package:audiodoc/dto/recording_dto.dart';
import 'package:audiodoc/pages/record_view.dart';
import 'package:audiodoc/utils/DateFormatter.dart';
import 'package:audiodoc/widgets/file_type_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/recording_controller.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AudioDoc',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        toolbarHeight: 48,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Sidebar(),
          ),
          Expanded(
            flex: 7,
            child: Main(),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final RecordingController recordingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[50],
      child: Obx(() {
        return ListView.separated(
          itemCount: recordingController.recordings.length,
          itemBuilder: (context, index) {
            var recording = recordingController.recordings[index];
            return _ListTile(recording: recording);
          },
          separatorBuilder: (context, index) => Divider(),
        );
      }),
    );
  }
}

class _ListTile extends GetView<RecordingController> {
  final RecordingDto recording;

  _ListTile({required this.recording});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(recording.recordingName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(DateFormatter.formatDate(recording.createdDate.toIso8601String())),
          if (recording.attachment != null) ...[
            const SizedBox(height: 4.0),
            _AttachmentFile(attachment: recording.attachment!),
          ],
        ],
      ),
      onTap: () {
        controller.playRecording(recording);
      },
    );
  }
}

class _AttachmentFile extends GetView<RecordingController> {
  final Attachment attachment;
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  _AttachmentFile({
    super.key,
    required this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    FileTypeIcon fileTypeIcon = FileTypeIcon.fromExtension(attachment.type.extension);
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isHovered,
        builder: (context, isHovered, child) {
          return InkWell(
            onTap: () {
              controller.openAttachment(context: context, attachment);
            },
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
              elevation: isHovered ? 2 : 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        fileTypeIcon.iconData,
                        color: fileTypeIcon.color,
                        size: 16,
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          attachment.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen[50],
      child: RecordView(),
    );
  }
}
