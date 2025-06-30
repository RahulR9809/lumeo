
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/page/search/widget/search.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    BlocProvider.of<UserCubit>(context).getUsers(user: UserEntity());

    _searchController.addListener(() {
      setState(() {});
    });
  }


@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.primary,
    body: BlocBuilder<UserCubit, UserState>(
      builder: (context, userstate) {
        if (userstate is UserLoaded) {
          final filter = userstate.users
              .where(
                (user) => user.username!
                    .toLowerCase()
                    .startsWith(_searchController.text.toLowerCase()),
              )
              .toList();

          return SafeArea(
            child: Column(
              children: [
                Search(controller: _searchController),
                sizeVer(height * 0.01),
                Expanded(
                  child: _searchController.text.isEmpty
                      ? BlocBuilder<PostCubit, PostState>(
                          builder: (context, postState) {
                            if (postState is PostLoaded) {
                              final post = postState.posts;

                              return CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01),
                                    sliver: SliverGrid(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                PageConst.postDetailPage,
                                                arguments: post[index].postId,
                                              );
                                            },
                                            child: profilewidget(
                                              imageUrl: post[index].postImageUrl,
                                            ),
                                          );
                                        },
                                        childCount: post.length,
                                      ),
                                      gridDelegate: SliverQuiltedGridDelegate(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: width * 0.008,
                                        crossAxisSpacing: width * 0.008,
                                        pattern: const [
                                          QuiltedGridTile(1, 1),
                                          QuiltedGridTile(2, 2),
                                          QuiltedGridTile(1, 1),
                                          QuiltedGridTile(1, 2),
                                          QuiltedGridTile(1, 1),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        )
                      : filter.isEmpty
                          ?  Center(child: Text("User not found",style: TextStyle(color: Theme.of(context).colorScheme.surface),))
                          : ListView.builder(
                              itemCount: filter.length,
                              itemBuilder: (context, index) {
                                final user = filter[index];
                                return GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    PageConst.singleProfilePage,
                                    arguments: user.uid,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * 0.01),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: height * 0.06,
                                          width: height * 0.06,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            child: profilewidget(
                                              imageUrl: user.profileUrl,
                                            ),
                                          ),
                                        ),
                                        sizeHor(width * 0.03),
                                        Text(
                                          user.username!,
                                          style: TextStyle(
                                              fontSize: width * 0.042,color: Theme.of(context).colorScheme.surface),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    ),
  );
}
}