class RecentSearch {
  String place;
  String city;
  RecentSearch({
    this.place,
    this.city,
  });

  factory RecentSearch.fromJson(Map<String, dynamic> data) {
    return RecentSearch(
      place: data['place'] as String,
      city: data['city'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place': place,
      'city': city,
    };
  }
}
