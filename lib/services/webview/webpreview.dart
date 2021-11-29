import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:string_validator/string_validator.dart';
import 'package:collection/collection.dart';

class PreviewInfo {
  String title;
  String previewImg;

  PreviewInfo({
    this.title,
    this.previewImg,
  });
}

abstract class IWebPagePreview {
  Future<PreviewInfo> previewInfo(String url);
}

class WebPageInfo implements IWebPagePreview {
  @override
  Future<PreviewInfo> previewInfo(String url) async {
    if (!isURL(url)) {
      return null;
    }
    var response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      return Future.error('cant access webpage');
    }
    var document = parse(response.body);
    String title = _extractOGData(document, 'property', 'og:title');
    String previewImg = _extractOGData(document, 'property', 'og:image');
    return PreviewInfo(
      title: title,
      previewImg: previewImg,
    );
  }

  String _extractOGData(Document document, String attribute, String parameter) {
    String _value;
    var titleMetaTag = document.getElementsByTagName("meta").firstWhereOrNull(
          (meta) => meta.attributes[attribute] == parameter,
        );
    if (titleMetaTag != null) {
      _value = titleMetaTag.attributes['content'];
    }
    return _value;
  }
}
