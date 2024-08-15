import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class IPFSController extends GetxController {
  final String pinataApiKey = "626c47a1ceaf57fcc5c2";
  final String pinataSecretApiKey =
      "eb46f67d5bcfe32b3f6325930782907d92b32160d1cc534b8ee624d7cd44c52f";
  final String pinataApiUrl = "https://api.pinata.cloud";
  final String pinataGatewayUrl =
      "http://cyan-fantastic-beaver-931.mypinata.cloud";

  Future<String> uploadToIPFS(Map<String, dynamic> jsonData) async {
    try {
      // Convert JSON data to a string
      String jsonString = jsonEncode(jsonData);

      // Send POST request to Pinata API to upload JSON to IPFS
      final response = await http.post(
        Uri.parse('$pinataApiUrl/pinning/pinJSONToIPFS'),
        headers: {
          'Content-Type': 'application/json',
          'pinata_api_key': pinataApiKey,
          'pinata_secret_api_key': pinataSecretApiKey,
        },
        body: jsonString,
      );

      if (response.statusCode == 200) {
        // Extract IPFS hash from the response
        log('Uploaded Beneficiary data successfully');
        log(jsonDecode(response.body).toString());
        return response.body;
      } else {
        throw Exception(
            'Failed to upload data to IPFS: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading data to IPFS: $e');
    }
  }

  Future<bool> deleteFromIPFS(String ipfsHash) async {
    try {
      // Send DELETE request to Pinata API to unpin content from IPFS
      final response = await http.delete(
        Uri.parse('$pinataApiUrl/pinning/unpin/$ipfsHash'),
        headers: {
          'pinata_api_key': pinataApiKey,
          'pinata_secret_api_key': pinataSecretApiKey,
        },
      );

      if (response.statusCode == 200) {
        // Content successfully deleted
        return true;
      } else {
        // Failed to delete content
        throw Exception(
            'Failed to delete content from IPFS: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting content from IPFS: $e');
    }
  }

  Future<String?> uploadImageToIPFS(File imageFile) async {
    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$pinataApiUrl/pinning/pinFileToIPFS'),
    );

    // Add the image file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    // Add Pinata API key and secret API key to headers
    request.headers.addAll({
      'pinata_api_key': pinataApiKey,
      'pinata_secret_api_key': pinataSecretApiKey,
    });

    // Send the request
    var response = await request.send();

    // Check if request is successful
    if (response.statusCode == 200) {
      // Read response
      String responseBody = await response.stream.bytesToString();

      // Parse response to get IPFS hash
      Map<String, dynamic> responseData = jsonDecode(responseBody);
      String ipfsHash = responseData['IpfsHash'];

      return ipfsHash;
    } else {
      // If request fails, return null
      return null;
    }
  }

  Future<Uint8List?> getImageFromIPFS(String ipfsHash) async {
    // Make a GET request to retrieve the image data
    final response = await http.get(
      Uri.parse('$pinataGatewayUrl/ipfs/$ipfsHash'),
    );

    // Check if request is successful
    if (response.statusCode == 200) {
      // Decode the response body as bytes
      return response.bodyBytes;
    } else {
      // If request fails, return null
      return null;
    }
  }

  Future<String> uploadJsonToIPFS(Map<String, dynamic> jsonData) async {
    // Convert JSON data to a string
    String jsonString = jsonEncode(jsonData);

    // Create a temporary file to upload to IPFS
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/data.json');
    await file.writeAsString(jsonString);

    // Upload the file to IPFS
    String? ipfsHash =
        await uploadImageToIPFS(file); // Reusing the uploadImageToIPFS function

    return ipfsHash!;
  }
}
