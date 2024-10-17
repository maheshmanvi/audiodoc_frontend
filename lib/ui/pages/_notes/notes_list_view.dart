import 'package:audiodoc/commons/utils/time_ago_util.dart';
import 'package:audiodoc/domain/entity/attachment.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/pages/_notes/notes_list_vm.dart';
import 'package:audiodoc/ui/widgets/audio_avatar_view.dart';
import 'package:audiodoc/ui/widgets/file_type_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesListView extends GetView<NotesController> {
  const NotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.noteListState.value.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (exception) => Center(child: Text(exception.message)),
        data: (notesListVm) => NotesListItems(),
      );
    });
  }
}

class NotesListItems extends GetView<NotesController> {
  const NotesListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(height: 1, color: context.theme.colors.divider),
      itemCount: controller.noteListItems.length,
      itemBuilder: (context, index) {
        final note = controller.noteListItems[index];
        return _ListItem(note: note);
      },
    );
  }
}

class _ListItem extends GetView<NotesController> {
  final NoteListItemVm note;

  const _ListItem({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.onNoteTap(context, id: note.id),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colors.surface,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            AudioAvatarView(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: context.theme.typo.fw.medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    TimeAgoUtil.formatTimeAgo(note.createdAt),
                    style: context.theme.textTheme.bodySmall,
                  ),
                  if (note.attachment != null) ...[
                    const SizedBox(height: 4),
                    _AttachFileView(attachment: note.attachment!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _AttachFileView extends GetView<NotesController> {
  final Attachment attachment;
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  _AttachFileView({
    super.key,
    required this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    FileTypeIcon icon = FileTypeIcon.fromExtension(attachment.type.extension);
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isHovered,
        builder: (context, isHovered, child) {
          return InkWell(
            onTap: () {
              controller.openAttachment(context: context, attachment: attachment);
            },
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
              elevation: isHovered ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: context.theme.colors.surface,
                  border: Border.all(color: context.theme.colors.divider),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon.iconData,
                        color: icon.color,
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
