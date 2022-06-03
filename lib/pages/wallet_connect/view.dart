import 'package:coinbit/main.dart';
import 'package:coinbit/pages/session_proposal/view.dart';
import 'package:coinbit/pages/session_request/view.dart';
import 'package:coinbit/widgets/gradient_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'logic.dart';

class WalletConnectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletConnectLogic>(
      init: WalletConnectLogic(),
      builder: (logic) {
        return SafeArea(
            child: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const GradientText(
                  "WalletConnect",
                  gradient: LinearGradient(colors: [
                    Color(0XFF7928ca),
                    Color(0XFF0070f3),
                  ]),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  height: 20,
                  color: Colors.grey,
                  thickness: 0.2,
                ),
                const SizedBox(
                  height: 20,
                ),
                GetBuilder<CoinbitAppController>(
                  builder: (mainAppLogic) {
                    return mainAppLogic.state.isConnectionAvailable ? Expanded(child: Column(
                      children: [
                        Expanded(
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            color: Colors.grey,
                            strokeWidth: 2,
                            radius: const Radius.circular(12),
                            padding: const EdgeInsets.all(6),
                            child: !logic.state.showScanner ? Container(
                              width: double.infinity,
                              child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/qr-icon.png", height: 100),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              )),
                                          onPressed: () {
                                            logic.state.showScanner = true;
                                            logic.update();
                                          },
                                          child: const Text("Scan QR Code"))
                                    ],
                                  )),
                            ) : QRView(
                              key: logic.qrKey,
                              onQRViewCreated: (controller) {
                                logic.qrViewController = controller;
                                logic.qrViewController?.scannedDataStream.listen(logic.onScannedQr);
                                logic.update();
                              },
                              overlay: QrScannerOverlayShape(
                                  borderColor: Colors.red,
                                  borderRadius: 10,
                                  borderLength: 30,
                                  borderWidth: 10,
                                  cutOutSize: 300),
                              onPermissionSet: (ctrl, p) {
                                if (!p) {
                                  Get.snackbar("Oppsss..", "Please enable for permission camera");
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text("or use walletconnect uri",
                              textAlign: TextAlign.center),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: logic.inputWalletConnectUri,
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(14)),
                            hintText: 'e.g. wc:a281567bb3e4...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white24,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(14),
                                          bottomRight: Radius.circular(14)),
                                    )),
                                onPressed: () {
                                  logic.pair(logic.inputWalletConnectUri.text);
                                },
                                child: const Text("Connect"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    )) : Center(
                      child: Column(
                        children: [
                          Text("Websocket Not Connected", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                logic.connectWebsocket();
                              },
                              child: Text("Connect")
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
      },
    );
  }
}
