import 'dart:convert';

class CampReviews {
  String id;
  String campPrevId;
  String userId;
  String reviewerName;
  String reviewedDate;
  String review;
  CampReviews({
    this.id,
    this.campPrevId,
    this.userId,
    this.reviewerName,
    this.reviewedDate,
    this.review,
  });

  factory CampReviews.fromJson(Map<String, dynamic> data) {
    return CampReviews(
      id: data['_id'] as String,
      campPrevId: data['campPrevId'] as String,
      userId: data['userId'] as String,
      reviewerName: data['reviewerName'] as String,
      reviewedDate: data['reviewedDate'] as String,
      review: data['review'] as String,
    );
  }

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() {
    return {
      'campPrevId': campPrevId,
      'reviedDate': reviewedDate,
      'review': review,
    };
  }
}
