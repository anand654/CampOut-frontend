import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

abstract class ILoadingWindow {
  Future<void> loadingWindow(String msg);
  void showSnackBar(String message, bool success);
}

class LoadingWindow implements ILoadingWindow {
  LoadingWindow({@required this.context});
  BuildContext context;
  Future<void> loadingWindow(String msg) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animation/trail-loading.json',
                    width: 100, height: 100),
                Text(
                  msg,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          );
        },
        barrierDismissible: false);
  }

  @override
  void showSnackBar(String message, bool success) {
    ScaffoldMessengerState _scaffoldMessanger = ScaffoldMessenger.of(context);
    _scaffoldMessanger.showSnackBar(
      SnackBar(
        content: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF9DB6CB),
              borderRadius: BorderRadius.circular(22),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 14, right: 10),
              horizontalTitleGap: 0,
              leading: success
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
              title: Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
                maxLines: 2,
                textAlign: TextAlign.left,
              ),
              trailing: IconButton(
                onPressed: () => _scaffoldMessanger.removeCurrentSnackBar(),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            )),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
