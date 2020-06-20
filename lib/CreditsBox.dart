import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsBox extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
   return AlertDialog(
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
      ],
      title: Text("Credits"),
      content: Container(
          height: 100.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('App Icon: ', style: TextStyle(color: Colors.grey[600], fontSize: 14.0, height: 1.3,), ),
                    GestureDetector(
                        onTap: () async{
                          await launch('https://icons8.com/');
                        },
                        child: Text('Icons8', style: TextStyle(color: Colors.grey[800], fontSize: 15.0, height: 1.3,), ))
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Weather Updates : ', style: TextStyle(color: Colors.grey[600], fontSize: 14.0, height: 1.3,), ),
                    GestureDetector(
                        onTap: () async{
                          await launch('https://openweathermap.org/');
                        },
                        child: Text('OpenWeather', style: TextStyle(color: Colors.grey[800], fontSize: 15.0, height: 1.3,),)
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Weather Icons : ', style: TextStyle(color: Colors.grey[600], fontSize: 14.0, height: 1.3,), ),
                    GestureDetector(
                        onTap: () async{
                          await launch('https://openweathermap.org/weather-conditions');
                        },
                        child: Text('OpenWeather', style: TextStyle(color: Colors.grey[800], fontSize: 15.0, height: 1.3,),)
                    )
                  ]
              ),
            ],
          )
      ),
    );
  }
}