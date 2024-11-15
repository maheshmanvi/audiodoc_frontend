import 'package:audiodoc/commons/utils/map_utils.dart';
import 'package:audiodoc/domain/entity/cue.dart';

class Recording {
  final String name;
  final String relativeUrl;
  final String? transcription;
  final String? summary;
  late String? cues;

  Recording({
    required this.name,
    required this.relativeUrl,
    this.transcription,
    this.summary,
    this.cues,
  });

  static Recording fromMap(Map<String, dynamic> map) {
    String name = map.getString("name");
    String relativeUrl = map.getString("relativeUrl");
    String? transcription = map.getStringNullable("transcription");
    String? summary = map.getStringNullable("summary");
    String? cues = map.getStringNullable("cues");
    return Recording(
      name: name,
      relativeUrl: relativeUrl,
      transcription: transcription,
      summary: summary,
      cues: cues
    );
  }

  List<Cue> getCues() {
     if(cues == null) return [];
     List<String> lines = cues!.split('\n\n');
     List<Cue> cuesList = [];
     for (var line in lines) {
       var parts = line.split('\n');
       if (parts.length < 3) continue;

       int seqNumber = int.parse(parts[0]);
       var times = parts[1].split(' --> ');
       var start = _parseDuration(times[0]);
       var end = _parseDuration(times[1]);
       String text = parts.sublist(2).join('\n');
       cuesList.add(Cue(seqNumber: seqNumber, start: start, end: end, text: text));
     }
     return cuesList;
  }


  Duration _parseDuration(String time) {
    final parts = time.split(',');
    var seconds = Duration(
      hours: int.parse(parts[0].split(':')[0]),
      minutes: int.parse(parts[0].split(':')[1]),
      seconds: int.parse(parts[0].split(':')[2]),
      milliseconds: int.parse(parts[1]),
    );
    return seconds;
  }




}
