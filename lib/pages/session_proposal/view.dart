import 'package:coinbit/main.dart';
import 'package:coinbit/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SessionProposalPage extends StatelessWidget {

  final Map proposal;

  const SessionProposalPage({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionProposalLogic>(
      init: SessionProposalLogic(proposal),
      builder: (logic) {
        return WillPopScope(
            child: SafeArea(
                child: Scaffold(
                  body: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Center(
                          child: Text(
                            "Session Proposal",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          color: Colors.grey,
                          thickness: 0.2,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Image.network(
                                        logic.state.sessionPropose?['icons'].length > 0 ? logic.state.sessionPropose!['icons'][0] : 'https://react-app.walletconnect.com/favicon.ico',
                                        height: 35),
                                    title: Text(logic.state.sessionPropose?['name']),
                                    subtitle: Text(
                                      logic.state.sessionPropose?['url'],
                                      style: const TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  permissions(logic),
                                  const SizedBox(
                                    height: 20,
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
                                              )
                                          ),
                                          onPressed: () {
                                            logic.sessionReject();
                                          }, child: const Text("Reject", style: TextStyle(color: Colors.red))
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(0XFF6ceea7).withOpacity(0.4),
                                              // side: BorderSide(width: 1, color: Color(0XFFe84442)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              )
                                          ),
                                          onPressed: () {
                                            logic.sessionApprove();
                                          },
                                          child: const Text("Approve", style: TextStyle(color: Color(0XFF6ceea7)))
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                )),
            onWillPop: () {
              logic.sessionReject();
              return Future.value(true);
            }
        );
      },
    );
  }

  Widget permissions(SessionProposalLogic logic) {
    List<Widget> lists = [];
    logic.state.sessionPropose?['requiredNamespaces'].forEach((netName, requiredNamespace) {
      lists.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Review $netName permissions",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 20,
          ),
          Column(
            children:
            requiredNamespace['chains'].map<Widget>((chain) {
              var walletNetwork = Get.find<CoinbitAppController>().state.networks.firstWhere((element) => element['namespace'] == chain);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                constraints: BoxConstraints(minWidth: double.infinity),
                decoration: BoxDecoration(
                    color: Color(walletNetwork['base_color']).withOpacity(0.25),
                    border: Border.all(
                        color: Color(walletNetwork['base_color'])
                            .withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 12),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(walletNetwork["name"],
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Methods",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(requiredNamespace['methods'].join(', '),
                        style:
                        const TextStyle(fontSize: 14)),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("Events",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        requiredNamespace['events'].length > 0
                            ? requiredNamespace['events'].join(', ')
                            : "-",
                        style:
                        const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }).toList(),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Text("Choose $netName accounts",
          //     style: const TextStyle(
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //     )),
          // GetBuilder<CoinbitAppController>(
          //   builder: (mainAppLogic) {
          //     return Column(
          //       children:
          //       mainAppLogic.state.accounts.map((account) {
          //         var exist = logic.state.approvedAccounts?[netName].firstWhere((approvedAccount) => approvedAccount == account["id"], orElse: () => null) != null;
          //         return CheckboxListTile(
          //             value: exist,
          //             onChanged: (value) {
          //               logic.onChangeAccount(exist, netName, account);
          //             },
          //             title: Text(
          //               "${account['name']}",
          //               style: const TextStyle(fontSize: 14),
          //             ));
          //       }).toList(),
          //     );
          //   },
          // ),
          const Divider(
            height: 20,
            color: Colors.grey,
            thickness: 0.2,
          ),
        ],
      ));
    });
    return Column(
      children: lists,
    );
  }
}
