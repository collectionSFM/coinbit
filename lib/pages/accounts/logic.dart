import 'dart:math';

import 'package:coinbit/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

import 'state.dart';

class AccountLogic extends GetxController {
  final AccountState state = AccountState();

  createWallet() {
    var rng = Random.secure();
    EthPrivateKey credentials = EthPrivateKey.createRandom(rng);

    Wallet wallet = Wallet.createNew(credentials, "explain alley prosper short despair glide truck december describe credit pumpkin morning", rng);

    Get.bottomSheet(Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            children: [
              const Text("Wallet Created", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
              const ListTile(
                title: Text("Mnemonic", style: const TextStyle(color: Colors.black)),
                subtitle: const Text("explain alley prosper short despair glide truck december describe credit pumpkin morning", style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Private Key", style: const TextStyle(color: Colors.black)),
                subtitle: Text(wallet.privateKey.privateKeyInt.toString(), style: const TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Wallet Address", style: const TextStyle(color: Colors.black)),
                subtitle: Text(credentials.address.hex, style: const TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Json Abi", style: const TextStyle(color: Colors.black)),
                subtitle: Text(wallet.toJson(), style: const TextStyle(color: Colors.grey)),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
