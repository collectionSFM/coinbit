import 'dart:convert';

import 'package:coinbit/pages/accounts/view.dart';
import 'package:coinbit/pages/pairings/view.dart';
import 'package:coinbit/pages/session_request/view.dart';
import 'package:coinbit/pages/sessions/view.dart';
import 'package:coinbit/pages/wallet_connect/view.dart';
import 'package:coinbit/shares/events.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  runApp(const CoinbitApp());
}

class CoinbitAppState {

  bool isConnectionAvailable = false;

  List accounts = [
    {
      "name": "Account 1",
      "id": 1,
      "available_wallets": [
        {
          "namespace": "eip155:42",
          "wallet_address": "0x4367455FfEeE29eefED4e172614694c5146fb48a"
        },
        {
          "namespace": "eip155:69",
          "wallet_address": "0xf5de760f2e916647fd766b4ad9e85ff943ce3a2b"
        },
        {
          "namespace": "eip155:80001",
          "wallet_address": "0x5A9D8a83fF2a032123954174280Af60B6fa32781"
        },
        {
          "namespace": "eip155:421611",
          "wallet_address": "0x682570add15588df8c3506eef2e737db29266de2"
        },
        {
          "namespace": "eip155:44787",
          "wallet_address": "0xdD5Cb02066fde415dda4f04EE53fBb652066afEE"
        },
        {
          "namespace": "solana:8E9rvCKLFQia2Y35HXjjpWzj8weVo44K",
          "wallet_address": "0xdD5Cb02066fde415dda4f04EE53fBb652066afEE"
        },
      ]
    },
    {
      "name": "Account 2",
      "id": 2,
      "available_wallets": [
        {
          "namespace": "eip155:42",
          "wallet_address": "0x4367455FfEeE29eefED4e172614694c5146fb48a"
        },
        {
          "namespace": "eip155:69",
          "wallet_address": "0xe16821547bb816ea3f25c67c15a634b104695a32"
        },
        {
          "namespace": "eip155:80001",
          "wallet_address": "0x5496858C1f2f469Eb6A6D378C332e7a4E1dc1B4D"
        },
        {
          "namespace": "eip155:421611",
          "wallet_address": "0x49d07a0e25d3d1881bfd1545bb9b12ac2eb00f12"
        },
        {
          "namespace": "eip155:44787",
          "wallet_address": "0x3a20c11fa54dfbb73f907e3953684a5d93e719a7"
        },
        {
          "namespace": "solana:8E9rvCKLFQia2Y35HXjjpWzj8weVo44K",
          "wallet_address": "0xdD5Cb02066fde415dda4f04EE53fBb652066afEE"
        },
      ]
    }
  ];

  Map ? selectedAccount;

  List networks = [
    {
      "namespace": "eip155:42",
      "name": "Ethereum",
      "logo": "https://react-wallet.walletconnect.com/chain-logos/eip155-1.png",
      "base_color": 0XFF637dea,
      "rpc_url": "https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
    },
    {
      "namespace": "eip155:69",
      "name": "Polygon Mumbay",
      "logo": "https://react-wallet.walletconnect.com/chain-logos/eip155-137.png",
      "base_color": 0XFF8564e6,
      "rpc_url": "https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
    },
    {
      "namespace": "eip155:80001",
      "name": "Optimism Kovan",
      "logo": "https://blockchain-api.xyz/logos/eip155:69.png",
      "base_color": 0XFFeb4222,
      "rpc_url": "https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
    },
    {
      "namespace": "eip155:421611",
      "name": "Arbitrum Rinkeby",
      "logo": "https://blockchain-api.xyz/logos/eip155:421611.png",
      "base_color": 0XFF2c374b,
      "rpc_url": "https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
    },
    {
      "namespace": "eip155:44787",
      "name": "Celo Alfajores",
      "logo": "https://blockchain-api.xyz/logos/eip155:44787.png",
      "base_color": 0XFF5dcc84,
      "rpc_url": "https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
    },
    {
      "namespace": "solana:8E9rvCKLFQia2Y35HXjjpWzj8weVo44K",
      "name": "Solana Devnet",
      "logo": "https://react-app.walletconnect.com/solana_logo.png",
      "base_color": 0XFF2d6d50,
      "rpc_url": "https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
    },
  ];
}

class CoinbitAppController extends GetxController {

  static const walletConnectV2Channel = MethodChannel('walletconnectv2');

  final CoinbitAppState state = CoinbitAppState();

  EventBus eventBus = EventBus();

  int activeIndex = 0;

  List buttonNavigationViews = [
    AccountPage(),
    SessionsPage(),
    WalletConnectPage(),
    PairingsPage(),
    PairingsPage(),
  ];

  @override
  void onInit() {
    super.onInit();
    initWalletConnect();
    state.selectedAccount = state.accounts[0];
    walletConnectV2Channel.setMethodCallHandler((call) {
      switch(call.method) {
        case 'onSessionSettleResponse':
          eventBus.fire(OnSessionSettled(call.arguments));
          return Future.value(true);
        case 'onSessionProposal':
          eventBus.fire(OnSessionProposal(call.arguments));
          return Future.value(true);
        case 'onSessionDelete':
          eventBus.fire(OnSessionDeleted(call.arguments));
          return Future.value(true);
        case 'onConnectionStateChange':
          state.isConnectionAvailable = call.arguments;
          update();
          return Future.value(true);
        case 'onSessionRequest':
          showDialog(context: Get.context!, builder: (context) {
            return SessionRequestPage(payload: jsonDecode(call.arguments));
          });
          return Future.value(true);
        default:
          return Future.value(false);
      }
    });
  }

  initWalletConnect() {
    try {
      walletConnectV2Channel.invokeMethod('init', {
        "metadata": {
          "name" : "Coinbit",
          "description": "Test stockbit make wallet crypto by sam fajar muharram",
          "url": "https://stockbit.com",
          "icons": ["https://images.glints.com/unsafe/glints-dashboard.s3.amazonaws.com/company-logo/d1d54e81e498c955d8c60b4d979e3e12.jpg"]
        },
        "relayHost": "relay.walletconnect.com",
        "projectId": "ea85f4ca4336e3a86f2098c9906f0b05",
      });
    } on PlatformException catch(e) {
      Get.snackbar("Oppss", e.message!, backgroundColor: Colors.redAccent);
    }
  }
}

class CoinbitApp extends StatelessWidget {

  const CoinbitApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Coinbit',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0XFF111111),
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white
        )
      ),
      home: GetBuilder<CoinbitAppController>(
        init: CoinbitAppController(),
        builder: (logic) {
          return Scaffold(
            body: logic.buttonNavigationViews[logic.activeIndex],
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        logic.activeIndex = 0;
                        logic.update();
                      },
                      icon: Image.asset("assets/images/accounts-icon.png")
                  ),
                  IconButton(
                      onPressed: () {
                        logic.activeIndex = 1;
                        logic.update();
                      },
                      icon: Image.asset("assets/images/sessions-icon.png")
                  ),
                  IconButton(
                      onPressed: () {
                        logic.activeIndex = 2;
                        logic.update();
                      },
                      icon: Image.asset("assets/images/wallet-connect-logo.png")
                  ),
                  IconButton(
                      onPressed: () {
                        logic.activeIndex = 3;
                        logic.update();
                      },
                      icon: Image.asset("assets/images/pairings-icon.png")
                  ),
                  IconButton(
                      onPressed: () {
                        logic.activeIndex = 4;
                        logic.update();
                      },
                      icon: Image.asset("assets/images/settings-icon.png")
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
