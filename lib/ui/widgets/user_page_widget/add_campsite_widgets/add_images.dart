import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../state_management/campSite/privateProvider.dart';

class AddImages extends StatelessWidget {
  AddImages({
    Key key,
  }) : super(key: key);
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    return Container(
      height: 400,
      child: Selector<PrivateProvider, List<String>>(
        selector: (context, privateProv) => privateProv.imageUrls,
        shouldRebuild: (pre, next) => pre != next,
        builder: (context, _list, _) {
          return PageView.builder(
            itemBuilder: (context, index) {
              if (index == _list.length) {
                return IconButton(
                  onPressed: () async {
                    final XFile image = await _picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 30);
                    if (image != null) _privateProv.addimgUrl = '${image.path}';
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 40,
                  ),
                );
              }
              return Container(
                child: Stack(
                  children: [
                    _list[index].startsWith('http')
                        ? SizedBox(
                            height: 400,
                            child: BlurHash(
                              hash: MConstants.blurHash,
                              imageFit: BoxFit.cover,
                              curve: Curves.easeInOut,
                              image: _list[index],
                            ),
                          )
                        : Image.file(
                            File(_list[index]),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 400,
                          ),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          _privateProv.removeimgUrl = index;
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: _list.length + 1 > 5 ? 5 : _list.length + 1,
          );
        },
      ),
    );
  }
}
