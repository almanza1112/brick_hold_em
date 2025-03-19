import 'package:brick_hold_em/friends/user.dart';
import 'package:flutter/material.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:brick_hold_em/friends/search_meta_data.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'hitspage.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({super.key});

  @override
  State<SearchUsersPage> createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final _searchTextController = TextEditingController();

  final _productsSearcher = HitsSearcher(
      applicationID: 'V6H20T78GJ',
      apiKey: '1c5939224b655d85d2abf4f77ed40d75',
      indexName: 'users');

  Stream<SearchMetadata> get _searchMetadata =>
      _productsSearcher.responses.map(SearchMetadata.fromResponse);

  // final PagingController<int, User> _pagingController =
  //     PagingController(firstPageKey: 0);

  Stream<HitsPage> get _searchPage =>
      _productsSearcher.responses.map(HitsPage.fromResponse);

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(
      () => _productsSearcher.applyState(
        (state) => state.copyWith(
          query: _searchTextController.text,
          page: 0,
        ),
      ),
    );

    // _searchPage.listen((page) {
    //   if (page.pageKey == 0) {
    //     _pagingController.refresh();
    //   }
    //   _pagingController.appendPage(page.items, page.nextPageKey);
    // }).onError((error) => _pagingController.error = error);

    // _pagingController.addPageRequestListener(
    //     (pageKey) => _productsSearcher.applyState((state) => state.copyWith(
    //           page: pageKey,
    //         )));
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _productsSearcher.dispose();
    //_pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEARCH'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchTextController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for users',
                    prefixIcon: Icon(Icons.search),
                  ),
                )),
            StreamBuilder<SearchMetadata>(
              stream: _searchMetadata,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${snapshot.data!.nbHits} hits'),
                );
              },
            ),
            // Expanded(
            //   child: _hits(context),
            // )
          ],
        ),
      ),
    );
  }

  // Widget _hits(BuildContext context) => PagedListView<int, User>(
  //     pagingController: _pagingController,
  //     builderDelegate: PagedChildBuilderDelegate<User>(
  //         noItemsFoundIndicatorBuilder: (_) => const Center(
  //               child: Text('No results found'),
  //             ),
  //         itemBuilder: (_, item, __) => Container(
  //               color: Colors.white,
  //               height: 70,
  //               padding: const EdgeInsets.all(8),
  //               child: Row(
  //                 children: [
  //                   CircleAvatar(
  //                     backgroundImage: NetworkImage(item.photoURL),
  //                     radius: 20,
  //                   ),
  //                   const SizedBox(width: 20),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Text(
  //                         item.username,
  //                         style: const TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       Text(
  //                         item.fullName,
  //                         style: const TextStyle(fontSize: 12),
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             )));
}
