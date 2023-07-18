import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:brick_hold_em/friends/user.dart';

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<User> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(User.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}
