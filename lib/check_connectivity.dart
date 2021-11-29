import 'package:flutter/material.dart';
import 'package:me_and_my_tent_client/composition.dart';
import 'package:me_and_my_tent_client/ui/pages/initial_page.dart';
import 'package:me_and_my_tent_client/ui/pages/no_internet_page.dart';

class CheckConnectivity extends StatefulWidget {
  const CheckConnectivity({Key key}) : super(key: key);

  @override
  _CheckConnectivityState createState() => _CheckConnectivityState();
}

class _CheckConnectivityState extends State<CheckConnectivity> {
  final composition = Composition();
  @override
  void initState() {
    super.initState();
    composition.connectivityCheck();
  }

  @override
  void dispose() {
    composition.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: composition.myStream,
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return NoInternetPage();
        }
        return InitialPage();
      },
    );
  }
}
