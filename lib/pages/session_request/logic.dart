
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:coinbit/main.dart';
import 'package:coinbit/shares/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'state.dart';

class SessionRequestLogic extends GetxController {
  final SessionRequestState state = SessionRequestState();
  static const walletConnectV2Channel = MethodChannel('walletconnectv2');
  final LocalAuthentication auth = LocalAuthentication();
  final Map payload;

  SessionRequestLogic(this.payload);

  @override
  void onInit() {
    super.onInit();
    state.requestPayload = payload;
  }

  requestApprove() async {

    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate',
        options: const AuthenticationOptions(useErrorDialogs: false)
    );

    if (!didAuthenticate) {
      return;
    }

    // var wallet = Get.find<CoinbitAppController>().state.selectedAccount?["available_wallets"].firstWhere((e) => e["namespace"] == state.requestPayload?["chainId"]);
    // var credentials = EthPrivateKey.fromHex(wallet["wallet_address"]);
    var message = state.requestPayload?["request"]["params"].toString().split(",")[0].substring(1);

    // var rng = Random.secure();
    // EthPrivateKey credentials = EthPrivateKey.createRandom(rng);

    Wallet wallet = Wallet.fromJson('{"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"497121f7a67c01b14473d2fcdf0f87ce"},"ciphertext":"e7ac37d80e57b88a5f5a4bf120944684991b60973afe3ed25775087b9b7f762d14","kdf":"scrypt","kdfparams":{"dklen":32,"n":8192,"r":8,"p":1,"salt":"ade43b2a44850860e0397122b19af77c095fbfd3c7014d99b5b296a30847a66e"},"mac":"aafb2bb1e0e3a3d5196b149b4d16171b3eeb5577bee5da81ad77cd243678d274"},"id":"9cbd230f-49a6-47c2-a324-be04c6f3cb06","version":3}', "explain alley prosper short despair glide truck december describe credit pumpkin morning");
    Credentials credentials = wallet.privateKey;

    var result = await credentials.signPersonalMessage(hexToBytes(message!));
    LoadingApp.show();
    try {
      walletConnectV2Channel.invokeMethod('sessionRequestApprove', {
        "requestId": state.requestPayload?["request"]["id"],
        "sessionTopic": state.requestPayload?["topic"],
        "signed": "0x${bytesToHex(result)}",
      });
      LoadingApp.hide();
      Get.back();
    } on PlatformException catch (e) {
      LoadingApp.show();
      Get.snackbar("Oppss", e.message!, backgroundColor: Colors.redAccent);
    }
  }
}
