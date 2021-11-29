import 'package:flutter/material.dart';

class AlertWindow extends StatelessWidget {
  const AlertWindow({
    Key key,
    @required this.content,
    this.isLogin = false,
    @required this.deletePressed,
    @required this.cancelPressed,
  }) : super(key: key);
  final String content;
  final bool isLogin;
  final VoidCallback deletePressed;
  final VoidCallback cancelPressed;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
      child: Container(
        child: CustomPaint(
          painter: AlertWindowPainter(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                content,
                style: Theme.of(context).textTheme.headline3,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: deletePressed,
                    child: Text(
                      isLogin ? 'Login' : 'Delete',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).hoverColor),
                      elevation: MaterialStateProperty.all(0.0),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.only(top: 8, bottom: 8, left: 25, right: 25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    onPressed: cancelPressed,
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).hoverColor),
                      elevation: MaterialStateProperty.all(0.0),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.only(top: 8, bottom: 8, left: 25, right: 25),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertWindowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint()
      ..color = Color(0xFFEFF3F6)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawLine(Offset(width * 0.1, height * 0.2),
        Offset(width * 0.1, height * 0.8), paint);

    Path topPath = Path();
    topPath.moveTo(width * 0.25, height * 0.15);
    topPath.lineTo(width * 0.8, height * 0.15);
    topPath.quadraticBezierTo(
        width * 0.9, height * 0.15, width * 0.9, height * 0.3);
    canvas.drawPath(topPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
