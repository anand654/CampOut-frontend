import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../../../constants/constants.dart';
import '../../../state_management/auth/authProvider.dart';

class WelcomeTag extends StatefulWidget {
  const WelcomeTag({Key key}) : super(key: key);

  @override
  State<WelcomeTag> createState() => _WelcomeTagState();
}

class _WelcomeTagState extends State<WelcomeTag> {
  Future _authState;

  @override
  void didChangeDependencies() {
    _authState = _initialAuthState();
    super.didChangeDependencies();
  }

  Future _initialAuthState() async {
    await Provider.of<AuthProvider>(context, listen: false).initialAuthState();
  }

  @override
  Widget build(BuildContext context) {
    final _authProv = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      child: FutureBuilder(
        future: _authState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Selector<AuthProvider, AuthState>(
              selector: (context, authProv) => authProv.authState,
              builder: (context, _state, _) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'welcome',
                          style: TextStyle(fontSize: 12, height: 1),
                        ),
                        Text(
                          _state == AuthState.signedIn
                              ? _authProv.user.name
                              : 'welcome',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BlurHash(
                          hash: MConstants.blurHash,
                          imageFit: BoxFit.cover,
                          curve: Curves.easeInOut,
                          image: _state == AuthState.signedIn
                              ? _authProv.user.profileImg
                              : null,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
