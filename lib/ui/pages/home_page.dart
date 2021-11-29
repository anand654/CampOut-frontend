import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../ui/widgets/home_page_widgets/around_me.dart';
import '../../../ui/widgets/home_page_widgets/home_page_deco.dart';
import '../../../ui/widgets/home_page_widgets/most_famous_view.dart';
import '../../../ui/widgets/home_page_widgets/stories_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10),
              height: 30,
              decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(15)),
            ),
            HomePageDeco(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Text(
                'Around me',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            AroundMeIcons(),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              height: 14,
              decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(7)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 10, bottom: 10),
              child: Text(
                'Stories',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            StoriesView(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 10, bottom: 10),
              child: Text(
                'Most Famous',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            MostFamous(),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
