import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/constants.dart';
import '../../../models/stories.dart';
import '../../../services/webview/webpreview.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../global_widgets/loading_msg.dart';

class StoriesView extends StatefulWidget {
  const StoriesView({Key key}) : super(key: key);

  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  Future _fetchStories;
  @override
  void initState() {
    super.initState();
    _fetchStories = loadStories();
  }

  Future loadStories() async {
    await Provider.of<PublicProvider>(context, listen: false).fetchStories();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: FutureBuilder(
        future: _fetchStories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return LoadingMessage();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final _publicProvider =
                Provider.of<PublicProvider>(context, listen: false);
            final int _stories = _publicProvider.stories.length;
            final int _webPreview = _publicProvider.webPreview.length;
            if (_stories == 0 || _webPreview == 0) {
              return Center(
                child: LoadingMessage(),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return StoriesCard(
                  stories: _publicProvider.stories[index],
                  webpreview: _publicProvider.webPreview[index],
                );
              },
              itemCount: _stories < _webPreview ? _stories : _webPreview,
            );
          }
          return LoadingMessage();
        },
      ),
    );
  }
}

class StoriesCard extends StatelessWidget {
  const StoriesCard({
    Key key,
    @required this.stories,
    @required this.webpreview,
  }) : super(key: key);
  final Stories stories;
  final PreviewInfo webpreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: InkWell(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              decoration: BoxDecoration(
                color: Color(0xFFF8FCFF),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BlurHash(
                      hash: MConstants.blurHash,
                      imageFit: BoxFit.cover,
                      curve: Curves.easeInOut,
                      image: webpreview.previewImg,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 16, top: 8, bottom: 8),
                  child: Text(
                    webpreview.title ?? '',
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(right: 15, bottom: 8, left: 20),
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BlurHash(
                          hash: MConstants.blurHash,
                          imageFit: BoxFit.cover,
                          curve: Curves.easeInOut,
                          image: stories.authorImg,
                        ),
                      ),
                    ),
                    Text(
                      stories.author ?? '',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _openStory(stories.url),
      ),
    );
  }

  Future _openStory(String url) async {
    try {
      launch(url);
    } catch (e) {
      throw 'could not launch $e';
    }
  }
}
