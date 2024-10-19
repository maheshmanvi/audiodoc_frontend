import 'package:audiodoc/resources/app_strings.dart';
import 'package:audiodoc/theme/app_breakpoints.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/ui/pages/new_note/recorder_view.dart';
import 'package:audiodoc/ui/utils/note_validation_util.dart';
import 'package:audiodoc/ui/widgets/attachment/attachment_view.dart';
import 'package:audiodoc/ui/widgets/audio_player/audio_player_view.dart';
import 'package:audiodoc/ui/widgets/file_type_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewNoteMainView extends GetView<NewNotesController> {
  final double bodyMargin;

  const NewNoteMainView({
    super.key,
    this.bodyMargin = 12,
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
              padding: EdgeInsets.all(bodyMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RecorderView(),
                  SizedBox(height: bodyMargin),
                  Obx(() {
                    if (controller.recordingResult.value == null) {
                      return SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AudioPlayerView(
                          liveFileName: controller.titleEC,
                          url: controller.recordingResult.value!.path,
                          onRenameComplete: () => {},
                        ),
                      ],
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
              child: Builder(builder: (ctx) {
                if (context.isDesktopSize) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _CancelButton(onPressed: () => controller.cancelRecording(context)),
                      const SizedBox(width: 16),
                      _SaveButton(),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _CancelButton(onPressed: () => controller.cancelRecording(context)),
                      const SizedBox(width: 16),
                      Expanded(child: _SaveButton()),
                    ],
                  );
                }
              }),
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
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          _TitleField(),
          SizedBox(height: 24),
          Obx(
            () {
              if (controller.selectedLAttachment.value == null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () => controller.showFilePicker(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_file,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Text(AppStrings.btnAttachFile),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                FileTypeIcon fileTypeIcon = FileTypeIcon.fromExtension(controller.selectedLAttachment.value!.type.extension);
                return AttachmentView(
                  name: controller.selectedLAttachment.value!.fileName,
                  iconData: fileTypeIcon.iconData,
                  iconColor: fileTypeIcon.color,
                  iconSize: 24,
                  size: controller.selectedLAttachment.value!.size,
                  extension: controller.selectedLAttachment.value!.type.extension,
                  onClickRemove: () => controller.removeAttachment(),
                  onClickPreview: controller.selectedLAttachment.value!.type.inAppPreview ? () => controller.previewAttachment(context) : null,
                );
              }
            },
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
      inputFormatters: NoteValidationUtil.nameInputFormatter,
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
      inputFormatters: NoteValidationUtil.mobileInputFormatter,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: NoteValidationUtil.patientMobileNumberValidator,
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
      inputFormatters: NoteValidationUtil.titleInputFormatter,
      validator: NoteValidationUtil.titleValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _SaveButton extends GetView<NewNotesController> {
  const _SaveButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ElevatedButton(
          onPressed: this.enabled ? () => controller.saveRecording(context) : null,
          // child: Text(AppStrings.btnSaveNote),
          child: Text((controller.saveState.value.isLoading) ? AppStrings.btnSavingNote : AppStrings.btnSaveNote),
          style: context.theme.elevatedButtonTheme.style?.copyWith(
            minimumSize: WidgetStatePropertyAll(Size(120, 48)),
          ),
        );
      },
    );
  }

  bool get enabled {
    if (controller.saveState.value.isLoading) {
      return false;
    }
    if (controller.recordingResult.value == null) {
      return false;
    }
    return true;
  }


  bool get isLoading {
    return controller.saveState.value.isLoading;
  }



}

class _CancelButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _CancelButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(AppStrings.btnCancel),
      style: context.theme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStatePropertyAll(context.theme.colors.primaryTint90),
        foregroundColor: WidgetStatePropertyAll(context.theme.colors.contentPrimary),
        minimumSize: WidgetStatePropertyAll(Size(120, 48)),
      ),
    );
  }
}
