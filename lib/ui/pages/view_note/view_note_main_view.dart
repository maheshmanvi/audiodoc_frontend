import 'package:audiodoc/commons/utils/time_ago_util.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:audiodoc/ui/widgets/audio_player/audio_player_view.dart';
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
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AudioPlayerView(liveFileName: controller.titleEC, url: controller.getNoteFullURL(controller.note)),
            const SizedBox(height: 16),
            if (controller.note.hasPatientInfo()) ...[
              const PatientDetailsView(),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}


class PatientDetailsView extends GetView<ViewNoteController> {
  const PatientDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 2,
      child: Column(
        children: [
          // Header for Patient Details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patient Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Table for Patient Details
          Table(
            columnWidths: const {
              0: FractionColumnWidth(0.3),
              1: FractionColumnWidth(0.7),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            children: [
              // Row for Patient Name
              if (controller.note.patientName != null)
                _buildRow('Name:', controller.note.patientName!),
              // Row for Patient DOB
              if (controller.note.patientDob != null)
                _buildRow('DOB:', TimeAgoUtil.defaultDateFormat(controller.note.patientDob!)),
              // Row for Patient Mobile
              if (controller.note.patientMobile != null)
                _buildRow('Mobile:', controller.note.patientMobile!),
            ],
          ),
        ],
      ),
    );
  }

  // Method to build a row with a label and value
  TableRow _buildRow(String label, String value) {
    return TableRow(
      children: [
        _buildLabelCell(label),
        _buildCell(value),
      ],
    );
  }

  // Method to build a cell with the value
  Widget _buildCell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Text(value),
    );
  }

  // Method to build a cell with the label
  Widget _buildLabelCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
