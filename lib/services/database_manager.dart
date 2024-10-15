import 'dart:convert';
import 'package:audiodoc/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import '../dto/recording_dto.dart';
import '../models/recording.dart';

class DatabaseManager {

  // Saving the recording
  Future<bool> saveRecording(String recordingName, String audioData) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/save'),
      );

      // Adding recording metadata
      request.fields['recordingName'] = recordingName;
      request.fields['recordingSize'] = '10';
      request.fields['recordingData'] = audioData;

      request.files.add(http.MultipartFile.fromBytes('file', base64Decode(audioData), filename: 'recording.wav'));

      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print("Error saving recording: $e");
      return false;
    }
  }

  // Fetch all recordings
  Future<List<RecordingDto>> fetchAllRecordings() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/recordings'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => RecordingDto.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch recordings.");
      }
    } catch (e) {
      print("Error fetching recordings: $e");
      return [];
    }
  }

  // Fetch a recording by its ID
  Future<Recording?> fetchRecordingById(String id) async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/recordings/$id')); // Replace with your actual backend URL
      if (response.statusCode == 200) {
        return Recording.fromJson(json.decode(response.body)); // Decode JSON and create Recording object
      } else {
        throw Exception("Failed to fetch recording with ID: $id.");
      }
    } catch (e) {
      print("Error fetching recording: $e");
      return null;
    }
  }
}
