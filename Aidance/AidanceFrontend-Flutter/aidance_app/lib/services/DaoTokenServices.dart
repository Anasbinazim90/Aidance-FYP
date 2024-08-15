// import 'dart:convert';

// import 'package:aidance_app/services/metamask.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:aidance_app/constants.dart';
// import 'dart:developer';

// import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';

// class DaoTokenServices extends GetxController {
//   final metamaskProvider = MetaMaskProvider();
//   late Web3Client _ethClient;
//   late W3MService _w3mService;

//   // load contract function
//   Future<DeployedContract> loadContract() async {
//     log('Loading Contract');
//     //abi
//     String abi = await rootBundle.loadString('assets/abi.json');
//     var jsonAbi = jsonDecode(abi);
//     log('Loaded ABI: $jsonAbi');

//     //contact address
//     String contractAddress = DAO_TOKEN_CONTRACT_ADDRESS;
//     log(contractAddress);

//     final contract = DeployedContract(
//       ContractAbi.fromJson(abi, 'DAOToken'),
//       EthereumAddress.fromHex(contractAddress),
//     );
//     log(contract.address.toString());
//     return contract;
//   }

//   // Call function
//   Future getbalance() async {
//     return await _w3mService.requestReadContract(
//       deployedContract: await loadContract(),
//       functionName: 'balanceOf',
//       rpcUrl: ALCHEMY_API_KEY,
//       parameters: [
//         EthereumAddress.fromHex(DAO_TOKEN_CONTRACT_ADDRESS),
//       ],
//     );
//   }
// }
