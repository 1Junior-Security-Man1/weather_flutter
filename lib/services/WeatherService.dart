import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_flutter/models/Weather.dart';

class WeatherService {
  static String _apiKey = "f92b5779c828433706f748a890681ef8";

  static Future<Weather> fetchCurrentWeather(
      {query}) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$query&appid=$_apiKey&units=metric';
    // Changed
    final response = await http.post(Uri.parse(url));
    //final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  static Future<List<Weather>> fetchHourlyWeather(
      {required String query, String lat = "", String lon = ""}) async {
    var url =
        'http://api.openweathermap.org/data/2.5/forecast?q=$query&lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    // Changed
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Weather> data =
      (jsonData['list'] as List<dynamic>).map((item) {
        print('ITEM SHOW: ' + item);
        return Weather.fromJson(item);
      }).toList();
      return data;
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
