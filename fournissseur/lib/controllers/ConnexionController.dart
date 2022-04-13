import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ConnexionController extends GetxController {
  String serverUrl = "http://devops.egaz.shop/v1/api";
  var status = RxInt(0);
  var user_role_id = RxInt(0);
  String message;
  var isLoading = false.obs;
  var user_name = ''.obs;
  var user_email = ''.obs;
  var user_lastname = ''.obs;
  var user_typeclient = ''.obs;
  var user_firstname = ''.obs;
  var user_pays = ''.obs;
  var code = ''.obs;
  var user_phone = ''.obs;
  var user_adresse = ''.obs;
  var solde;
  var photo = ''.obs;
  var debit = RxInt(0);
  var credit = RxInt(0);
  var token;
  var user_token = ''.obs;
  var nbcommande = RxInt(0);
  var nblivraison = RxInt(0);
  @override
  void onInit() {
    super.onInit();
  }

  login(String code, String password) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.get('token');

    isLoading(true);
    var url = Uri.parse('$serverUrl/login');
    final response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      "code": "$code",
      "password": "$password"
    });

    status(response.statusCode);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      await prefs.setString("token", data["access_token"].toString());
      token = prefs.get('token');
      await prefs.setString("solde", data["solde"].toString());
      solde = prefs.get('solde');

      saveData('user_firstname', data["user"]["firstname"]);
      saveData('user_lastname', data["user"]["lastname"]);
      saveData('user_typeclient', data["user"]["typeclient"]["name"]);
      saveData('photo', data["user"]["photo"]);
      saveData('nbcommande', data["nbcommande"].toString());
      saveData('user_telephone', data["user"]["telephone"]);
      saveData('user_email', data["user"]["email"]);
      saveData('code', data["user"]["code"]);
      saveData('user_adresse', data["user"]["adresse"]);
    } else {
      isLoading(false);
    }
  }

  // /*
  //  *  logout
  //  */
  logout() async {
    isLoading(false);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');

    var url = Uri.parse('$serverUrl/logout');
    http.Response response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    status(response.statusCode);
    prefs.remove('token');
    prefs.remove('solde');
    prefs.remove('user_firstname');
    prefs.remove('user_lastname');
    prefs.remove('user_pays');
    prefs.remove('user_typeclient');
    prefs.remove('user_phone');
    prefs.remove('user_email');
    prefs.remove('code');
    user_name('');
    user_lastname('');
    user_typeclient('');
    user_email('');
    user_phone('');
    code('');
    user_adresse('');
  
    debit(0);
    credit(0);
    await prefs.clear();
    prefs.setBool('showLogin', true);
    isLoading(false);
  }

  // /*
  //  *  recuperation des infos de l'utilisateur
  //  */
  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');

    if (token != null) {
      var url = Uri.parse("$serverUrl/user/profile");
      http.Response response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      var data = json.decode(response.body);

      saveData('user_email', data["data"]["user"]["email"]);

      saveData('user_firstname', data["data"]["user"]["firstname"]);
      saveData('user_lastname', data["data"]["user"]["lastname"]);
      saveData('user_telephone', data["data"]["user"]["telephone"]);
      saveData('user_typeclient', data["data"]["user"]["typeclient"]["name"]);

      return data;
    }

    saveBool(String ref, data) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(ref, data);
    }
  }

  getProfil() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');

    if (token != null) {
      var url = Uri.parse("$serverUrl/user/profile");
      http.Response response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        saveData('user_firstname', data["data"]["user"]["firstname"]);
        saveData('user_lastname', data["data"]["user"]["lastname"]);
        saveData('user_typeclient', data["data"]["user"]["typeclient"]["name"]);
        saveData('user_telephone', data["data"]["user"]["telephone"]);
        saveData('user_email', data["data"]["user"]["email"]);
        saveData('code', data["data"]["user"]["code"]);
        saveData('user_adresse', data["data"]["user"]["adresse"]);
        sync(data["data"]);
      } else {}
    }
  }

  /*
   * modification du mot de passe de l'utilisateur
   */
  changePassword(String current_password, String new_password) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.get('token');

    isLoading(true);
    var url = Uri.parse('$serverUrl/user/change-password');
    final response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      "current_password": "$current_password",
      "new_password": "$new_password"
    });

    status(response.statusCode);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      isLoading(false);
      //getUserData();

    } else {
      isLoading(false);
      throw Exception();
    }
  }

  updateProfile(
    String firstname,
    String lastname,
    String telephone,
    String email,
    String adresse,
  ) async {
    isLoading(true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');

    var url = Uri.parse("$serverUrl/user/update-profile");
    http.Response response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      "firstname": "$firstname",
      "lastname": "$lastname",
      "email": "$email",
      "telephone": "$telephone",
      "adresse": "$adresse",
    });

    status(response.statusCode);
    var data = json.decode(response.body);

    saveData('user_firstname', data["data"]["user"]["firstname"]);
    saveData('user_lastname', data["data"]["user"]["lastname"]);
    saveData('user_email', data["data"]["user"]["email"]);
    saveData('user_adresse', data["data"]["user"]["adresse"]);
    saveData('user_telephone', data["data"]["user"]["telephone"]);

    message = data["message"];

    if (status == 200) {
      isLoading(false);
    } else {
      isLoading(false);
    }
    isLoading(false);
  }

  saveBool(String ref, data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(ref, data);
  }

  save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  sync(var data) {
    user_name(data["user"]["lastname"]);
    user_firstname(data["user"]["firstname"]);
    user_lastname(data["user"]["lastname"]);
    user_typeclient(data["user"]["typeclient"]["name"]);
    user_email(data["user"]["email"]);
    user_phone(data["user"]["telephone"]);
    code(data["user"]["code"]);
    user_adresse(data["user"]["adresse"]);
    user_adresse(data["solde"]["solde"]);
    debit(data["compte"]["debit"]);
    credit(data["compte"]["credit"]);
  }
}
