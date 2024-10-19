import 'dart:convert';
import 'package:http/http.dart' as http;

// using the report form api

class Resultsapi {
  final int id;
  final String reason_for_test;
  final String date;
  final String address;
  final String image;
  final String avg_color;
  final String processed_image;
  final String result;

  Resultsapi({
    required this.id,
    required this.reason_for_test,
    required this.date,
    required this.address,
    required this.image,
    required this.avg_color,
    required this.processed_image,
    required this.result,
  });

  factory Resultsapi.fromJson(Map<String, dynamic> json) {
    return Resultsapi(
      id: json['id'] ?? 0,
      reason_for_test: json['reason_for_test'] ?? '',
      date: json['date'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      avg_color: json['avg_color'] ?? '',
      processed_image: json['processed_image'] ?? '',
      result: json['result'] ?? '',
    );
  }
}

class ResultsApi {
  static const String baseUrl = 'http://192.168.124.222:8000';

  Future<List<Resultsapi>> fetchResults() async {
    final response = await http.get(Uri.parse('$baseUrl/report_form_list'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Resultsapi> results =
          body.map((dynamic item) => Resultsapi.fromJson(item)).toList();
      return results;
    } else {
      throw Exception('Failed to load results');
    }
  }

  Future<Resultsapi> fetchLatestTest() async {
    final results = await fetchResults();
    results.sort((a, b) => b.date.compareTo(a.date));
    return results.last;
  }
}
