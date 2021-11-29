import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../../../../constants/constants.dart';
import '../../../../state_management/campSite/publicProvider.dart';

class DescImageShow extends StatelessWidget {
  const DescImageShow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _imageUrls =
        Provider.of<PublicProvider>(context, listen: false)
            .currentCampSite
            .imageUrls;
    return Container(
      child: PageView.builder(
        itemBuilder: (context, index) {
          return Container(
            child: BlurHash(
              hash: MConstants.blurHash,
              imageFit: BoxFit.cover,
              curve: Curves.easeInOut,
              image: _imageUrls[index],
            ),
          );
        },
        itemCount: _imageUrls.length,
      ),
    );
  }
}
