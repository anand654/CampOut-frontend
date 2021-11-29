import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MConstants {
  static const double bigborderRadius = 22;
  static const String blurHash = 'LtI}t[RiM{Rj.Taeaeaebcogofof';
  static const List<String> places = [
    'Bagalkot',
    'Ballari',
    'Belgaum',
    'Bengaluru',
    'Bidar',
    'Bijapur',
    'Chamarajanagara',
    'Chikkaballapura',
    'Chikmagalur',
    'Chitradurga',
    'Mangaluru',
    'Davanagere',
    'Dharwad',
    'Gadag',
    'Gulbarga',
    'Hassan',
    'Haveri',
    'Madikeri',
    'Kolar',
    'Koppal',
    'Mandya',
    'Mysore',
    'Raichur',
    'Ramanagara',
    'Shimoga',
    'Tumakuru',
    'Udupi',
    'Uttara Kannada',
    'Hospete',
    'Yadgir',
  ];
}

class MMessages {
  static const List<String> messages = [
    '“Look deep into nature and then you will understand everything”',
    '“What happens in the camper styes in the camper”',
    '“Home is where you pitch your tent”',
    '“Of all the paths you take in your like, make sure a few of them are dirt.” – John Muir',
    '“Adopt the pace of nature: her secret is patience.” – Ralph Waldo Emerson',
    '“There’s a sunrise and a sunset every single day, and they’re absolutely free. Don’t miss so many of them.” – Jo Walton',
    '“Cooking and eating food outdoors makes it taste infinitely better than the same meal prepared and consumed indoors.” – Fennel Hudson',
    '“How is it that one match can start a forest fire, but it takes a whole box of matches to start a campfire?” – Christy Whitehead',
    '“Light a campfire and everyone’s a storyteller.” – John Geddes',
    '“It’s impossible to go for a walk in the woods and be in a bad mood at the same time.” – Unknown',
    '“Donating blood, one mosquito at a time.” – Unknown ',
    '“Camping is great for when you’re craving a horrible night’s sleep.” – Unknown',
    '“Camping is nature’s way of promoting the motel business.” – Dave Barry',
  ];
}

class MIcons {
  static IconData accomadation(String accomad) {
    switch (accomad) {
      case 'Drive In':
        return FontAwesomeIcons.car;
        break;
      case 'Walk In':
        return FontAwesomeIcons.walking;
        break;
      case 'Hike In':
        return FontAwesomeIcons.hiking;
        break;
      case 'Tent':
        return FontAwesomeIcons.campground;
        break;
      case 'Rv':
        return FontAwesomeIcons.caravan;
        break;
      case 'Cabin':
        return Icons.cabin;
        break;
      default:
        return FontAwesomeIcons.tree;
        break;
    }
  }

  static IconData facility(String accomad) {
    switch (accomad) {
      case 'Fires Allowed':
        return FontAwesomeIcons.gripfire;
        break;
      case 'Pets Allowed':
        return FontAwesomeIcons.paw;
        break;
      case 'Alcohol Allowed':
        return FontAwesomeIcons.beer;
        break;
      case 'Drinking Water':
        return FontAwesomeIcons.handHoldingWater;
        break;
      case 'Toilets':
        return FontAwesomeIcons.toilet;
        break;
      case 'Showers':
        return FontAwesomeIcons.shower;
        break;
      case 'Wifi':
        return FontAwesomeIcons.wifi;
        break;
      case 'Reservable':
        return FontAwesomeIcons.clipboardCheck;
        break;
      case 'Picnic Table':
        return FontAwesomeIcons.chair;
        break;
      case 'Trash':
        return FontAwesomeIcons.dumpster;
        break;
      case 'Market':
        return FontAwesomeIcons.store;
        break;
      case 'Sewer Hookups':
        return FontAwesomeIcons.dolly;
        break;
      case 'Water Hookups':
        return FontAwesomeIcons.faucet;
        break;
      case 'Power Hookups':
        return FontAwesomeIcons.chargingStation;
        break;
      default:
        return FontAwesomeIcons.tree;
        break;
    }
  }

  static List<String> campType = [
    'Tent Camping',
    'Rv and Van',
    'Glamping',
    'Backpacking',
  ];

  static List<String> accomadationList = [
    'Drive In',
    'Walk In',
    'Hike In',
    'Tent',
    'Rv',
    'Cabin',
  ];

  static List<String> facilityList = [
    'Fires Allowed',
    'Pets Allowed',
    'Alcohol Allowed',
    'Drinking Water',
    'Toilets',
    'Showers',
    'Wifi',
    'Reservable',
    'Picnic Table',
    'Trash',
    'Market',
    'Sewer Hookups',
    'Water Hookups',
    'Power Hookups',
  ];
}
