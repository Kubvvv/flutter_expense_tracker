import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _temperature = 'Loading...';
  String _condition = '';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=49.7500&longitude=18.6333&current_weather=true';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = '${data['current_weather']['temperature']}°C';
          _condition =
              'Windspeed: ${data['current_weather']['windspeed']} km/h';
          _isError = false; // Reset error state
        });
      } else {
        setState(() {
          _isError = true;
          _temperature = 'Error fetching data';
          _condition = '';
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _temperature = 'No internet connection';
        _condition = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.blueAccent.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_isError) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weather in Cieszyn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text('Temperature: '),
                        Text(
                          _temperature,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      _condition,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ] else
            Center(
              child: Text(
                _temperature, // "No internet connection" or error
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
