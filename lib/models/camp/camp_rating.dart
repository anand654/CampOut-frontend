class CampRating {
  String id;
  String campPrevId;
  double userRating;
  int noofRatings;
  int noofReviews;

  CampRating({
    this.id,
    this.campPrevId,
    this.userRating,
    this.noofRatings,
    this.noofReviews,
  });

  factory CampRating.fromJson(Map<String, dynamic> data) {
    return CampRating(
      id: data['_id'],
      campPrevId: data['campPrevId'],
      userRating: data['userRating'],
      noofRatings: data['noofRatings'],
      noofReviews: data['noofReviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campPrevId': campPrevId,
      'userRating': userRating,
      'noofRatings': noofRatings,
      'noofReviews': noofReviews
    };
  }
}
