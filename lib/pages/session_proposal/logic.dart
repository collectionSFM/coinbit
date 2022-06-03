import 'dart:convert';

import 'package:coinbit/main.dart';
import 'package:coinbit/shares/events.dart';
import 'package:coinbit/shares/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

import 'state.dart';

class SessionProposalLogic extends GetxController {
  final SessionProposalState state = SessionProposalState();
  static const walletConnectV2Channel = MethodChannel('walletconnectv2');
  final LocalAuthentication auth = LocalAuthentication();
  final Map proposal;
  SessionProposalLogic(this.proposal);


  @override
  void onInit() {
    super.onInit();
    state.sessionPropose = proposal;

    state.approvedAccounts = {};
    state.sessionPropose?['requiredNamespaces'].forEach((key, requiredNamespace) {
      state.approvedAccounts?.addAll({
        key : []
      });
    });

    Get.find<CoinbitAppController>().eventBus.on<OnSessionSettled>().listen((event) {
      onSessionSettleResponse(event.payload);
    });
  }

  onSessionSettleResponse(payload) {
    Get.back();
    Get.find<CoinbitAppController>().activeIndex = 0;
    update();
  }

  sessionReject() {
    try {
      walletConnectV2Channel.invokeMethod('sessionRejection', {
        "publicKey": state.sessionPropose?["proposerPublicKey"],
        "rejectionReason": "Closed",
        "rejectionCode": 2234
      });
      Get.back();
    } on PlatformException catch (e) {
      Get.snackbar("Oppss", e.message!, backgroundColor: Colors.redAccent);
    }
  }

  sessionApprove() async {

    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate',
        options: const AuthenticationOptions(useErrorDialogs: false)
    );

    if (!didAuthenticate) {
      return;
    }

    LoadingApp.show();

    try {

      var sessionNamespaces = {};
      state.sessionPropose?["requiredNamespaces"].forEach((namespaceKey, requiredNamespace) {
        var accounts = [];
        for (var chain in requiredNamespace["chains"]) {
          var walletAddress = Get.find<CoinbitAppController>().state.selectedAccount?["available_wallets"].firstWhere((availableWallet) {
            return availableWallet["namespace"] == chain;
          });
          accounts.add("$chain:${walletAddress['wallet_address']}");
        }
        sessionNamespaces.addAll({
          namespaceKey: {
            "accounts": accounts, 
            "methods": requiredNamespace["methods"],
            "events": requiredNamespace["events"],
          }
        });
      });

      await walletConnectV2Channel.invokeMethod('sessionApproval', {
        "proposerPublicKey": state.sessionPropose?["proposerPublicKey"],
        "sessionNamespaces": sessionNamespaces,
      });

    } on PlatformException catch (e) {
      LoadingApp.hide();
      Get.snackbar("Oppss", e.message!, backgroundColor: Colors.redAccent);
    }
  }

  onChangeAccount(exist, netName, account) {
    if (exist) {
      state.approvedAccounts?[netName].remove(account["id"]);
    } else {
      state.approvedAccounts?[netName].add(account["id"]);
    }
    update();
  }
}
