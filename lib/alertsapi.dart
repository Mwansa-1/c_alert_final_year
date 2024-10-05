import 'dart:convert';
import 'package:http/http.dart' as http;

class AlertPost {
  final int id; // Assuming there's an ID for the alert
  final String location;
  final String date;
  final String time; // Use the appropriate type for your date

  AlertPost({
    required this.id,
    required this.location,
    required this.date,
    required this.time,
  });

  factory AlertPost.fromJson(Map<String, dynamic> json) {
    return AlertPost(
      id: json['id'], // Adjust if the field name is different
      location: json['location'], // Adjust based on your API response
      date: json['date'],
      time: json['time'],
    );
  }
}

class AlertApi {
  static const String baseUrl =
      'http://192.168.20.222:8000/'; // Update to your base URL

  Future<List<AlertPost>> fetchAlertPosts() async {
    final response =
        await http.get(Uri.parse('$baseUrl/alert_list')); // Adjust the endpoint

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<AlertPost> alertPosts =
          body.map((dynamic item) => AlertPost.fromJson(item)).toList();
      return alertPosts;
    } else {
      throw Exception('Failed to load alert posts');
    }
  }
}
