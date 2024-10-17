import 'dart:typed_data';

import 'package:audiodoc/domain/entity/attachment_type.dart';
import 'package:audiodoc/ui/utils/url_open_util.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AttachmentFileRequest {
  final AttachmentType type;
  final String name;
  final Uint8List? bytes;
  final String? networkUrl;

  AttachmentFileRequest({
    required this.name,
    this.bytes,
    this.networkUrl,
    required this.type,
  });
}

class AttachmentPreviewDialogView extends StatefulWidget {
  final AttachmentFileRequest file;

  const AttachmentPreviewDialogView({
    super.key,
    required this.file,
  });

  @override
  State<AttachmentPreviewDialogView> createState() => _AttachmentPreviewDialogViewState();

  static void showAttachmentPreviewDialog({required BuildContext context, required AttachmentFileRequest file}) {
    showDialog(
      context: context,
      builder: (context) => AttachmentPreviewDialogView(file: file),
      barrierColor: Colors.black.withOpacity(0.1),
    );
  }
}

class _AttachmentPreviewDialogViewState extends State<AttachmentPreviewDialogView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.file.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (widget.file.networkUrl != null) ...[
                    InkWell(
                      onTap: () {
                        UrlOpenUtil.openURL(context, widget.file.networkUrl!);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Open in new tab",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue),
                            ),
                            WidgetSpan(child: SizedBox(width: 4)),
                            WidgetSpan(
                              child: Icon(Icons.open_in_new_rounded, size: 14, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              elevation: 4,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
              ),
            ),
            body: Builder(
              builder: (ctx) {
                if (widget.file.type.isImage) {
                  return _ImagePreview(file: widget.file);
                } else if (widget.file.type.isPDF) {
                  return _PdfPreview(file: widget.file);
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final AttachmentFileRequest file;

  const _ImagePreview({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Builder(builder: (ctx) {
        if (file.bytes != null) {
          return Image.memory(file.bytes!);
        } else if (file.networkUrl != null) {
          return Image.network(file.networkUrl!);
        } else {
          return SizedBox();
        }
      }),
    );
  }
}

class _PdfPreview extends StatefulWidget {
  final AttachmentFileRequest file;

  const _PdfPreview({
    super.key,
    required this.file,
  });

  @override
  State<_PdfPreview> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<_PdfPreview> {
  bool isFailed = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget _buildLink() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 8.0),
          Text(
            'Failed to load PDF',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Please click the link below to open the PDF in a new tab',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8.0),
          if (widget.file.networkUrl != null) ...[
            InkWell(
              onTap: () {
                UrlOpenUtil.openURL(context, widget.file.networkUrl!);
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Open in new tab",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue),
                    ),
                    WidgetSpan(child: SizedBox(width: 4)),
                    WidgetSpan(
                      child: Icon(Icons.open_in_new_rounded, size: 14, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (isFailed) {
      return _buildLink();
    }
    if (widget.file.bytes != null) {
      return SfPdfViewer.memory(

        widget.file.bytes!,
        onDocumentLoaded: (details) {
          print('Loading Completed From Memory');
        },
        onDocumentLoadFailed: (details) {
          print('Loading Failed From Memory ${details.error}');
          print('Loading Failed From Memory ${details.description}');
          setState(() {
            isFailed = true;
          });
        },
      );
    } else if (widget.file.networkUrl != null) {
      return SfPdfViewer.network(
        widget.file.networkUrl!,
        onDocumentLoaded: (details) {
          print('Loading Completed From Network');
        },
        onDocumentLoadFailed: (details) {
          print('Loading Failed From Network');
          setState(() {
            isFailed = true;
          });
        },
      );
    } else {
      return SizedBox();
    }
  }
}
