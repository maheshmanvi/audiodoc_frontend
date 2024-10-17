import 'package:audiodoc/theme/app_breakpoints.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/ui/pages/new_note/recorder_view.dart';
import 'package:audiodoc/ui/widgets/attachment/attach_files_view.dart';
import 'package:audiodoc/ui/widgets/audio_player/audio_player_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewNoteMainView extends GetView<NewNotesController> {
  final double bodyMargin;

  const NewNoteMainView({
    super.key,
    this.bodyMargin = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: bodyMargin),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: bodyMargin),
                    child: RecorderView(),
                  ),
                  SizedBox(height: bodyMargin),
                  Obx(() {
                    if (controller.recordingResult.value == null) {
                      return SizedBox.shrink();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: bodyMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AudioPlayerView(
                            liveFileName: controller.titleEC,
                            url: controller.recordingResult.value!.path,
                          ),
                        ],
                      ),
                    );
                  }),
                  _Form(bodyMargin: bodyMargin),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colors.surface,
              border: Border(
                top: BorderSide(
                  color: context.theme.colors.divider,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Builder(
                builder: (context) {
                  if(context.isDesktopSize) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async => controller.saveRecording(context),
                          child: const Text('Save Note'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            backgroundColor: context.theme.colors.primary,
                            foregroundColor: context.theme.colors.onPrimary,
                          ),
                        ),
                      ],
                    );
                  }
                  else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async => controller.saveRecording(context),
                            child: const Text('Save Note'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              backgroundColor: context.theme.colors.primary,
                              foregroundColor: context.theme.colors.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Form extends GetView<NewNotesController> {
  final double bodyMargin;

  const _Form({
    super.key,
    required this.bodyMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(bodyMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          _TitleField(),
          SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => AttachFilesView(
                  lAttachment: controller.selectedLAttachment.value,
                  onClickFilePicker: () => controller.showFilePicker(context),
                  onClickPreview: () => controller.viewSelectedAttachment(context),
                  onClickRemove: () => controller.removeAttachment(),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _PatientName(),
          SizedBox(height: 24),
          _PatientDob(),
          SizedBox(height: 24),
          _PatientMobile(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PatientName extends GetView<NewNotesController> {
  const _PatientName({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.patientNameEC,
      decoration: InputDecoration(
        labelText: 'Patient Name',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _PatientDob extends GetView<NewNotesController> {
  const _PatientDob({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.openDatePicker(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller.patientDobEC,
          decoration: InputDecoration(
            labelText: 'Patient Date of Birth',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class _PatientMobile extends GetView<NewNotesController> {
  const _PatientMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.patientMobileEC,
      decoration: InputDecoration(
        labelText: 'Patient Mobile',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _TitleField extends GetView<NewNotesController> {
  const _TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.titleEC,
      decoration: InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
    );
  }
}
