import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';

class AddCampaignScreen extends StatelessWidget {
  const AddCampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColors.theme_turquoise,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        elevation: 2.0,
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Container(),
    );
  }
}
