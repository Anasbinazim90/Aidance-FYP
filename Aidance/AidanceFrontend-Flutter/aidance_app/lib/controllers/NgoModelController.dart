import 'dart:developer';

import 'package:aidance_app/models/NgoModel/NgoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NgoModelController extends GetxController {
  RxList<DocumentSnapshot> ngos = RxList<DocumentSnapshot>([]);

  // Fetch NGOs from Firestore
  void fetchNgos() async {
    log('hii');
    try {
      // show pending ngos only
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Ngousers')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      ngos.assignAll(querySnapshot.docs);
      log(ngos.length.toString());
    } catch (e) {
      print('Error fetching NGOs: $e');
    }
  }

  // Fetch NGOs from Firestore
}
