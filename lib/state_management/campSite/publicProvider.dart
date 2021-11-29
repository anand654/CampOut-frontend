import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../composition.dart';
import '../../models/camp/camp_prev.dart';
import '../../models/camp/camp_reviews.dart';
import '../../models/camp/camp_site.dart';
import '../../models/search/markers_cluster.dart';
import '../../models/search/recent_search.dart';
import '../../models/stories.dart';
import '../../services/helpers/helpers.dart';
import '../../services/helpers/ihelpers.dart';
import '../../services/httpClient/http_PublicClient.dart';
import '../../services/httpClient/http_client_contract.dart';
import '../../services/webview/webpreview.dart';

class PublicProvider extends ChangeNotifier {
  // imports and instances
  final IPublicClient _publicClient = PublicClient(
    Composition.httpClient,
  );
  final IHelpers _helpers = Helpers();

// variables to store data or initializations
  final int _limit = 3;
  String _paginateId;
  bool _hasNext = true;
  bool _fnTriggered = false;
  List<CampSitePrev> _searchedResult = [];
  List<RecentSearch> _recentSearches = [];
  List<MarkerCluster> _marker = [];
  LatLng _mapTarget;
  String _searchKeyword = '';
  String _campType = 'camptype';
  List<Stories> _stories = [];
  List<PreviewInfo> _webpreview = [];
  List<CampSitePrev> _mostFamousSite = [];
  List<CampSite> _cachedcampSites = [];
  bool _isFavorite = false;
  List<CampReviews> _campReviews = [];
  List<String> _autoComplete = [];
  CampSitePrev _currentCampSitePrev;
  CampSite _currentCampSite;

// getters
  List<CampSitePrev> get searchedResult => _searchedResult;
  List<RecentSearch> get recentSearches => _recentSearches;
  List<MarkerCluster> get marker => _marker;
  LatLng get mapTarget => _mapTarget;
  String get searchKeyword => _searchKeyword;
  List<Stories> get stories => _stories;
  List<PreviewInfo> get webPreview => _webpreview;
  List<CampSitePrev> get mostFamousSite => _mostFamousSite;
  bool get isFavorite => _isFavorite;
  bool get hasNext => _hasNext;
  bool get fnTriggered => _fnTriggered;
  List<CampReviews> get campReviews => _campReviews;
  List<String> get autoComplete => _autoComplete;
  CampSitePrev get currentCampSitePrev => _currentCampSitePrev;
  CampSite get currentCampSite => _currentCampSite;

// setters
  set searchedResultSet(List<CampSitePrev> data) {
    _searchedResult = List.from(_searchedResult)..addAll(data);
    notifyListeners();
  }

  set recentSearchesSet(String data) {
    if (!_recentSearches.any((recent) => recent.place == data)) {
      _recentSearches.insert(
        0,
        RecentSearch(place: data, city: 'Karnataka'),
      );
    }
    if (_recentSearches.length > 5) _recentSearches.removeAt(5);
  }

  set markerSet(List<MarkerCluster> data) {
    _marker = List.from(_marker)..addAll(data);
    notifyListeners();
  }

  set searchKeywordSet(String data) {
    _searchKeyword = data;
    _searchedResult = [];
  }

  set campTypeSet(String data) {
    _campType = data.replaceAll(' ', '').toLowerCase();
  }

  set storiesSet(List<Stories> data) {
    _stories = List.from(_stories)..addAll(data);
  }

  set webPreviewSet(List<PreviewInfo> data) {
    _webpreview = List.from(_webpreview)..addAll(data);
  }

  set mostFamousSiteSet(List<CampSitePrev> data) {
    _mostFamousSite = List.from(_mostFamousSite)..addAll(data);
  }

  set cachedCampSiteSet(CampSite data) {
    _currentCampSite = data;
    _isFavorite = data.isFavorite;
  }

  set cacheCampSite(CampSite data) {
    _currentCampSite = data;
    _isFavorite = data.isFavorite;
    _cachedcampSites = List.from(_cachedcampSites)..add(data);
  }

  set fnTriggeredSet(bool data) {
    _fnTriggered = data;
    notifyListeners();
  }

  set campReviewsSet(List<CampReviews> data) {
    _campReviews = List.from(_campReviews)..addAll(data);
    notifyListeners();
  }

  set autoCompleteSet(List<String> data) {
    _autoComplete = [...data];
    notifyListeners();
  }

// middlewares
  void toggleFavorite(String id) {
    final camp = _cachedcampSites.firstWhere(
      (element) => element.campId == id,
      orElse: () => null,
    );
    if (camp != null) {
      camp.isFavorite = !camp.isFavorite;
      _isFavorite = !isFavorite;
      notifyListeners();
    }
    return;
  }

  int getIndexOfMarker(String markerid) {
    return _searchedResult
        .indexWhere((campprev) => campprev.campPrevId == markerid);
  }

  set setcurrentCampSitePrev(CampSitePrev data) {
    _currentCampSitePrev = data;
  }

  Future<Position> userPosition() async {
    try {
      final Position _pos = await _helpers.determinePosition();
      if (_mapTarget == null)
        _mapTarget = LatLng(_pos.latitude, _pos.longitude);
      return _pos;
    } catch (err) {
      return null;
    }
  }

  Future<String> getLocality() async {
    try {
      final Position _pos = await userPosition();
      if (_pos != null) {
        List<Placemark> _placemarks =
            await placemarkFromCoordinates(_pos.latitude, _pos.longitude);
        return _placemarks[0].locality ?? 'error';
      }
      return 'error';
    } catch (err) {
      return 'error';
    }
  }

  bool _paginate(int list, String id) {
    if (list == 0) {
      _hasNext = false;
      fnTriggeredSet = false;
      return false;
    }
    if (list < _limit) _hasNext = false;
    _paginateId = id;
    return true;
  }

  void _initialSearchState() {
    _searchedResult.clear();
    _cachedcampSites.clear();
    _marker.clear();
    _paginateId = 'paginateid';
  }

  void _initialReviewState() {
    _campReviews.clear();
    _paginateId = 'paginateid';
  }

//api calls
  Future fetchStories() async {
    if (stories.length != 0) {
      if (webPreview.length != 0) return;
    }
    final url = _helpers.urlParser('stories');
    final res = await _publicClient.get(url);
    if (res.status == Status.failure) {
      return;
    }
    storiesSet = _helpers.jsontoStories(res.body);
    webPreviewSet = await _helpers.urlPreview(res.body);
    return;
  }

  Future<List<CampSitePrev>> fetchMostFamousSites() async {
    if (_mostFamousSite.length != 0) {
      return _mostFamousSite;
    }
    final String _place = await getLocality();
    if (_place == 'error') {
      return Future.error('error getting the user location');
    }
    final Uri url = _helpers.urlParser('camp/mostfamous/$_place');
    final res = await _publicClient.get(url);
    if (res.status == Status.failure) {
      return Future.error('fetchmostfamous is a failure');
    }
    final List<CampSitePrev> mfcamps = _helpers.jsontoCampPrev(res.body);
    mostFamousSiteSet = mfcamps;
    return mfcamps;
  }

  Future fetchCampPrevBySearch(bool initial) async {
    if (initial) {
      _initialSearchState();
      _hasNext = true;
    }
    if (_fnTriggered) return;
    initial ? _fnTriggered = true : fnTriggeredSet = true;
    Uri _url;
    if (_campType != 'camptype') {
      _url = _helpers.urlParser(
          'camp/aroundme?paginateid=$_paginateId&place=$_searchKeyword&camptype=$_campType');
    } else {
      _url = _helpers.urlParser(
          'camp/search?paginateid=$_paginateId&place=$_searchKeyword');
    }
    final res = await _publicClient.get(_url);
    if (res.status == Status.failure) {
      fnTriggeredSet = false;
      return;
    }
    final List<CampSitePrev> _list = _helpers.jsontoCampPrev(res.body);
    if (!_paginate(_list.length, _list.isEmpty ? '' : _list.last.campPrevId))
      return;
    markerSet = _helpers.jsontoMarkerCluster(res.body);
    searchedResultSet = _list;
    fnTriggeredSet = false;
    return;
  }

  Future<void> fetchCampSite(String campId) async {
    CampSite _campSite;
    if (_cachedcampSites.length != 0) {
      _campSite = _cachedcampSites.firstWhere((camps) => camps.campId == campId,
          orElse: () => null);
    }
    if (_campSite != null) {
      cachedCampSiteSet = _campSite;
      return;
    }
    final Uri url = _helpers.urlParser('camp/campsite/$campId');
    final res = await _publicClient.get(url);
    if (res.status == Status.failure) {
      return Future.error('cant fetch campsite of id $campId');
    }
    _campSite = _helpers.jsontoCampsite(res.body);
    cacheCampSite = _campSite;
  }

  Future<void> fetchCampReviews(bool initial) async {
    if (initial) {
      if (_campReviews.isNotEmpty) {
        final _cached =
            _campReviews.first.campPrevId == _currentCampSitePrev.campPrevId;
        if (_cached) {
          return;
        }
      }
      _initialReviewState();
      _hasNext = true;
    }
    if (_fnTriggered) return;
    initial ? _fnTriggered = true : fnTriggeredSet = true;
    final Uri url = _helpers.urlParser(
        'review/camp?paginateid=$_paginateId&campprevid=${_currentCampSitePrev.campPrevId}');
    final res = await _publicClient.get(url);
    if (res.status == Status.failure) {
      fnTriggeredSet = false;
      return;
    }
    final List<CampReviews> _list = _helpers.jsontoCampReviews(res.body);
    if (!_paginate(_list.length, _list.isEmpty ? '' : _list.last.id)) return;
    campReviewsSet = _list;
    fnTriggeredSet = false;
    return;
  }
}
