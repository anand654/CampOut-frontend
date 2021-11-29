import 'dart:math';

import 'package:flutter/material.dart';
import 'package:me_and_my_tent_client/constants/constants.dart';

class LoadingMessage extends StatelessWidget {
  LoadingMessage({Key key}) : super(key: key);
  final Random _random = Random();
  final List<String> _messages = MMessages.messages;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Center(
        child: Text(
          '"${_messages[_random.nextInt(_messages.length)]}"',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
