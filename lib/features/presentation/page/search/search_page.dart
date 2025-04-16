import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/presentation/page/search/widget/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Search(controller: SearchController()),
                  sizeVer(10),
                ],
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  decoration: BoxDecoration(color: secondaryColor),
                ),
                childCount: 10, // Set the number of items you need
              ),
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 3,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                pattern: [
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(2, 2),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 2),
                  QuiltedGridTile(1, 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  // GridView.builder(
              //   physics: ScrollPhysics(),
              //   itemCount: 2,
              //   shrinkWrap: true,
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 5,
              //     crossAxisSpacing: 5,
              //     mainAxisSpacing: 5
              //   ),
              //   itemBuilder: (context, index) {
              //     return Container(width: 100, height: 100,color: secondaryColor,);
              //   },
              // ),