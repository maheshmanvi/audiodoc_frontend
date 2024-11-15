import 'dart:typed_data';
import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/theme/app_colors.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

class SummaryView extends GetView<ViewNoteController> {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    // if(controller.note.recording.summary == null){
    //   controller.summarize();
    // }

    return Obx(
      () {
        return controller.summarizeState.value.when(
          initial: () => const SizedBox.shrink(),
          // initial: (){
          //   // if(controller.note.recording.summary!.isEmpty){
          //   //   controller.summarize();
          //   // }
          //   return const SizedBox.shrink();
          // },
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
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SelectionArea(
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
              ),
            ),
          ],
        ),
        Positioned(
          right: 8,
          top: 5,
          child: _buildExportButton(context),
        ),
      ],
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.ios_share, size: 18, color: context.theme.colors.primary),
      tooltip: "Export",
      color: Colors.white,
      onSelected: (String value) {
        if (value == 'Text File') {
          _exportContent(context, controller.note.recording.summary ?? "Summary not available", 'txt');
        } else if (value == 'DOCX File') {
          _exportContent(context, controller.note.recording.summary ?? "Summary not available", 'doc');
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Text File',
          child: Text('Export as Text File'),
        ),
        const PopupMenuItem<String>(
          value: 'DOCX File',
          child: Text('Export as DOCX File'),
        ),
      ],
    );
  }

  Future<void> _exportContent(BuildContext context, String content, String fileType) async {
    String formattedContent = _formatTextContent(content);
    Uint8List bytes;

    if (fileType == 'txt') {
      bytes = Uint8List.fromList(formattedContent.codeUnits);
    } else {
      bytes = await _generateStyledDocBytes(content, context);
    }

    if (GetPlatform.isWeb) {
      _downloadWebFile(bytes, "${controller.note.title}.$fileType", fileType == 'txt' ? "text/plain" : "application/msword");
    } else {
      await FileSaver.instance.saveFile(
        name: controller.note.title,
        bytes: bytes,
        ext: fileType,
        mimeType: fileType == 'txt' ? MimeType.text : MimeType.microsoftWord,
      );
    }
  }

  String _formatTextContent(String content) {
    List<String> lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      lines[i] = lines[i]
          .replaceAll(RegExp(r'\*{1,2}|\#{1,6}'), '')
          .replaceAll(RegExp(r'^\s*-\s*'), '- ');
    }
    return lines.join('\n');
  }

  void _downloadWebFile(Uint8List bytes, String fileName, String mimeType) {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<Uint8List> _generateStyledDocBytes(String content, BuildContext context) async {
    StringBuffer htmlContent = StringBuffer();
    htmlContent.write('<html><head><meta charset="UTF-8"></head><body style="font-family: Arial, sans-serif;">');

    final lines = content.split('\n');

    for (var line in lines) {
      if (line.startsWith('# ')) {
        htmlContent.write('<h1 style="font-size: 18px; color: ${context.theme.colors.primary}; font-weight: bold;">${line.replaceFirst('# ', '')}</h1>');
      }
      else if (line.startsWith('## ')) {
        htmlContent.write('<h2 style="font-size: 16px; color: ${context.theme.colors.successShade50}; font-weight: semibold;">${line.replaceFirst('## ', '')}</h2>');
      }
      else if (line.contains('**')) {
        htmlContent.write('<p>${line.replaceAllMapped(
            RegExp(r'\*\*(.*?)\*\*'),
                (match) => '<strong>${match.group(1)}</strong>'
        )}<br></p>');
      }
      else if (line.startsWith('- ')) {
        if (!htmlContent.toString().endsWith('<ul>')) {
          htmlContent.write('<ul>');
        }
        htmlContent.write('<li>${line.replaceFirst('- ', '').replaceAllMapped(
            RegExp(r'\*\*(.*?)\*\*'),
                (match) => '<strong>${match.group(1)}</strong>'
        )}<br></li>');
      }
      else if (line.trim() == '---' || line.trim() == '***') {
        htmlContent.write('<hr style="border: 1px solid ${context.theme.colors.divider};"/>');
      }
      else {
        htmlContent.write('<p style="font-size: 14px; color: ${context.theme.colors.contentSecondary};">${line}</p>');
      }
    }

    if (htmlContent.toString().contains('<ul>')) {
      htmlContent.write('</ul>');
    }
    htmlContent.write('</body></html>');
    return Uint8List.fromList(htmlContent.toString().codeUnits);
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
