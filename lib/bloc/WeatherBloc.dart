import 'package:bloc/bloc.dart';
import 'package:weather_flutter/events/WeatherEvent.dart';
import 'package:weather_flutter/models/Weather.dart';
import 'package:weather_flutter/services/WeatherService.dart';
import 'package:weather_flutter/states/WeatherState.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final String cityName;

  WeatherBloc(this.cityName) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is WeatherRequested) {
      yield WeatherLoadInProgress();
      try {
        final Weather weather = await WeatherService.fetchCurrentWeather(query: event.city);
        final List<Weather> hourlyWeather = await WeatherService.fetchHourlyWeather(query: event.city);
        yield WeatherLoadSuccess(weather, hourlyWeather);
      } catch (_) {
        yield WeatherLoadFailure();
      }
    }
  }
}
