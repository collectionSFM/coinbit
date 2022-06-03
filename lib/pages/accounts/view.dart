import 'package:coinbit/main.dart';
import 'package:coinbit/widgets/elipsis_center_text.dart';
import 'package:coinbit/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class AccountPage extends StatelessWidget {
  final logic = Get.put(AccountLogic());
  final state = Get.find<AccountLogic>().state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const GradientText(
                  "Accounts",
                  gradient: LinearGradient(colors: [
                    Color(0XFF7928ca),
                    Color(0XFF0070f3),
                  ]),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                GetBuilder<CoinbitAppController>(
                  builder: (mainAppLogic) {
                    return DropdownButton<Map>(
                      value: mainAppLogic.state.selectedAccount,
                      elevation: 16,
                      dropdownColor: Colors.black,
                      underline: Container(
                        height: 0,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (Map? newValue) {
                        mainAppLogic.state.selectedAccount = newValue;
                        mainAppLogic.update();
                      },
                      items: mainAppLogic.state.accounts
                          .map<DropdownMenuItem<Map>>((dynamic value) {
                        return DropdownMenuItem<Map>(
                          value: value,
                          child: Text(value["name"]),
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            ),
            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 0.2,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Testnets",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        ElevatedButton(
                          onPressed: () {
                            logic.createWallet();
                          },
                          child: Text("Create Wallet"),
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0XFFe84442).withOpacity(0.4),
                              // side: BorderSide(width: 1, color: Color(0XFFe84442)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GetBuilder<CoinbitAppController>(
                      builder: (mainAppLogic) {
                        return Column(
                          children: mainAppLogic
                              .state.selectedAccount?['available_wallets']
                              .map<Widget>((wallet) {
                            var walletNetwork = mainAppLogic.state.networks
                                .firstWhere((element) {
                              return element['namespace'] ==
                                  wallet['namespace'];
                            });
                            return Container(
                              // padding: const EdgeInsets.symmetric(
                              //     vertical: 12, horizontal: 20),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Color(walletNetwork['base_color'])
                                      .withOpacity(0.25),
                                  border: Border.all(
                                      color: Color(walletNetwork['base_color'])
                                          .withOpacity(0.4))),
                              child: ListTile(
                                leading: Image.network(walletNetwork['logo'],
                                    height: 35),
                                title: Text(walletNetwork['name'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                subtitle: ElipsisCenterText(
                                    text: wallet['wallet_address'],
                                    textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300)),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
