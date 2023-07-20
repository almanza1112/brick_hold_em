import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {

  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
      // return 'ca-app-pub-3361872396467095/1263817180';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
      // return 'ca-app-pub-3361872396467095/7180743875';
    }
    return null;
  }
}