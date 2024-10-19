import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportFormApi {
  Future<void> submitReport({
    required String name,
    required String reasonForTest,
    required DateTime date,
    required String address,
    File? image,
    File? processedImage,
  }) async {
    // API URL for form submission
    final String apiUrl = 'http://172.24.144.1:8000/report_form_create';

    try {
      // Create a Multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields['name'] = name;
      request.fields['reason_for_test'] = reasonForTest;
      request.fields['date'] =
          date.toIso8601String().split('T').first; // YYYY-MM-DD format
      request.fields['address'] = address;

      // Add optional image files if they are not null
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
      }
      if (processedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'processed_image', processedImage.path));
      }

      // Set any headers if necessary (e.g., for authentication)
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Accept'] = 'application/json';

      // Send the request and await response
      http.StreamedResponse response = await request.send();

      // Check the status of the response
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse the response
        String responseString = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseString);
        print("Report submitted successfully: $jsonResponse");
      } else {
        // Handle errors
        final errorResponse = await response.stream.bytesToString();
        print(
            "Failed to submit report: ${response.statusCode}, $errorResponse");
      }
    } catch (e) {
      // Handle exceptions
      print("Error submitting report: $e");
    }
  }
}
