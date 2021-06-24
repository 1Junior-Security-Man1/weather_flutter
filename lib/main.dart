import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_flutter/components/SearchDelegate.dart';
import 'package:weather_flutter/events/WeatherEvent.dart';
import 'package:weather_flutter/states/WeatherState.dart';
import 'bloc/WeatherBloc.dart';
import 'components/MainScreenWrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColorDark: Colors.white,
          primaryColor: Colors.white,
        ),
        home: BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc('Berlin'), child: MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  fetchWeather() {
    //print('hello');
    BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: 'Kiev'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener:(context, state) {
        if(state is WeatherLoadFailure) {
          final snackBar = SnackBar(content: Text('Weather loading error!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoadSuccess) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: MySearchDelegate((query) {
                          BlocProvider.of<WeatherBloc>(context)
                              .add(WeatherRequested(city: query));
                        }, selectedResult: ''),
                      );
                    },
                  )
                ],
              ),
              body: Padding(
                padding: EdgeInsets.only(top: 64),
                child: MainScreenWrapper(
                    weather: state.weather, hourlyWeather: state.hourlyWeather),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
