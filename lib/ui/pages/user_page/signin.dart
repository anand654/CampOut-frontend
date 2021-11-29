import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../state_management/auth/authProvider.dart';
import '../../../ui/widgets/global_widgets/loading_window.dart';

class UserSignIn extends StatelessWidget {
  const UserSignIn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Welcome',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(fontSize: 28, color: Color(0xFF9DB6CB)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'sign in to continue',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Color(0xFF9DB6CB)),
            ),
          ),
        ),
        Spacer(),
        SvgPicture.asset(
          'assets/svg/user_bg_tree.svg',
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(
          height: 100,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signIn();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/google.svg'),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Signin with google',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _facebookLogin(context),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFF1D3557),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/facebook.svg'),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Signin with facebook',
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          indent: 25,
          endIndent: 25,
          height: 40,
        ),
        Text(
          'By creating an account, you are agreeing',
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Color(0xFF9DB6CB),
              ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'to our ',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Color(0xFF9DB6CB),
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Terms and Conditions',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(0.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<void> _facebookLogin(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 2000));
    LoadingWindow(context: context).showSnackBar(
        'Can\'t sign in using facebook now, please try signing in with google',
        false);
  }
}
