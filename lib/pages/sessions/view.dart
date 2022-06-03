import 'package:coinbit/widgets/elipsis_center_text.dart';
import 'package:coinbit/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SessionsPage extends StatelessWidget {
  final logic = Get.put(SessionsLogic());
  final state = Get.find<SessionsLogic>().state;

  @override
  Widget build(BuildContext context) {
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
              "Sessions",
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.sessions.map((session) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white)),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(14),
                        child: ListTile(
                          dense: false,
                          // contentPadding: EdgeInsets.zero,
                          title: Text(session['dapp_name']),
                          subtitle: ElipsisCenterText(
                              text: session['dapp_host'],
                              firstLengthText: 9,
                              lastLengthText: 10,
                              textStyle:
                                  const TextStyle(color: Colors.blueAccent)),
                          trailing: const Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
