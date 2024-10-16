import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

class DataUriConverter {
  DataUriConverter._();

  static const String mimeTypeAudioWav = 'audio/wav';
  static const String mimeTypeAudioOpus = 'audio/opus';

  static String toDataUri(Uint8List bytes, {required String mimeType}) {
    String base64String = base64Encode(bytes);
    return "data:$mimeType;base64,$base64String";
  }


  static Future<String> toHTMLDataUri(Uint8List bytes, {required String mimeType}) async {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrl(blob);
    return url;
  }



}
