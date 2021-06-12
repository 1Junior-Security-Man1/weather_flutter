import 'package:equatable/equatable.dart';
import 'package:weather_flutter/models/Weather.dart';

abstract class WeatherState extends Equatable {

  @override
  List<Object> get props => [];

  WeatherState();
}

class WeatherInitial extends WeatherState {}

class WeatherLoadInProgress extends WeatherState {}

class WeatherLoadSuccess extends WeatherState {
  final Weather weather;
  final List<Weather> hourlyWeather;

  WeatherLoadSuccess(this.weather, this.hourlyWeather);

  @override
  List<Object> get props => [weather];
}

class WeatherLoadFailure extends WeatherState {}
