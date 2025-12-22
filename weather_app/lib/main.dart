import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  bool isLoading = false;

  String? latitude;
  String? longitude;
  String? city;
  String? temperature;
  String? message;

  final apiKey = "7533f3ebfc0647d2af951606251212";

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  Future<void> getWeather(double lat, double lon) async {
    final url =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temperature = data["current"]["temp_c"].toString();
        city = data["location"]["name"];
      });
    } else {
      setState(() {
        message = "Weather API failed. Try again.";
      });
    }
  }

  Future<void> getLocationAndWeather() async {
    setState(() {
      isLoading = true;
    });

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      setState(() {
        isLoading = false;
        message = "Location denied. Please allow it.";
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isLoading = false;
        message = "Location permanently denied. Enable from Settings.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await getWeather(position.latitude, position.longitude);

    setState(() {
      isLoading = false;
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Weather App", style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: isLoading
            ? SpinKitCircle(color: Colors.blueAccent, size: 60)
            : latitude != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Current City: ${city ?? "Loading..."}",
                          style: TextStyle(fontSize: 18)),
                      Text("Temperature: ${temperature ?? "--"}°C",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 30),
                      TextButton(
                        onPressed: getLocationAndWeather,
                        style: TextButton.styleFrom(
                          shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Get Location"),
                      ),
                    ],
                  )
                : Text(
                    message ?? "Unable to get location",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
      ),
    );
  }
}
