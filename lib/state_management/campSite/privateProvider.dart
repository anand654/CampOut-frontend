import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:me_and_my_tent_client/composition.dart';
import 'package:me_and_my_tent_client/models/camp/camp_address.dart';
import 'package:me_and_my_tent_client/models/camp/camp_prev.dart';
import 'package:me_and_my_tent_client/models/camp/camp_reviews.dart';
import 'package:me_and_my_tent_client/models/camp/camp_site.dart';
import 'package:me_and_my_tent_client/models/camp/contact_info.dart';
import 'package:me_and_my_tent_client/services/helpers/helpers.dart';
import 'package:me_and_my_tent_client/services/helpers/ihelpers.dart';
import 'package:me_and_my_tent_client/services/httpClient/http_client_contract.dart';
import 'package:me_and_my_tent_client/services/httpClient/http_SecureClient.dart';

class PrivateProvider extends ChangeNotifier {
  // intialization
  final IHttpClient _secureClient =
      SecureClient(Composition.httpClient, Composition.localStore);
  final IHelpers _helpers = Helpers();

  // variables to store data
  bool _fnTriggered = false;
  int _limit = 3;
  bool _hasNext = true;
  String _paginateId;
// variables
  List<CampSitePrev> _favCampSites;
  List<CampReviews> _userReviews = [];
  List<CampSitePrev> _userCamps = [];

// getter
  List<CampSitePrev> get favCampSites {
    return _favCampSites;
  }

  List<CampReviews> get userReviews => _userReviews;
  List<CampSitePrev> get userCamps => _userCamps;
  bool get hasNext => _hasNext;
  bool get fnTriggered => _fnTriggered;

// setter
  set favCampSitesSet(List<CampSitePrev> data) {
    _favCampSites = [];
    _favCampSites = data;
    notifyListeners();
  }

  set userReviewsSet(List<CampReviews> data) {
    _userReviews = List.from(_userReviews)..addAll(data);
    notifyListeners();
  }

  set userReviewsDelete(String reviewid) {
    _userReviews = List.from(_userReviews)
      ..removeWhere((review) => review.id == reviewid);
    notifyListeners();
  }

  set userCampsSet(List<CampSitePrev> data) {
    _userCamps = List.from(_userCamps)..addAll(data);
    notifyListeners();
  }

  set userCampsDelete(String campprevid) {
    _userCamps = List.from(_userCamps)
      ..removeWhere((prev) => prev.campPrevId == campprevid);
    notifyListeners();
  }

  set fnTriggeredSet(bool data) {
    _fnTriggered = data;
    notifyListeners();
  }

// middleware
  set addtoFav(CampSitePrev data) {
    if (_favCampSites == null) _favCampSites = [];
    bool _isPresent = _favCampSites.any(
      (prev) => prev.campPrevId == data.campPrevId,
    );
    if (!_isPresent) _favCampSites = List.from(_favCampSites)..add(data);
  }

  set deleteFromFav(String campprevid) {
    _favCampSites = List.from(_favCampSites)
      ..removeWhere((saved) => saved.campPrevId == campprevid);
    notifyListeners();
  }

//... editors for add and edit campsites

  // variables
  List<String> _imageUrls = [];
  String _campType = '';
  CampSite _editedUserCampSite = CampSite(contactInfo: ContactInfo());
  CampSitePrev _editedUserCampSitePrev =
      CampSitePrev(campAddress: CampAddress());
  List<String> _accomadation = [];
  List<String> _facility = [];
  CampAddress _mapToAddress = CampAddress();
  List<String> _willUploadImgUrls = [];
  List<String> _willRemoveImgUrls = [];

  // getter
  List<String> get imageUrls => _imageUrls;
  String get campType => _campType;
  CampSite get editedUserCampSite => _editedUserCampSite;
  CampSitePrev get editedUserCampSitePrev => _editedUserCampSitePrev;
  List<String> get accomadation => _accomadation;
  List<String> get facility => _facility;
  CampAddress get mapToAddress => _mapToAddress;

  // setter
  void initiialCamp(CampSitePrev campprev, CampSite campSite) {
    _editedUserCampSitePrev =
        campprev ?? CampSitePrev(campAddress: CampAddress());
    _editedUserCampSite = campSite ?? CampSite(contactInfo: ContactInfo());
    _campType = campprev.campType ?? '';
    _mapToAddress = campprev.campAddress ?? CampAddress();
    _imageUrls = campSite.imageUrls ?? [];
    _willRemoveImgUrls = campSite.imageUrls ?? [];
    _accomadation = campSite.accomadation ?? [];
    _facility = campSite.facility ?? [];
  }

  set setCampName(String data) {
    _editedUserCampSitePrev.campName = data;
  }

  set setPrice(String data) {
    _editedUserCampSitePrev.price = data;
  }

  set setAbout(String data) {
    _editedUserCampSite.about = data;
  }

  set setPhoneNo(String data) {
    _editedUserCampSite.contactInfo.phone = data;
  }

  set setEmail(String data) {
    _editedUserCampSite.contactInfo.email = data;
  }

  set addimgUrl(String data) {
    if (data == null) return;
    _imageUrls = [..._imageUrls, data];
    notifyListeners();
  }

  set removeimgUrl(int index) {
    _imageUrls = [..._imageUrls];
    _imageUrls.removeAt(index);
    notifyListeners();
  }

  set selectcampType(String data) {
    if (data == null) return;
    _campType = data.replaceAll(' ', '').toLowerCase();
    notifyListeners();
  }

  set selectAccomadation(String data) {
    if (data == null) return;
    if (_accomadation.contains(data)) {
      _accomadation = List.from(_accomadation)
        ..removeWhere(
          (acc) => acc == data,
        );
    } else {
      _accomadation = [..._accomadation, data];
    }
    notifyListeners();
  }

  set selectFacility(String data) {
    if (data == null) return;
    if (_facility.contains(data)) {
      _facility = List.from(_facility)
        ..removeWhere(
          (faci) => faci == data,
        );
    } else {
      _facility = [..._facility, data];
    }
    notifyListeners();
  }

  // middleware
  Future mapToAddressSet(double lat, double long) async {
    try {
      List<Placemark> _placemarks = await placemarkFromCoordinates(lat, long);
      _mapToAddress = CampAddress(
        address: _helpers.placeMarkToAddress(_placemarks[0]),
        place: _placemarks[0].locality,
        lat: double.parse(lat.toStringAsFixed(6)),
        long: double.parse(long.toStringAsFixed(6)),
      );
      notifyListeners();
    } catch (error) {
      return;
    }
  }

  Future<Position> currentLocation() async {
    return await _helpers.determinePosition();
  }

  bool _paginate(int list) {
    if (list == 0) {
      _hasNext = false;
      fnTriggeredSet = false;
      return false;
    }
    if (list < _limit) _hasNext = false;
    return true;
  }
//... editors for add and edit campsites

  // camps
  Future<bool> addCampSite() async {
    final _uploadedUrls = await _uploadImage(_imageUrls);
    if (_uploadedUrls.isEmpty) return false;
    _editCamp(_uploadedUrls);
    final _body =
        _helpers.camptojson(_editedUserCampSitePrev, _editedUserCampSite);
    final Uri _url = _helpers.urlParser('camp');
    final res = await _secureClient.post(_url, _body);
    if (res.status == Status.failure) {
      return false;
    }
    return true;
  }

  Future<bool> editCampSite() async {
    final _uploadedUrls = _editImgUrls();
    if (_willRemoveImgUrls.isNotEmpty) {
      final _removed = await _removeImage(_willRemoveImgUrls);
      if (_removed.isError) return false;
    }
    if (_willUploadImgUrls.length != 0) {
      final _upUrls = await _uploadImage(_willUploadImgUrls);
      if (_upUrls.isEmpty) return false;
      _uploadedUrls.addAll(_upUrls);
    }
    _editCamp(_uploadedUrls);
    final _body =
        _helpers.camptojson(_editedUserCampSitePrev, _editedUserCampSite);
    final Uri _url = _helpers.urlParser(
        'camp?campid=${_editedUserCampSite.campId}&campprevid=${_editedUserCampSitePrev.campPrevId}');
    final res = await _secureClient.patch(_url, _body);
    if (res.status == Status.failure) {
      return false;
    }
    return true;
  }

  Future getUserCampPrev() async {
    if (_userCamps.length != 0) {
      return;
    }
    final Uri url = _helpers.urlParser('camp/user');
    final res = await _secureClient.get(url);
    if (res.status == Status.failure) {
      userCampsSet = [];
      return;
    }
    userCampsSet = _helpers.jsontoCampPrev(res.body);
    return;
  }

  Future<CampSite> getUserCampSite(String campId) async {
    final Uri url = _helpers.urlParser('camp/campsite/$campId');
    final res = await _secureClient.get(url);
    if (res.status == Status.failure) {
      return Future.error('cant fetch campsite of id $campId');
    }
    return _helpers.jsontoCampsite(res.body);
  }

  Future<bool> removeCampSite(String campprevid) async {
    final Uri _urla = _helpers.urlParser('camp/$campprevid');
    final res = await _secureClient.delete(_urla);
    if (res.status == Status.failure) {
      return false;
    }
    final _imageRemoved =
        await _removeImage(_helpers.jsonToListofStr(res.body));
    if (_imageRemoved.isError) {
      return false;
    }
    userCampsDelete = campprevid;
    return true;
  }

// camp middlewares

  List<String> _editImgUrls() {
    List<String> _oldUrls = [];
    _imageUrls.forEach(
      (url) {
        if (_willRemoveImgUrls.contains(url)) {
          _willRemoveImgUrls.remove(url);
          _oldUrls.add(url);
        } else {
          _willUploadImgUrls.add(url);
        }
      },
    );
    return _oldUrls;
  }

  Future<List<String>> _uploadImage(List<String> urls) async {
    final Uri _url = _helpers.urlParser('camp/images/upload');
    final _uploadedImgUrls = await _secureClient.multiPartRequest(_url, urls);
    if (_uploadedImgUrls.status == Status.failure) {
      return [];
    }
    return _uploadedImgUrls.body['imageUrls'].cast<String>();
  }

  Future<Result<bool>> _removeImage(List<String> urls) async {
    final Uri _url = _helpers.urlParser('camp/images/remove');
    final String body = _helpers.listofStrToJson(urls);
    final res = await _secureClient.delete(_url, body);
    if (res.status == Status.failure) {
      return Result.error('cant upload the image');
    }
    return Result.value(true);
  }

  void _editCamp(List<String> urls) {
    _editedUserCampSitePrev.imageUrl = urls[0];
    _editedUserCampSitePrev.campAddress = _mapToAddress;
    _editedUserCampSitePrev.campType = _campType;
    _editedUserCampSite.imageUrls = urls;
    _editedUserCampSite.accomadation = _accomadation;
    _editedUserCampSite.facility = _facility;
  }

  // Reviews

  Future<Status> addReview(CampReviews campreviews, double rating) async {
    final ratingRes = await addRating(rating, campreviews.campPrevId);
    if (ratingRes == Status.failure) {
      return Status.failure;
    }
    if (ratingRes == Status.exist) {
      return Status.exist;
    }
    final Uri _url = _helpers.urlParser('review');
    final String _body = campreviews.toRawJson();
    final res = await _secureClient.post(_url, _body);
    if (res.status == Status.failure) {
      return Status.failure;
    }
    if (res.status == Status.exist) {
      return Status.exist;
    }
    _userReviews.add(campreviews);
    return Status.success;
  }

  Future<Status> addRating(double rating, String campprevid) async {
    final Uri url = _helpers.urlParser('review/rating/$campprevid');
    final String body = jsonEncode({'userrating': rating});
    final res = await _secureClient.patch(url, body);
    if (res.status == Status.failure) {
      return Status.failure;
    }
    if (res.status == Status.exist) {
      return Status.exist;
    }
    return Status.success;
  }

  Future getReviewForUser(bool initial) async {
    if (initial) {
      if (_userReviews.length != 0) {
        return;
      }
      _initialReviewState();
      _hasNext = true;
    } else {
      _paginateId = _userReviews.last.id;
    }
    if (_fnTriggered) return;
    initial ? _fnTriggered = true : fnTriggeredSet = true;
    final Uri url = _helpers.urlParser('review/user?paginateid=$_paginateId');
    final res = await _secureClient.get(url);
    if (res.status == Status.failure) {
      fnTriggeredSet = false;
      return;
    }
    final List<CampReviews> _list = _helpers.jsontoCampReviews(res.body);
    if (!_paginate(_list.length)) return;
    userReviewsSet = _list;
    fnTriggeredSet = false;
    return;
  }

  Future<bool> removeReview(String reviewid) async {
    final Uri url = _helpers.urlParser('review/$reviewid');
    final res = await _secureClient.delete(url);
    if (res.status == Status.failure) {
      return false;
    }
    userReviewsDelete = reviewid;
    return true;
  }

  void _initialReviewState() {
    _userReviews.clear();
    _paginateId = 'paginateid';
  }

  // userFavs
  Future addUserFavs(CampSitePrev campprev) async {
    addtoFav = campprev;
    final Uri url = _helpers.urlParser('userfavs/add/${campprev.campPrevId}');
    final res = await _secureClient.patch(url);
    if (res.status == Status.failure) {
      return;
    }
    return;
  }

  Future getUserFavs() async {
    if (_favCampSites != null) {
      return;
    }
    Uri url = _helpers.urlParser('userfavs');
    final res = await _secureClient.get(url);
    if (res.status == Status.failure) {
      favCampSitesSet = [];
      return;
    }
    favCampSitesSet = _helpers.jsontoSavedCampSite(res.body);
    return;
  }

  Future<bool> deleteUserFavs(String campprevid) async {
    final Uri _url = _helpers.urlParser('userfavs/remove/$campprevid');
    final res = await _secureClient.patch(_url);
    if (res.status == Status.failure) {
      return false;
    }
    deleteFromFav = campprevid;
    return true;
  }
}
