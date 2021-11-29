import 'package:me_and_my_tent_client/models/camp/contact_info.dart';

class CampSite {
  String campId;
  String about;
  ContactInfo contactInfo;
  List<String> imageUrls;
  List<String> accomadation;
  List<String> facility;
  bool isFavorite;
  CampSite({
    this.campId,
    this.about,
    this.contactInfo,
    this.imageUrls,
    this.accomadation,
    this.facility,
    this.isFavorite = false,
  });

  factory CampSite.fromJson(Map<String, dynamic> data) {
    return CampSite(
      campId: data['_id'] as String,
      about: data['about'] as String,
      contactInfo: data['contactInfo'] == null
          ? null
          : ContactInfo.fromJson(data['contactInfo'] as Map<String, dynamic>),
      imageUrls: data['imageUrls'].cast<String>(),
      accomadation: data['accomadation'].cast<String>(),
      facility: data['facility'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'about': about,
      'contactInfo': contactInfo.toJson(),
      'imageUrls': imageUrls,
      'accomadation': accomadation,
      'facility': facility,
    };
  }
}
