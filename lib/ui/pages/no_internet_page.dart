import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: SvgPicture.asset('assets/svg/no_internet.svg'),
              ),
              Text(
                'Something went wrong',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: Text(
                  'Make sure wifi or cellular data is turned on and then try again',
                  style: Theme.of(context).textTheme.subtitle2,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
