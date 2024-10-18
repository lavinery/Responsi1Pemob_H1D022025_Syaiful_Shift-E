class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/';
  static const String registrasi = baseUrl + 'api/registrasi';
  static const String login = baseUrl + 'api/login';
  static const String listNutrisi = baseUrl + 'api/kesehatan/data_nutrisi';
  static const String createNutrisi = baseUrl + 'api/kesehatan/data_nutrisi';

  static String updateNutrisi(int id) {
    return baseUrl + 'api/kesehatan/data_nutrisi/' + id.toString() + '/update';
  }

  static String showNutrisi(int id) {
    return baseUrl + 'api/kesehatan/data_nutrisi/' + id.toString();
  }

  static String deleteNutrisi(int id) {
    return baseUrl + 'api/kesehatan/data_nutrisi/' + id.toString() + '/delete';
  }
}
