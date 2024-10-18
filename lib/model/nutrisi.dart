class Nutrisi {
  int? id;
  String? itemNutrisi;
  int? caloriesNutrisi;
  int? fatNutrisi;
  Nutrisi({this.id, this.itemNutrisi, this.caloriesNutrisi, this.fatNutrisi});
  factory Nutrisi.fromJson(Map<String, dynamic> obj) {
    return Nutrisi(
        id: obj['id'],
        itemNutrisi: obj['food_item'],
        caloriesNutrisi: obj['calories'],
        fatNutrisi: obj['fat_content']);
  }
}
