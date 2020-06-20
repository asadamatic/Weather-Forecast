import 'dart:async';


import 'package:flutter/material.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:weather/weather_library.dart';
import 'package:weatherapp/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primaryColor: Colors.white,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => LoadingScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation<Offset> animation;

  WeatherStation weatherStation = WeatherStation('eb4fdd6ba32007915f8e4ff410e33e52');
  Weather weather;
  Position position;
//  Coordinates coordinates;
//  List<Address> address;
  String cityName;
//  LocationOptions locationOptions;
//  StreamSubscription<Position> streamSubscription;
  void getWeather() async{
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//    coordinates = Coordinates(position.latitude, position.longitude);
//    address = await Geocoder.local.findAddressesFromCoordinates(coordinates);

//    cityName =  address.first.adminArea.split(' ')[0];
//
    cityName = "Islamabad";
    List<Weather> weatherForecast = await weatherStation.fiveDayForecast(33.6166624,73.1209386);
    weather = await weatherStation.currentWeather(33.6166624,73.1209386);
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'weather': weather,
      'weatherForecast': weatherForecast,
      'cityName': cityName,
      'weatherStation': weatherStation,
    });

//    locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
//    streamSubscription = Geolocator().getPositionStream(locationOptions).listen((Position newPosition) {
//
//      position = newPosition != null ? newPosition : position;
//    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeather();
    animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.5, 0.0)
    ).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SlideTransition(
              position: animation,
              child: Image(
                image: AssetImage('Assets/welcome.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TweenAnimationBuilder(
                  tween: Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 5.0),),

                  duration: Duration(seconds: 1),
                  builder: (context, offset, child){

                    return Transform.translate(
                        offset: offset,
                        child: Text('WEATHER', textAlign: TextAlign.left, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Lato-Black"),));
                  },
                ),
                TweenAnimationBuilder(
                  tween: Tween<Offset>(begin: Offset(0.0, 10.0), end: Offset.zero,),

                  duration: Duration(seconds: 1),
                  builder: (context, offset, child){

                    return Transform.translate(
                        offset: offset,
                        child: Text('FORECAST', textAlign: TextAlign.left, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "Lato-Black"),));
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

}
