import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PinataServices extends GetxController {
  late final String pinataApiKey;
  late final String pinataApiSecret;
  late final String pinataEndpoint;
  late final Map<String, String> pinataHeaders;

  PinataServices() {
    // Initialize Pinata API credentials and endpoint in the constructor
    pinataApiKey = '626c47a1ceaf57fcc5c2';
    pinataApiSecret =
        'eb46f67d5bcfe32b3f6325930782907d92b32160d1cc534b8ee624d7cd44c52f';
    pinataEndpoint = 'https://api.pinata.cloud/pinning/pinFileToIPFS';

    // Initialize Pinata headers
    pinataHeaders = {
      'Content-Type': 'application/json',
      'pinata_api_key': pinataApiKey,
      'pinata_secret_api_key': pinataApiSecret,
    };
  }

  Future<String> uploadToPinata(File file) async {
    // Read the file as bytes
    List<int> fileBytes = await file.readAsBytes();

    // Convert file bytes to base64 string
    String fileContent = base64Encode(fileBytes);

    // Prepare JSON payload
    Map<String, dynamic> requestBody = {
      'file': fileContent,
      'pinataOptions': {'cidVersion': 0}
    };

    // Send POST request to Pinata
    http.Response response = await http.post(
      Uri.parse(pinataEndpoint),
      headers: pinataHeaders,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Extract the IPFS hash from the response
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String ipfsHash = responseData['IpfsHash'];
      return ipfsHash;
    } else {
      throw Exception('Failed to upload to Pinata: ${response.statusCode}');
    }
  }

  // method 2
}
