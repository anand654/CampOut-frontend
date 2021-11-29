import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:me_and_my_tent_client/cache/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache/local_store_contract.dart';

class Composition {
  static SharedPreferences sharedPreferences;
  static ILocalStore localStore;
  static Client httpClient;
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>();
  Stream get myStream => _controller.stream;

  static initialise() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStorage(sharedPreferences);
    httpClient = Client();
  }

  Future<void> connectivityCheck() async {
    _connectivity.onConnectivityChanged.listen((result) async {
      await _checkStatus(result);
    });
  }

  Future<void> _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      if (result == ConnectivityResult.none) {
        isOnline = false;
      } else {
        final res = await InternetAddress.lookup('google.com');
        isOnline = res.isNotEmpty && res[0].rawAddress.isNotEmpty;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add(isOnline);
  }

  void disposeStream() => _controller.close();
}
