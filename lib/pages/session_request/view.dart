import 'package:coinbit/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class SessionRequestPage extends StatelessWidget {

  final Map payload;

  const SessionRequestPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionRequestLogic>(
      init: SessionRequestLogic(payload),
      builder: (logic) {
        var network = Get.find<CoinbitAppController>().state.networks.firstWhere((element) => element["namespace"] == logic.state.requestPayload?["chainId"]);
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Constants.padding),
                color: Color(network['base_color'])
                    .withOpacity(0.25),
                border: Border.all(
                    color: Color(network['base_color'])
                        .withOpacity(0.4)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sign Message",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.network(
                            logic.state.requestPayload?["peerMetaData"]['icons']
                                .length >
                                0
                                ? logic.state
                                .requestPayload!["peerMetaData"]!['icons'][0]
                                : 'https://react-app.walletconnect.com/favicon.ico',
                            height: 35),
                        title: Text(
                          logic.state.requestPayload?["peerMetaData"]["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            logic.state.requestPayload?["peerMetaData"]['url'],
                            style: const TextStyle(color: Colors.blue)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              color: Colors.grey,
                              height: 40,
                            ),
                            const Text("Blockchains(s)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(network["name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: Colors.grey)),
                            const Divider(
                              color: Colors.grey,
                              height: 40,
                            ),
                            const Text("Request ID",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(logic.state.requestPayload!["request"]["id"].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: Colors.grey)),
                            const Divider(
                              color: Colors.grey,
                              height: 40,
                            ),
                            const Text("Method",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(logic.state.requestPayload!["request"]["method"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: Colors.grey)),
                            const Divider(
                              color: Colors.grey,
                              height: 40,
                            ),
                            const Text("Params",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(logic.state.requestPayload?["request"]["params"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w200, color: Colors.grey, fontSize: 12)),
                            const Divider(
                              color: Colors.grey,
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0XFFe84442).withOpacity(0.4),
                                        // side: BorderSide(width: 1, color: Color(0XFFe84442)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        )),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("Reject",
                                        style: TextStyle(color: Colors.red))),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0XFF6ceea7).withOpacity(0.4),
                                        // side: BorderSide(width: 1, color: Color(0XFFe84442)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        )),
                                    onPressed: () {
                                      logic.requestApprove();
                                    },
                                    child: const Text("Approve",
                                        style: TextStyle(color: Color(0XFF6ceea7)))),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
