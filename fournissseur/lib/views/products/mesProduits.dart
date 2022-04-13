import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:le_fournisseur/controllers/CartController.dart';
import 'package:le_fournisseur/controllers/ProduitController.dart';
import 'package:le_fournisseur/views/home.dart';
import 'package:le_fournisseur/views/orders/checkout.dart';
import 'package:le_fournisseur/views/orders/detailcommande.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListView extends StatelessWidget {
  final CartController _cartController = Get.put(CartController());
  bool _isLoading = false;

  final ProductlistController _produitController =
      Get.put(ProductlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC71617),
        elevation: 0.0,
        centerTitle: true,
        title: Text("Liste des produits",
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        actions: [],
      ),
      body: Obx(
        () => LoadingOverlay(
          child: Container(
            padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
            height: Get.height,
            width: Get.width,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1 / 1.3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: _produitController.produit.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                //  Get.to(()=>DetailsProduit(),transition: Transition.fade);
                              },
                              child: (_produitController.produit[index].photo ==
                                      null)
                                  ? Image.asset(
                                      "assets/images/Logo-founisseur.png")
                                  : Container(
                                      width: Get.width / 3,
                                      height: Get.height / 9,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                        image: DecorationImage(
                                          image: NetworkImage(_produitController
                                              .produit[index].photo),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Nom : ${_produitController.produit[index].libelle}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Prix  : ${_produitController.produit[index].prixCarton} Fcfa",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: GestureDetector(
                                onTap: () {
                                  _cartController.addProductInCart(
                                      _produitController.produit[index].id,
                                      _produitController.produit[index].status);
                                  Get.to(() => ShoppingCartPage(),
                                      transition: Transition.fade);
                                },
                                child: Row(children: [
                                  Icon(Icons.shopping_cart_outlined,
                                      color: Color(0xff14427D), size: 16.0),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Ajouter au panier',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff14427D),
                                          fontSize: 16))
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          isLoading: _produitController.isLoading.value,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(HomePage());
        },
        backgroundColor: Color(0xffC71617),
        child: Icon(
          Icons.dashboard,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
