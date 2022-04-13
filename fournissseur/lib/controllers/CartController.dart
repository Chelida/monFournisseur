import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:le_fournisseur/models/Cart.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  String serverUrl = "http://devops.egaz.shop/v1/api";

  String message;
  var token;
  var totalcredit;
  var totaldebit;
  var isLoading = false.obs;
  var status = RxInt(0);
  var montantttc;
   
   RxList<Cart> cart = <Cart>[].obs;
  List<Cart> carts = List();
  int nbcommandeitems = 0;
  @override
  void onInit() {

    getCart();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  String format(DateTime date) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  /**
   * recuperation du panier de l'utilisateur
   */
  Future<List> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    isLoading(true);
    List<Cart> carts = List();
    var url = Uri.parse('$serverUrl/carts');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var data = json.decode(response.body);
 
    if (response.statusCode == 200) {
      isLoading(false);
      carts = (data["data"]["carts"] as List)
          .map((data) => new Cart.fromJson(data))
          .toList();
      montantttc = data["data"]["montantttc"];
      return carts;
    } else {
      isLoading(false);
      throw Exception('Veuillez verifier votre connexion internet');
    }
    
  }

  /**
   * Suppression d'un produit du panier
   */
  deleteProductInCart(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    isLoading(true);
    var url =
        Uri.parse('http://devops.egaz.shop/v1/api/carts/product/delete/$id');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      isLoading(false);
      carts =((data["data"]["carts"] as List)
          .map((data) => new Cart.fromJson(data))
          .toList());
    } else {
      isLoading(false);
      throw Exception();
    }
  }

  // /**
  //  * Modification de la quantite d'un produit dans le panier
  //  */
  updateProductInCart(
    int cart_id,
    int quantite,
    int produit_id,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    isLoading(true);

    var url = Uri.parse('$serverUrl/carts/update');
    final response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      "cart_id": cart_id.toString(),
      "quantite": quantite.toString(),
      "produit_id": produit_id.toString(),
      //"type":type,
    });
    status(response.statusCode);
    var data = json.decode(response.body);

    message = data["message"];
 
    if (status == 200) {
      isLoading(false);
      carts = (data["data"]["carts"] as List)
          .map((data) => new Cart.fromJson(data))
          .toList();

      montantttc = data["data"]["montantttc"];
      return carts;
    } else {
      isLoading(false);
      throw Exception();
    }
    
  }

  // /**
  //  * Ajout du produit dans le panier
  //  */
  addProductInCart(int produit_id, int quantite) async {
 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');

    isLoading(true);
    var url = Uri.parse('$serverUrl/carts/store');
    final response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      "quantite": quantite.toString(),
      "produit_id": produit_id.toString(),
    });
    status(response.statusCode);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      isLoading(false);
          carts = (data["data"]["carts"] as List)
          .map((data) => new Cart.fromJson(data))
          .toList();
    } else {
      isLoading(false);
      throw Exception();
    }
  }


}
