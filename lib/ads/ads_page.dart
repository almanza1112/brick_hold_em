import 'package:brick_hold_em/ads/ad_state.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  final Future<InitializationStatus> initFuture =
      MobileAds.instance.initialize();
  RewardedAd? _rewardedAd;
  int rewardedScore = 0;

  @override
  void initState() {
    super.initState();
    createRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('EARN CHIPS'),
        backgroundColor: Colors.black,
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
          Center(child: Text('Rewarded Score is: $rewardedScore', style: const TextStyle(color: Colors.white),)),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: _showRewarededAd, child: const Text("get 100 chips"))
        ],
      ),
    );
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
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() {
          rewardedScore += 100;
        });
      });
      _rewardedAd = null;
    }
  }
}
