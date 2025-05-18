import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/data/data_sources/cloudinary/cludinary_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:lumeo/features/data/model/post/post_model.dart';
import 'package:lumeo/features/data/model/user/user_model.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final CloudinaryRepository cloudinaryRepository;

  FirebaseRemoteDataSourceImpl({
    required this.cloudinaryRepository,
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  @override
  Future<void> createUserWithProfileImage(
    UserEntity user,
    String profileUrl,
  ) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();
    userCollection
        .doc(uid)
        .get()
        .then((userDoc) {
          final newUser =
              UserModel(
                name: user.name,
                email: user.email,
                uid: uid,
                username: user.username,
                bio: user.bio,
                link: user.link,
                followers: user.followers,
                following: user.following,
                totalFollowers: user.totalFollowers,
                totalfollowing: user.totalfollowing,
                profileUrl: profileUrl,
                totalPost: user.totalPost,
              ).toJson();

          if (!userDoc.exists) {
            userCollection.doc(uid).set(newUser);
          } else {
            userCollection.doc(uid).update(newUser);
          }
        })
        .catchError((error) {
          toast('Some error occurred');
        });
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();

    userCollection
        .doc(uid)
        .get()
        .then((userDoc) {
          final newUser =
              UserModel(
                uid: uid,
                name: user.name,
                email: user.email,
                bio: user.bio,
                following: user.following,
                link: user.link,
                profileUrl: user.profileUrl,
                username: user.username,
                totalFollowers: user.totalFollowers,
                followers: user.followers,
                totalfollowing: user.totalfollowing,
                totalPost: user.totalPost,
              ).toJson();
          if (!userDoc.exists) {
            userCollection.doc(uid).set(newUser);
          } else {
            userCollection.doc(uid).update(newUser);
          }
        })
        .catchError((error) {
          toast("some Error Occur");
        });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map(
      (QuerySnapshot) =>
          QuerySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
    );
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    return userCollection.snapshots().map(
      (QuerySnapshot) =>
          QuerySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
    );
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> loginUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: user.email!,
          password: user.password!,
        );
      } else {
        print("fields cannot be empty");
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "user-not-found") {
        toast("user not found");
      } else if (error.code == "wrong-password") {
        toast("invalid email or password");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      print("Attempting to create user with email: ${user.email}");
      await firebaseAuth
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          )
          .then((value) async {
            print("User created successfully, checking UID...");
            if (value.user?.uid != null) {
              String profileUrl = '';
              if (user.profileImageFile != null) {
                print("Profile image found, uploading...");
                profileUrl = await cloudinaryRepository
                    .uploadProfileImageToStorage(
                      user.profileImageFile,
                      'profileImages',
                    );
                print("Profile image uploaded, URL: $profileUrl");

                await createUserWithProfileImage(user, profileUrl);
              } else {
                print("No profile image found, creating user without it...");
                await createUser(user);
              }
            }
          });
      print("Sign up process completed.");
      return;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException caught: ${e.code}");
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = Map();

    if (user.username != "" && user.username != null) {
      userInformation['username'] = user.username;
    }
    if (user.link != "" && user.link != null) {
      userInformation['link'] = user.link;
    }

    String profileUrl = '';

    if (user.profileImageFile != null) {
      print("Profile image found, uploading...");
      profileUrl = await cloudinaryRepository.uploadProfileImageToStorage(
        user.profileImageFile,
        'profileImages',
      );
      userInformation['profileUrl'] = profileUrl;
    } else if (user.profileUrl != "" && user.profileUrl != null) {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;
    if (user.name != "" && user.name != null) {
      userInformation['name'] = user.name;
    }
    if (user.totalFollowers != null && user.totalFollowers != null) {
      userInformation['totalFollowers'] = user.totalFollowers;
    }
    if (user.totalfollowing != null && user.totalfollowing != null) {
      userInformation['totalfollowing'] = user.totalfollowing;
    }
    if (user.totalPost != null && user.totalPost != null) {
      userInformation['totalPost'] = user.totalPost;
    }

    userCollection.doc(user.uid).update(userInformation);
  }

  // @override
  // Future<void> crearePost(PostEntity post) async {
  //   final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
  //   final newPost =
  //       PostModel(
  //         userProfileUrl: post.userProfileUrl,
  //         userName: post.userName,
  //         totalLikes: post.totalLikes,
  //         totalComments: post.totalComments,
  //         postImageUrl: post.postImageUrl,
  //         postId: post.postId,
  //         likes: [],
  //         description: post.description,
  //         creatorUid: post.creatorUid,
  //         createAt: post.createAt,
  //       ).toJson();
  //   try {
  //     final postDocRef = await postCollection.doc(post.postId).get();
  //     if (!postDocRef.exists) {
  //         String profileUrl = '';
  //             if (post.postImageUrl!= null) {
  //               print("Profile image found, uploading...");
  //               profileUrl = await cloudinaryRepository
  //                   .uploadPostImageToStorage(
  //                     post.postImage,
  //                     'postImageUrl',
  //                   );
  //               print("Profile image uploaded, URL: $profileUrl");

  //             } 
  //       postCollection.doc(post.postId).set(newPost);
  //     } else {
  //       postCollection.doc(post.postId).update(newPost);
  //     }
  //   } catch (e) {
  //     print('some error occured');
  //   }
  // }


// @override
// Future<void> createPost(PostEntity post) async {
//   final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

//   try {
//     String postImageUrl = post.postImageUrl ?? '';

//     // Upload post image if it exists
//     if (post.postImage != null) {
//       print("Post image found, uploading...");
//       postImageUrl = await cloudinaryRepository.uploadPostImageToStorage(
//         post.postImage!,
//         'postImageUrl',
//       );
//       print("Post image uploaded, URL: $postImageUrl");
//     }
//     final newPost = PostModel(
//       userProfileUrl: post.userProfileUrl,
//       userName: post.userName,
//       totalLikes: post.totalLikes,
//       totalComments: post.totalComments,
//       postImageUrl: postImageUrl,
//       postId: post.postId,
//       likes: [],
//       description: post.description,
//       creatorUid: post.creatorUid,
//       createAt: post.createAt,
//     ).toJson();

//     final postDocRef = await postCollection.doc(post.postId).get();

//     if (!postDocRef.exists) {
//       await postCollection.doc(post.postId).set(newPost);
//     } else {
//       await postCollection.doc(post.postId).update(newPost);
//     }
//   } catch (e) {
//     print('An error occurred while creating the post: $e');
//   }
// }



@override
Future<void> createPost(PostEntity post) async {
  final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

  print('[createPost] Called with postId: ${post.postId}');

  try {
    String postImageUrl = post.postImageUrl ?? '';
    print('[createPost] Initial postImageUrl: $postImageUrl');

    // Upload post image if it exists
    if (post.postImage != null) {
      print('[createPost] Post image found, starting upload...');
      postImageUrl = await cloudinaryRepository.uploadPostImageToStorage(
        post.postImage!,
        'postImageUrl',
      );
      print('[createPost] Post image uploaded successfully. URL: $postImageUrl');
    } else {
      print('[createPost] No post image found. Skipping image upload.');
    }

    final newPost = PostModel(
      userProfileUrl: post.userProfileUrl,
      userName: post.userName,
      totalLikes: post.totalLikes,
      totalComments: post.totalComments,
      postImageUrl: postImageUrl,
      postId: post.postId,
      likes: [],
      description: post.description,
      creatorUid: post.creatorUid,
      createAt: post.createAt,
    ).toJson();

    print('[createPost] PostModel converted to JSON: $newPost');

    final postDocRef = await postCollection.doc(post.postId).get();
    print('[createPost] Checked Firestore for existing post document');

    if (!postDocRef.exists) {
      print('[createPost] Document does not exist. Creating new post...');
      await postCollection.doc(post.postId).set(newPost);
      print('[createPost] Post created successfully.');
    } else {
      print('[createPost] Document already exists. Updating post...');
      await postCollection.doc(post.postId).update(newPost);
      print('[createPost] Post updated successfully.');
    }
  } catch (e, stackTrace) {
    print('[createPost] ❌ An error occurred while creating the post: $e');
    print('[createPost] Stack trace: $stackTrace');
  }
}



  

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    try {
      postCollection.doc(post.postId).delete();
    } catch (e) {
      print('some error occured..');
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    final currentUid = await getCurrentUid();

    final postRef = await postCollection.doc(post.postId).get();
    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("likes");

      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1,
        });
      } else {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1,
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList(),
    );
  }



// @override
// Future<void> updatePost(PostEntity post) async {
//   String postImageUrl = post.postImageUrl ?? '';
//   print('[createPost] Initial postImageUrl: $postImageUrl');

//   if (post.postImage != null) {
//     print('[createPost] Post image found, starting upload...');
//     final updatedUrl = await cloudinaryRepository.uploadPostImageToStorage(
//       post.postImage!,
//       'postImageUrl',
//     );
//     print('[createPost] Post image uploaded successfully. URL: $updatedUrl');
//     postImageUrl = updatedUrl; 
//   } else {
//     print('[createPost] No post image found. Skipping image upload.');
//   }

//   final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
//   Map<String, dynamic> postInfo = {};

//   if (post.description != null && post.description!.trim().isNotEmpty) {
//     postInfo["description"] = post.description;
//   }

//   postInfo["postImageUrl"] = postImageUrl;

//   await postCollection.doc(post.postId).update(postInfo);
// }

@override
Future<void> updatePost(PostEntity post) async {
  String postImageUrl = post.postImageUrl ?? '';
  print('[createPost] Initial postImageUrl: $postImageUrl');

  bool imageUpdated = false;

  if (post.postImage != null) {
    print('[createPost] Post image found, starting upload...');
    final updatedUrl = await cloudinaryRepository.uploadPostImageToStorage(
      post.postImage!,
      'postImageUrl',
    );
    print('[createPost] Post image uploaded successfully. URL: $updatedUrl');
    postImageUrl = updatedUrl;
    imageUpdated = true; // mark that a new image was uploaded
  } else {
    print('[createPost] No post image found. Skipping image upload.');
  }

  final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
  Map<String, dynamic> postInfo = {};

  if (post.description != null && post.description!.trim().isNotEmpty) {
    postInfo["description"] = post.description;
  }

  if (imageUpdated) {
    postInfo["postImageUrl"] = postImageUrl;
  }

  await postCollection.doc(post.postId).update(postInfo);
}


  
}
