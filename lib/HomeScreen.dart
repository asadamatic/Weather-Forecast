import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather_library.dart';
import 'package:weatherapp/CreditsBox.dart';

class HomeScreen extends StatefulWidget {


  @override
  State createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>{

  Map data = {};
  Weather weather;
  WeatherStation weatherStation;
  List<Weather> weatherForecast;
  String cityName;

  //DateTime data
  DateTime currentTime = DateTime.now();

  void getWeatherData() async{

    weather = await weatherStation.currentWeather(33.6166624,73.1209386);
  }
  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(seconds: 60), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    weather = data['weather'];
    weatherForecast = data['weatherForecast'];
    cityName = data['cityName'];
    weatherStation = data['weatherStation'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
              IconButton(
              icon: Icon(
                Icons.info,
              ),
              onPressed: (){
                showAboutDialog(context: context,
                  applicationName: 'Weather Forecasr',
                  applicationVersion: '1.0',
                  applicationIcon: Image(
                    image: AssetImage('Assets/welcome.png'),
                    height: 60.0,
                    width: 60.0,
                  ),);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.perm_device_information,
              ),
              onPressed: (){
                showDialog(context: context, builder: (BuildContext context){
                  return CreditsBox();
                });
              },
            )
        ],
        centerTitle: true,
        title: Text('$cityName', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${weather.temperature.toString().split(' ')[0].split('.')[0]}\u00B0', style: TextStyle(fontSize: 48.0),),
                ),
                WeatherIcon(currentTime: currentTime, weather: weather),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${weather.weatherDescription}', style: TextStyle(fontSize: 30.0),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: Text('${weather.tempMin.toString().split(' ')[0].split('.')[0]}\u00B0 / ${weather.tempMax.toString().split(' ')[0].split('.')[0]}\u00B0', style: TextStyle(fontSize: 20.0),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Updated ${weather.date.minute > currentTime.minute ? currentTime.minute + 60 - weather.date.minute : currentTime.minute - weather.date.minute} minutes ago', style: TextStyle(fontSize: 12.0),),
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            children: weatherForecast.map((weather) => WeatherForecastTile(key: UniqueKey(), weather: weather,)).toList(),

          )
        ],
      ),

    );
  }
}

class WeatherForecastTile extends StatefulWidget{

  Weather weather;
  Key key;
  WeatherForecastTile({this.key, this.weather});
  @override
  State createState() {
    return WeatherForecastTileState();
  }
}

class WeatherForecastTileState extends State<WeatherForecastTile>{


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${DateFormat('E, d MMM ').format(widget.weather.date)}', style: TextStyle(fontSize: 18.0),),
              ),
              WeatherIcon(currentTime: widget.weather.date, weather: widget.weather,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                child: Text('${widget.weather.tempMin.toString().split(' ')[0].split('.')[0]}\u00B0 / ${widget.weather.tempMax.toString().split(' ')[0].split('.')[0]}\u00B0', style: TextStyle(fontSize: 18.0),),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Text('${DateFormat.jm().format(widget.weather.date)}', style: TextStyle(fontSize: 18.0),),
          ),

        ],
      ),
    );
  }
}

class WeatherIcon extends StatefulWidget{

  Weather weather;
  DateTime currentTime;
  WeatherIcon({this.currentTime, this.weather});

  @override
  State createState() {
    return WeatherIconState();
  }
}

class WeatherIconState extends State<WeatherIcon>{

  Widget WeatherIcon(DateTime currentTime, Weather weather){

    String image;
    if (currentTime.hour > 5 && currentTime.hour < 17){

      if (weather.weatherMain.toString() == 'Clear'){
        image = 'Assets/clearskymorning.png';
      }else if (weather.weatherMain.toString() == 'Clouds'){
        if (weather.weatherDescription.toString() == 'scattered clouds') {
          image = 'Assets/scatteredclouds.png';
        }else if(weather.weatherDescription.toString() == 'few clouds'){
          image = 'Assets/fewcloudsmorning.png';
        }else if (weather.weatherDescription.toString() == 'broken clouds' || weather.weatherDescription.toString() == 'overcast clouds:'){
          image = 'Assets/brokenclouds.png';
        }else{
          image = 'Assets/fewcloudsmorning.png';
        }
      }else if (weather.weatherMain.toString() == 'Rain' || weather.weatherMain.toString() == 'Drizzle'){
        if (weather.weatherDescription.toString() == 'shower rain'){
          image = 'Assets/showerrain.png';
        }else{
          image = 'Assets/rainmorning.png';
        }
      }else if (weather.weatherMain.toString() == 'Thunderstorm'){
        image = 'Assets/thunderstorm.png';
      }else if (weather.weatherMain.toString() == 'Snow'){
        image = 'Assets/snow.png';
      }else if (weather.weatherMain.toString() == 'Mist'
          || weather.weatherMain.toString() == 'Smoke' ||
          weather.weatherMain.toString() == 'Haze' ||
          weather.weatherMain.toString() == 'Fog' ||
          weather.weatherMain.toString() == 'Dust' ||
          weather.weatherMain.toString() == 'Ash' ||
          weather.weatherMain.toString() == 'Squall' ||
          weather.weatherMain.toString() == 'Tornado'){
        image = 'Assets/mist.png';
      }else {
        image = 'Assets/clearskymorning.png';
      }
    }else{
      if (weather.weatherMain.toString() == 'Clear'){
        image = 'Assets/clearskynight.png';
      }else if (weather.weatherMain.toString() == 'Clouds'){
        if (weather.weatherDescription.toString() == 'scattered clouds') {
          image = 'Assets/scatteredclouds.png';
        }else if(weather.weatherDescription.toString() == 'few clouds'){
          image = 'Assets/fewcloudsnight.png';
        }else if (weather.weatherDescription.toString() == 'broken clouds' || weather.weatherDescription.toString() == 'overcast clouds:'){
          image = 'Assets/brokenclouds.png';
        }else{
          image = 'Assets/fewcloudsnight.png';
        }
      }else if (weather.weatherMain.toString() == 'Rain' || weather.weatherMain.toString() == 'Drizzle'){
        if (weather.weatherDescription.toString() == 'shower rain'){
          image = 'Assets/showerrain.png';
        }else{
          image = 'Assets/rainnight.png';
        }
      }else if (weather.weatherMain.toString() == 'Thunderstorm'){
        image = 'Assets/thunderstorm.png';
      }else if (weather.weatherMain.toString() == 'Snow'){
        image = 'Assets/snow.png';
      }else if (weather.weatherMain.toString() == 'Mist'
          || weather.weatherMain.toString() == 'Smoke' ||
          weather.weatherMain.toString() == 'Haze' ||
          weather.weatherMain.toString() == 'Fog' ||
          weather.weatherMain.toString() == 'Dust' ||
          weather.weatherMain.toString() == 'Ash' ||
          weather.weatherMain.toString() == 'Squall' ||
          weather.weatherMain.toString() == 'Tornado'){
        image = 'Assets/mist.png';
      }else {
        image = 'Assets/clearskynight.png';
      }
    }
    return Image(
        image: AssetImage(image)
    );
  }
  @override
  Widget build(BuildContext context) {
    return WeatherIcon(widget.currentTime, widget.weather);
  }
}