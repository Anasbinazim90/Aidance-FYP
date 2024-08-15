// import 'package:aidance_app/controllers/DataTableController.dart';
// import 'package:aidance_app/screens/DonorView/CampaignDetailScreenDonor/CampaignDetailScreenDonor.dart';
// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class DataRowModel {
//   final String DonorName;
//   final String Currency;
//   final String Date;
//   final String Message;
//   final double Amount;

//   DataRowModel({
//     required this.DonorName,
//     required this.Currency,
//     required this.Date,
//     required this.Message,
//     required this.Amount,
//   });
// }

// class DataTableScreen extends StatelessWidget {
//   const DataTableScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Donation Information'),
//         leading: BackButton(),
//       ),
//       body: DataTableContent(),
//     );
//   }
// }

// class DataTableContent extends StatelessWidget {
//   final DataTableController controller = Get.put(DataTableController());

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Obx(
//         () => DataTable2(
//           columnSpacing: 12,
//           horizontalMargin: 12,
//           minWidth: 700.w,
//           columns: [
//             DataColumn2(
//               label: Text(
//                 'Donor',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xff171A1F),
//                 ),
//               ),
//               size: ColumnSize.S,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Amount',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xff171A1F),
//                 ),
//               ),
//               size: ColumnSize.S,
//               // numeric: true,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Currency',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xff171A1F),
//                 ),
//               ),
//               size: ColumnSize.S,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Date',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xff171A1F),
//                 ),
//               ),
//               size: ColumnSize.S,
//             ),
//             DataColumn2(
//               label: Text(
//                 'Message',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xff171A1F),
//                 ),
//               ),
//               size: ColumnSize.S,
//             ),
//           ],
//           rows: controller.data.map((model) {
//             return DataRow(
//               cells: [
//                 DataCell(GestureDetector(
//                   onTap: () {
//                     // Handle row tap

//                     Get.bottomSheet(DonationDetailsBottomSheet());
//                   },
//                   child: Text(model.DonorName),
//                 )),
//                 DataCell(Text(model.Amount.toString())),
//                 DataCell(Text(model.Currency)),
//                 DataCell(Text(model.Date)),
//                 DataCell(Text(model.Message)),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

import 'package:aidance_app/controllers/DataTableController.dart';
import 'package:aidance_app/helper/helper_methods.dart';
import 'package:aidance_app/screens/DonorView/CampaignDetailScreenDonor/CampaignDetailScreenDonor.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataRowModel {
  final String DonorName;
  final String Currency;
  final String Date;
  final String Message;
  final double Amount;
  final String transactionHash;

  DataRowModel({
    required this.DonorName,
    required this.Currency,
    required this.Date,
    required this.Message,
    required this.Amount,
    required this.transactionHash,
  });
}

class DataTableController extends GetxController {
  var data = <DataRowModel>[].obs;

  RxBool loading = false.obs;

  @override
  Future<void> fetchDonations(campaigntokenId) async {
    try {
      // Adjust the campaign tokenId as per your use case
      final tokenId = campaigntokenId;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('campaigns')
          .where('tokenId', isEqualTo: tokenId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final campaignDoc = querySnapshot.docs.first;
        final donations = campaignDoc['donations'] as List;

        var donationList = donations.map((donation) {
          return DataRowModel(
            DonorName: donation['donorName'],
            Currency: 'ETH', // Assuming currency is ETH
            Date:
                '${FormatedDate2(donation['timestamp'])} ${FormatedTime(donation['timestamp'])}',
            Message: donation['message'],
            Amount: donation['amount'],
            transactionHash: donation['transactionHash'],
          );
        }).toList();

        // Sort donationList by timestamp in descending order
        donationList.sort((a, b) => b.Date.compareTo(a.Date));

        // Update data with the sorted list

        data.assignAll(donationList);
        loading.value = false;
      }
    } catch (e) {
      loading.value = false;

      print('Error fetching donations: $e');
    }
  }
}

class DataTableScreen extends StatefulWidget {
  const DataTableScreen({super.key, required this.campaignId});

  final campaignId;

  @override
  State<DataTableScreen> createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
  final DataTableController controller = Get.put(DataTableController());
  @override
  void initState() {
    // TODO: implement initState
    controller.fetchDonations(widget.campaignId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Donation Information'),
          leading: BackButton(),
        ),
        body: controller.loading.value
            ? const Center(child: CircularProgressIndicator())
            : DataTableContent(),
      ),
    );
  }
}

class DataTableContent extends StatelessWidget {
  final DataTableController controller = Get.put(DataTableController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => DataTable2(
          // dataRowHeight: 55.h,
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 700.w,
          columns: [
            DataColumn2(
              label: Text(
                'Donor',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff171A1F),
                ),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(
                'Amount',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff171A1F),
                ),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(
                'Currency',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff171A1F),
                ),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              fixedWidth: 130.w,
              label: Text(
                textAlign: TextAlign.center,
                'Date',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff171A1F),
                ),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              // fixedWidth: 130.w,
              label: Text(
                'Message',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff171A1F),
                ),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              fixedWidth: 50.w,
              label: Text(
                '',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff171A1F),
                ),
              ),
              size: ColumnSize.S,
            ),
          ],
          rows: controller.data.map((model) {
            return DataRow(
              onLongPress: () {
                Get.bottomSheet(DonationDetailsBottomSheet2(
                  donationDetails: model,
                ));
              },
              cells: [
                DataCell(GestureDetector(
                  child: Text(model.DonorName),
                )),
                DataCell(Text(model.Amount.toString())),
                DataCell(Text(model.Currency)),
                DataCell(Text(model.Date)),
                DataCell(Text(model.Message)),
                DataCell(IconButton(
                    onPressed: () {
                      Get.bottomSheet(DonationDetailsBottomSheet2(
                        donationDetails: model,
                      ));
                    },
                    icon: Icon(Icons.more_horiz))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
