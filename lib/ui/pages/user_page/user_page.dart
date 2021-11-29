import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../state_management/auth/authProvider.dart';
import '../../../ui/pages/user_page/signin.dart';
import '../../../ui/pages/user_page/user_info_page.dart';

class UserPage extends StatelessWidget {
  UserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SvgPicture.asset(
            'assets/svg/user_bg.svg',
            width: MediaQuery.of(context).size.width,
          ),
          Selector<AuthProvider, AuthState>(
            selector: (context, authProv) => authProv.authState,
            builder: (context, authState, _) {
              return authState == AuthState.signedIn
                  ? UserInfoPage()
                  : UserSignIn();
            },
          )
        ],
      ),
    );
  }
}
