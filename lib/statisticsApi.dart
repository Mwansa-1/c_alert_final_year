import 'dart:convert';
import 'package:http/http.dart' as http;

class Statisticsapi {
  final int id;
  final String month;
  final int positive_cases;
  final int deaths;
  final int cures;
  final String date;

  Statisticsapi({
    required this.id,
    required this.month,
    required this.positive_cases,
    required this.deaths,
    required this.cures,
    required this.date,
  });

  factory Statisticsapi.fromJson(Map<String, dynamic> json) {
    return Statisticsapi(
      id: json['id'] ?? 0,
      month: json['month'] ?? '',
      positive_cases: json['positive_cases'] ?? 0,
      deaths: json['deaths'] ?? 0,
      cures: json['cures'] ?? 0,
      date: json['date'] ?? '',
    );
  }
}

class StatisticsApi {
  static const String baseUrl = 'http://192.168.124.222:8000';

  Future<List<Statisticsapi>> fetchStatistics() async {
    final response = await http.get(Uri.parse('$baseUrl/statistics_list'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Statisticsapi> statistics =
          body.map((dynamic item) => Statisticsapi.fromJson(item)).toList();
      return statistics;
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  Future<Statisticsapi> fetchLatestStat() async {
    final statistics = await fetchStatistics();
    statistics.sort((a, b) => b.date.compareTo(a.date));
    return statistics
        .singleWhere((element) => element.date == statistics.first.date);
  }
}
