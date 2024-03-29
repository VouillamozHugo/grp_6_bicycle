import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(
      {required this.startLng,
      required this.startLat,
      required this.endLng,
      required this.endLat});

  final String url =
      'https://api.openrouteservice.org/v2/directions/cycling-mountain';

  final String apiKey =
      '5b3ce3597851110001cf6248f83ccaf685cb453bb7c34e18c7a9e31f';
  final String journeyMode =
      'cycling-mountain'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(
      '$url?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat&elevation=True&extra_info=steepness',
    ));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    }
  }
}
