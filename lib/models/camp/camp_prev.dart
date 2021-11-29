import 'package:me_and_my_tent_client/models/camp/camp_address.dart';

class CampSitePrev {
  String campPrevId;
  String campId;
  String userId;
  String campName;
  String price;
  String campType;
  CampAddress campAddress;
  String imageUrl;
  double rating;
  int noofRatings;
  int noofReviews;
  CampSitePrev(
      {this.campPrevId,
      this.campId,
      this.userId,
      this.campName,
      this.price,
      this.campType,
      this.campAddress,
      this.imageUrl,
      this.rating,
      this.noofRatings,
      this.noofReviews});

  factory CampSitePrev.fromJson(Map<String, dynamic> data) {
    return CampSitePrev(
      campPrevId: data['_id'] as String,
      campId: data['campId'] as String,
      userId: data['userId'] as String,
      campName: data['campName'] as String,
      price: data['price'] as String,
      campType: data['campType'] as String,
      campAddress: data['campAddress'] == null
          ? null
          : CampAddress.fromJson(data['campAddress'] as Map<String, dynamic>),
      imageUrl: data['imageUrl'] as String,
      rating: double.parse(data['rating'].toString()),
      noofRatings: data['noofRatings'] as int,
      noofReviews: data['noofReviews'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campName': campName,
      'price': price,
      'campType': campType,
      'campAddress': campAddress.toJson(),
      'imageUrl': imageUrl,
    };
  }
}
