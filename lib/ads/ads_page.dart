import 'package:brick_hold_em/ads/ad_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:brick_hold_em/globals.dart' as globals;

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  final Future<InitializationStatus> initFuture =
      MobileAds.instance.initialize();
  RewardedAd? _rewardedAd;

  FirebaseFirestore db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  late Future<String?> usersChips;

  @override
  void initState() {
    super.initState();
    usersChips = getChips();
    createRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('EARN CHIPS'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: FutureBuilder(
                future: usersChips,
                builder: (context, snapshot) {
                  return Text(
            'Rewarded Score is: ${snapshot.data}',
            style: const TextStyle(color: Colors.white),
          );
                }
              )),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: _showRewarededAd, child: const Text("get 100 chips"))
        ],
      ),
    );
  }

  Future<String?> getChips() async {
    return await storage.read(key: globals.FSS_CHIPS);
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdState.rewardedAdUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            setState(() {
              _rewardedAd = ad;
            });
          },
          onAdFailedToLoad: (error) {
            setState(() {
              _rewardedAd = null;
            });
          },
        ));
  }

  void _showRewarededAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createRewardedAd();
        },
      );
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) => updateChipCount());
      _rewardedAd = null;
    }
  }

  void updateChipCount() async {
    var chips = await storage.read(key: globals.FSS_CHIPS);
    int updatedChipsCounter = int.parse(chips!) + 100;

    db
        .collection("users")
        .doc(uid)
        .update({"chips": updatedChipsCounter}).then((value) async {
      await storage.write(
          key: globals.FSS_CHIPS, value: updatedChipsCounter.toString());
    }).catchError((error) {});
    setState(() {
      usersChips = updatedChipsCounter as Future<String?>;
    });
  }
}
