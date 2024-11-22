import 'package:flutter/material.dart';
import 'app_dimens.dart';
import 'app_strings.dart';

final List<Map<String, dynamic>> countries = [
  {
    "code": "US",
    "flag": "assets/icons/us_country_flag.svg",
    "name": "United States of America",
    "phoneCode": "+1"
  },
  {
    "code": "DZ",
    "flag": "assets/flags/algeria.svg",
    "name": "Algeria",
    "phoneCode": "+213"
  },
  {
    "code": "AD",
    "flag": "assets/flags/andorra.svg",
    "name": "Andorra",
    "phoneCode": "+376"
  },
  {
    "code": "AO",
    "flag": "assets/flags/angola.svg",
    "name": "Angola",
    "phoneCode": "+244"
  },
  {
    "code": "AR",
    "flag": "assets/flags/argentina.svg",
    "name": "Argentina",
    "phoneCode": "+54"
  },
  {
    "code": "AM",
    "flag": "assets/flags/armenia.svg",
    "name": "Armenia",
    "phoneCode": "+374"
  },
  {
    "code": "AW",
    "flag": "assets/flags/aruba.svg",
    "name": "Aruba",
    "phoneCode": "+297"
  },
  {
    "code": "AU",
    "flag": "assets/flags/australia.svg",
    "name": "Australia",
    "phoneCode": "+61"
  },
  {
    "code": "AL",
    "flag": "assets/flags/albania.svg",
    "name": "Albania",
    "phoneCode": "+355"
  },
  {
    "code": "BD",
    "flag": "assets/flags/bangladesh.svg",
    "name": "Bangladesh",
    "phoneCode": "+880"
  },
  {
    "code": "IN",
    "flag": "assets/icons/in.svg",
    "name": "India",
    "phoneCode": "+91"
  },
];

final List<Map<String, dynamic>> faqItems = [
  {
    "title": Strings.lifeWinks,
    "image": "logo",
    "description":
        "Questions and answers about creating and receiving LifeWinks.",
  },
  {
    "title": Strings.myLifeWinks,
    "image": "ic_faq_star_double",
    "description":
        "Questions and answers regarding your collection of LifeWinks, both created and received.",
  },
  {
    "title": Strings.trustPrivacyAndSecurity,
    "image": "ic_faq_exclude",
    "description":
        "Questions and answers about our approach to privacy and security and to earning your trust.",
  }
];


final List<Map<String, dynamic>> medias = [
  {"title": "Video", "index": 0},
  {"title": "Photo", "index": 1},
  {"title": "Audio", "index": 2},
  {"title": "Attachment", "index": 3}
];

final List<String> ratingEmojis = [
  "assets/icons/happy_not_highlighted.svg",
  "assets/icons/normal_not_highlighted.svg",
  "assets/icons/sad_not_highlighted.svg",
  "assets/icons/good_active.svg",
  "assets/icons/average_active.svg",
  "assets/icons/bad_active.svg",
];

final List<String> memberImprovementPoints = [
  "Log In or Sign Up",
  "Creating LifeWinks",
  "Building AI LifeWinks",
  "Receiving LifeWinks",
  "Customer Support",
  "Send Now Exceptions",
  "Steward Experience",
  "Guardian Experience",
  "My LifeWinks",
  "Receiving AI LifeWinks"
];

var dummyPassword = "Abcd@12345";
var supportEmail = "support@lifewink.com";
var supportPhone = "1234567890";
int resendTimerTime = 90;
int dialogAnimationDuration = 250;
double userAvatarSize = 25;
int nameCharMinCount = 3;
int lastNameIndex = 1;
int lastNameMinCount = 1;
int userDetailsEmailErrorIndex = 1;
int guardianTabIndex = 1;
int mobileNumberCharCount = 10;
int noGuardian = 0;

var dummyBoxDecoration = const BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(16)));



var bottomSheetShape = ShapeBorder.lerp(
    const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimensions.screenBorder),
        topRight: Radius.circular(Dimensions.screenBorder),
      ),
    ),
    const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimensions.screenBorder),
        topRight: Radius.circular(Dimensions.screenBorder),
      ),
    ),
    1);

var linearGradientContainer = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFD9EDF4),
    Color(0xFFEEEEFC),
    Color(0xFFF5F2F5),
  ],
);

var linearGradientContainer2 = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFD9EDF4),
    Color(0xFFEEEEFC),
    Color(0xFFF5F2F5),
  ],
);
var linearGradientContainer3 = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment(0.8, 1),
  colors: [
    Color(0xFFD9EDF4),
    Color(0xFFEEEEFC),
    Color(0xFFF5F2F5),
  ],
);

var linearGradientContainer4 = const LinearGradient(
  colors: [
    Color(0xffD9EDF4),
    Color(0xffEEEEFC),
    Color(0xffF5F2F5),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
