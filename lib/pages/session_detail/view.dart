import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SessionDetailPage extends StatelessWidget {
  final logic = Get.put(SessionDetailLogic());
  final state = Get.find<SessionDetailLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
