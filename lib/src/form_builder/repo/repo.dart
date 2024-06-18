import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:varicon_form_builder/src/models/place_model.dart';

class Repo {
  Repo._();
  static Future<PredictionModel?> placeAutoComplete(
      {required String placeInput}) async {
    try {
      Map<String, dynamic> querys = {
        'input': placeInput,
        'key': 'AIzaSyDgqEIdJnMQ_3YkbX4UkM5GVjRWwXcDCE4'
      };
      final url = Uri.https(
          "maps.googleapis.com", "maps/api/place/autocomplete/json", querys);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return PredictionModel.fromJson(jsonDecode(response.body));
      } else {
        response.body;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }
}
