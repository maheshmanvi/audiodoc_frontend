import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class SummaryView extends GetView<ViewNoteController> {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return controller.summarizeState.value.when(
          initial: () => const SizedBox.shrink(),
          loading: () => _Loading(),
          error: (exception) => _ErrorView(exception: exception),
          data: (data) => const _SummaryMarkdown(),
        );
      },
    );
  }
}

class _SummaryMarkdown extends GetView<ViewNoteController> {
  const _SummaryMarkdown({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarkdownBody(
                data: controller.note.recording.summary ?? "Summary not available",
                styleSheet: MarkdownStyleSheet(
                  h1: context.theme.textTheme.titleLarge?.copyWith(fontSize: 18, color: context.theme.colors.primary, fontWeight: context.theme.typo.fw.bold),
                  h2: context.theme.textTheme.titleMedium?.copyWith(fontSize: 16, color: context.theme.colors.successShade50, fontWeight: context.theme.typo.fw.semibold),
                  h3: context.theme.textTheme.titleSmall?.copyWith(fontSize: 14, color: context.theme.colors.infoShade50, fontWeight: context.theme.typo.fw.semibold),
                  p: context.theme.textTheme.bodyMedium?.copyWith(fontSize: 14, color: context.theme.colors.contentSecondary),
                  strong: context.theme.textTheme.bodyMedium?.copyWith(fontWeight: context.theme.typo.fw.semibold),
                  blockquote: context.theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  em: context.theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, color: context.theme.colors.primary),
                  horizontalRuleDecoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: context.theme.colors.divider,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Summarizing...'),
        ],
      ),
    );
  }
}

class _ErrorView extends GetView<ViewNoteController> {
  final AppException exception;

  const _ErrorView({
    super.key,
    required this.exception,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: context.theme.colors.error,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(exception.message),
          SizedBox(height: 8),
          Text(exception.description),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              controller.summarize();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
