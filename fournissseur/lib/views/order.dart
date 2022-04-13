import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:le_fournisseur/controllers/CartController.dart';
import 'package:le_fournisseur/controllers/CommandeController.dart';
import 'package:le_fournisseur/models/Commande.dart';
import 'package:le_fournisseur/widgets/drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';


class OrderPage extends StatelessWidget {



  final CommanderController _commanderController =
      Get.put(CommanderController());
     

    String format(DateTime date) {
   String formattedDate = DateFormat('dd/MM/yyyy').format(date);
   return formattedDate;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mes commandes",
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC71617),
      ),
       drawer: DrawerPage(),
      body: Obx(() => LoadingOverlay(
           
        child: ListView.builder(
    
        physics: BouncingScrollPhysics(),
        itemCount: _commanderController.commande.length,
        itemBuilder: (context, index) {
          return GestureDetector(
           
            child: Container(
              height: Get.height/4,

              width: Get.width,
              
              margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0,),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Ref : ${_commanderController.commande[index].reference}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text('Etat : ',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                    )),
                                _commanderController.commande[index].etat == 1
                                    ? Container(
                                        width: 80.0,
                                        height: 25.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.green),
                                        child: Center(
                                          child: Text(
                                            'Payée',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.white,
                                                fontSize: 12.0),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 80.0,
                                        height: 25.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.red),
                                        child: Center(
                                          child: Text(
                                            'Impayee',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.white,
                                                fontSize: 12.0),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text('Statut : ',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                    )),
                                if (_commanderController.commande[index].statut == 1)
                                  Container(
                                    width: 80.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.green),
                                    child: Center(
                                      child: Text(
                                        'livrée',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  ),
                                if (_commanderController.commande[index].statut == 2)
                                  Container(
                                    width: 80.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.orange),
                                    child: Center(
                                      child: Text(
                                        'encours',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  ),
                                if (_commanderController.commande[index].statut == 0)
                                  Container(
                                    width: 80.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.grey),
                                    child: Center(
                                      child: Text(
                                        'en attente ',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  ),
                                if (_commanderController.commande[index].statut == 3)
                                  Container(
                                    width: 80.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.red),
                                    child: Center(
                                      child: Text(
                                        'refusée',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10,),
                              Text(
                                'Montant TTC : ${_commanderController.commande[index].montantttc} FCFA',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Color(0xffa61019)),
                              ),
                                 SizedBox(height: 10,),
                              Text(
                                 format(_commanderController.commande[index].dateCommande),
                                // format(factures[index].createdAt),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            
                            ],
                          ),
                        ),
                      ),
          
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
  
        isLoading: _commanderController.isLoading.value,
      ),
      
      ),

    )
    
    ;
  }


}


