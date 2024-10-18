import 'package:audiodoc/commons/utils/time_ago_util.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/view_note/summary_view.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:audiodoc/ui/utils/note_validation_util.dart';
import 'package:audiodoc/ui/widgets/attachment/attachment_view.dart';
import 'package:audiodoc/ui/widgets/audio_player/audio_player_view.dart';
import 'package:audiodoc/ui/widgets/file_type_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewNoteMainView extends GetView<ViewNoteController> {
  const ViewNoteMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.initLoadState.value.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (exception) => Center(child: Text(exception.message)),
        data: (data) => const _NoteDetails(),
      );
    });
  }
}

class _NoteDetails extends GetView<ViewNoteController> {
  const _NoteDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TabBar(),
        Expanded(child: _TabBarView()),
      ],
    );
  }
}

class _TabBar extends GetView<ViewNoteController> {
  const _TabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller.tabController,
      tabs: const [
        Tab(text: 'Note Details'),
        Tab(text: 'Summary'),
      ],
    );
  }
}

class _TabBarView extends GetView<ViewNoteController> {
  const _TabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller.tabController,
      children: [
        _NoteDetailsView(),
        SummaryView(),
      ],
    );
  }
}

class _NoteDetailsView extends GetView<ViewNoteController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.colors.background,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AudioPlayerView(
                liveFileName: controller.titleEC,
                url: controller.getNoteFullURL(controller.note),
                onRenameComplete: () => controller.updateNotes(),
              ),
              const SizedBox(height: 16),
              _AttachmentView(),
              const SizedBox(height: 16),
              const PatientDetailsView(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentView extends GetView<ViewNoteController> {
  const _AttachmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.note.attachment != null) {
        FileTypeIcon fileTypeIcon = FileTypeIcon.fromExtension(controller.note.attachment!.type.extension);
        return AttachmentView(
          name: controller.note.attachment!.name,
          iconData: fileTypeIcon.iconData,
          iconColor: fileTypeIcon.color,
          iconSize: 24,
          size: controller.note.attachment!.size,
          extension: controller.note.attachment!.type.extension,
          onClickDownload: () => controller.onClickDownloadAttachment(context, controller.note.attachment),
          onClickPreview: () => controller.onClickPreviewAttachment(context, controller.note.attachment),
          onClickRemove: () => controller.onClickRemoveAttachment(context),
        );
      } else {
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
                  Text('Attach File'),
                ],
              ),
            ),
          ],
        );
      }
    });
  }
}

class PatientDetailsView extends GetView<ViewNoteController> {
  const PatientDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colors.surface,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 2,
      child: Column(
        children: [
          // Header for Patient Details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.theme.colors.primary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patient Details',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() {
                  // Toggle between Edit and Done icon based on isEditing state
                  return InkWell(
                    onTap: () => controller.toggleEdit(),
                    child: Icon(
                      controller.isEditing.value ? Icons.done : Icons.edit,
                      color: context.theme.colors.onPrimary,
                      size: 18,
                    ),
                  );
                }),
              ],
            ),
          ),
          Obx(() {
            return controller.isEditing.value ? _PatientDetailsForm() : _PatientDetailsTable();
          }),
        ],
      ),
    );
  }
}

class _PatientDetailsTable extends GetView<ViewNoteController> {
  const _PatientDetailsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FractionColumnWidth(0.3),
        1: FractionColumnWidth(0.7),
      },
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      children: [
        _buildRow('Name:', controller.note.patientName ?? "-"),
        _buildRow('DOB:', controller.note.patientDob != null ? TimeAgoUtil.defaultDateFormat(controller.note.patientDob!) : "-"),
        _buildRow('Mobile:', controller.note.patientMobile ?? "-"),
      ],
    );
  }

  TableRow _buildRow(String label, String value) {
    return TableRow(
      children: [
        _buildLabelCell(label),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildLabelCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _PatientDetailsForm extends GetView<ViewNoteController> {
  const _PatientDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          TextFormField(
            controller: controller.patientNameEC,
            inputFormatters: NoteValidationUtil.nameInputFormatter,
            decoration: InputDecoration(
              labelText: 'Patient Name',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => controller.openDatePicker(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller.patientDobEC,
                decoration: InputDecoration(
                  labelText: 'Patient Date of Birth',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller.patientMobileEC,
            inputFormatters: NoteValidationUtil.mobileInputFormatter,
            validator: (value) => NoteValidationUtil.patientMobileNumberValidator(value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: 'Patient Mobile',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => controller.updateNotes(),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
