import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../ui/widgets/home_page_widgets/welcome_tag.dart';

class HomePageDeco extends StatelessWidget {
  const HomePageDeco({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/svg/introduction.svg',
            width: double.infinity,
          ),
          Column(
            children: [
              WelcomeTag(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '   Let’s',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: Color(0xFFCCE0FF), fontSize: 40),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'find some beautiful place to',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        color: Color(0xFFCCE0FF),
                      ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'get lost    ',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: Color(0xFFCCE0FF), fontSize: 40),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          )
        ],
      ),
    );
  }
}
