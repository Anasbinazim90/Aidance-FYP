import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InfuraServices extends GetxController {
  Future<String> uploadToIPFS(String apiKey, List<int> fileBytes) async {
    try {
      // Encode file bytes to base64
      String fileContent = base64Encode(fileBytes);

      // Prepare JSON payload
      Map<String, dynamic> requestBody = {
        'data': fileContent,
      };

      // Send POST request to Infura IPFS API
      http.Response response = await http.post(
        Uri.parse('https://ipfs.infura.io:5001/api/v0/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Extract IPFS hash from the response
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String ipfsHash = responseData['Hash'];
        return ipfsHash;
      } else {
        throw Exception('Failed to upload to IPFS: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading to IPFS: $e');
    }
  }
}
