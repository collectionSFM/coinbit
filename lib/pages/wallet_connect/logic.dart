import 'dart:convert';

import 'package:coinbit/main.dart';
import 'package:coinbit/pages/session_proposal/view.dart';
import 'package:coinbit/shares/events.dart';
import 'package:coinbit/shares/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'state.dart';

class WalletConnectLogic extends GetxController {

  final WalletConnectState state = WalletConnectState();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  TextEditingController inputWalletConnectUri = TextEditingController();

  Barcode ? result;

  QRViewController ? qrViewController;

  static const walletConnectV2Channel = MethodChannel('walletconnectv2');

  @override
  void onInit() {
    super.onInit();
    Get.find<CoinbitAppController>().eventBus.on<OnSessionProposal>().listen((event) {
      onSessionProposal(event.payload);
    });
  }

  pair(wcUri) async {
    try {
      walletConnectV2Channel.invokeMethod('pair', wcUri);
    } on PlatformException catch (e) {
      Get.snackbar("Oppss", e.message!, backgroundColor: Colors.redAccent);
    }
  }

  onSessionProposal(payload) {
    Get.to(() => SessionProposalPage(proposal: jsonDecode(payload)), fullscreenDialog: true);
  }

  onScannedQr(scannedData) async {
    state.showScanner = false;
    update();
    try {
      await pair(scannedData.code);
    } on PlatformException catch (e) {
      Get.snackbar("Oppss", e.message!, backgroundColor: Colors.redAccent);
    }
  }

  connectWebsocket() async {
    try {
      await walletConnectV2Channel.invokeMethod("connectWebsocket");
    } on PlatformException catch (e) {
      Get.snackbar("Oppss", e.message!, backgroundColor: Colors.redAccent);
    }
  }
}
