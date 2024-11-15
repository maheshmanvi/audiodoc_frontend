class UpdateCuesRequest {
  final String noteId;
  final String cues;

  UpdateCuesRequest({
    required this.noteId,
    required this.cues,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': noteId,
      'cues': cues,
    };
  }
}
