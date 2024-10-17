class UpdateNoteRequest {
  final String id;
  final String title;
  final String? patientName;
  final String? patientMobile;
  final DateTime? patientDob;

  UpdateNoteRequest({
    required this.id,
    required this.title,
    this.patientName,
    this.patientMobile,
    this.patientDob,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'patientName': patientName,
      'patientMobile': patientMobile,
      'patientDob': patientDob,
    };
  }
}
