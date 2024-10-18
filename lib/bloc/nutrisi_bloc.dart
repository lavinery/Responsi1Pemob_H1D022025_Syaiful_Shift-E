import 'dart:convert';
import 'package:kesehatan/helpers/api.dart';
import 'package:kesehatan/helpers/api_url.dart';
import 'package:kesehatan/model/nutrisi.dart';

class NutrisiBloc {
  static Future<List<Nutrisi>> getNutrisi() async {
    String apiUrl =
        ApiUrl.listNutrisi; // sesuaikan jika ada endpoint khusus untuk Nutrisi
    var response = await Api().get(apiUrl);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      List<dynamic> listNutrisi = (jsonObj as Map<String, dynamic>)['data'];
      List<Nutrisi> nutrisis = [];

      for (var item in listNutrisi) {
        nutrisis.add(Nutrisi.fromJson(item));
      }

      return nutrisis;
    } else {
      throw Exception("Failed to load nutrisi");
    }
  }

  static Future addNutrisi({Nutrisi? nutrisi}) async {
    String apiUrl = ApiUrl.createNutrisi;

    var body = {
      "food_item": nutrisi!.itemNutrisi,
      "calories": nutrisi.caloriesNutrisi.toString(),
      "fat_content": nutrisi.fatNutrisi.toString()
    };

    var response = await Api().post(apiUrl, body);
    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return jsonObj['status'];
    } else {
      throw Exception("Failed to add nutrisi");
    }
  }

  static Future updateNutrisi({required Nutrisi nutrisi}) async {
    String apiUrl = ApiUrl.updateNutrisi(nutrisi.id!);
    print(apiUrl);

    var body = {
      "food_item": nutrisi.itemNutrisi,
      "calories": nutrisi.caloriesNutrisi.toString(),
      "fat_content": nutrisi.fatNutrisi.toString()
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return jsonObj['status'];
    } else {
      throw Exception("Failed to update nutrisi");
    }
  }

  static Future<bool> deleteNutrisi({int? id}) async {
    String apiUrl = ApiUrl.deleteNutrisi(id!);

    var response = await Api().delete(apiUrl);
    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return (jsonObj as Map<String, dynamic>)['data'];
    } else {
      throw Exception("Failed to delete nutrisi");
    }
  }
}
