import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/data/data_sources/cloudinary/cludinary_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:lumeo/features/data/model/comment/comment_model.dart';
import 'package:lumeo/features/data/model/post/post_model.dart';
import 'package:lumeo/features/data/model/replay/replay_model.dart';
import 'package:lumeo/features/data/model/savedpost/savedpost_model.dart';
import 'package:lumeo/features/data/model/user/user_model.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/entities/saved_post_entity/saved_post_entity.dart';
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
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;


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
                totalFollowing: user.totalFollowing,
                profileUrl: profileUrl,
                totalPosts: user.totalPosts,
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
                totalFollowing: user.totalFollowing,
                totalPosts: user.totalPosts,
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
  // Future<String> getCurrentUuid() async => firebaseAuth.currentUser!.uid;

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
    if (user.totalFollowing != null && user.totalFollowing != null) {
      userInformation['totalFollowing'] = user.totalFollowing;
    }
    if (user.totalPosts != null && user.totalPosts != null) {
      userInformation['totalPost'] = user.totalPosts;
    }

    userCollection.doc(user.uid).update(userInformation);
  }

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
        print(
          '[createPost] Post image uploaded successfully. URL: $postImageUrl',
        );
      } else {
        print('[createPost] No post image found. Skipping image upload.');
      }

      final newPost =
          PostModel(
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
        await postCollection.doc(post.postId).set(newPost).then((value) async {
          final userDocRef = firebaseFirestore
              .collection(FirebaseConst.users)
              .doc(post.creatorUid);

          final userDocSnapshot = await userDocRef.get();
          if (userDocSnapshot.exists) {
            final userData = userDocSnapshot.data();
            if (userData != null) {
              final totalPosts = (userData['totalPosts'] ?? 0) as int;
              await userDocRef.update({"totalPosts": totalPosts + 1});
              print('[createPost] Total posts updated to ${totalPosts + 1}');
            }
          }
        });
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

  Future<void> deletePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    if (post.creatorUid == null) {
      print(
        '[deletePost] ❌ creatorUid is null! Cannot update user post count.',
      );
      return;
    }

    try {
      await postCollection.doc(post.postId).delete();
      print('[deletePost] Deleted post with ID: ${post.postId}');

      final userDocRef = firebaseFirestore
          .collection(FirebaseConst.users)
          .doc(post.creatorUid);

      final userDoc = await userDocRef.get();
      if (userDoc.exists) {
        print('[deletePost] User document exists for UID: ${post.creatorUid}');
        final userData = userDoc.data();
        print('[deletePost] User data: $userData');
        final totalPosts = (userData?['totalPosts'] ?? 0) as int;
        print('[deletePost] Current totalPosts: $totalPosts');

        await userDocRef.update({'totalPosts': totalPosts - 1});
        print('[deletePost] totalPosts decremented to ${totalPosts - 1}');
      } else {
        print(
          '[deletePost] ❌ User document does not exist for UID: ${post.creatorUid}',
        );
      }
    } catch (e, st) {
      print('[deletePost] ❌ Error: $e');
      print(st);
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

  @override
  Stream<List<PostEntity>> readSinglePosts(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList(),
    );
  }

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

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    final currentuid = await getCurrentUid();
    final postRef = postCollection.doc(post.postId);
    final postRefget = await postRef.get();

    if (postRefget.exists) {
      List likes = postRefget.get('likes');
      if (likes.contains(currentuid)) {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayRemove([currentuid]),
          'totalLikes': FieldValue.increment(-1),
        });
      } else {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayUnion([currentuid]),
          "totalLikes": FieldValue.increment(1),
        });
      }
    }
  }

  //comments
  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    final newComment =
        CommentModel(
          userProfileUrl: comment.userProfileUrl,
          username: comment.username,
          totalReplays: comment.totalReplays,
          commentId: comment.commentId,
          postId: comment.postId,
          likes: [],
          description: comment.description,
          creatorUid: comment.creatorUid,
          createAt: comment.createAt,
        ).toJson();

    try {
      final CommentDocRef =
          await commentCollection.doc(comment.commentId).get();

      if (!CommentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection = firebaseFirestore
              .collection(FirebaseConst.posts)
              .doc(comment.postId);
          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postCollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        await commentCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      print("some error occured ${e}");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore
            .collection(FirebaseConst.posts)
            .doc(comment.postId);
        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postCollection.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured ${e}");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);
    final currentUid = await getCurrentUid();
    final commentRef = await commentCollection.doc(comment.commentId).get();
    try {
      if (commentRef.exists) {
        List likes = commentRef.get("likes");
        if (likes.contains(currentUid)) {
          commentCollection.doc(comment.commentId).update({
            "likes": FieldValue.arrayRemove([currentUid]),
          });
        } else {
          commentCollection.doc(comment.commentId).update({
            "likes": FieldValue.arrayUnion([currentUid]),
          });
        }
      }
    } catch (e) {
      print("some error occured ${e}");
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(postId)
        .collection(FirebaseConst.comment)
        .orderBy('createAt', descending: true);
    return commentCollection.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList(),
    );
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);
    Map<String, dynamic> commentInfo = {};
    if (comment.description != "" && comment.description != null)
      commentInfo["description"] = comment.description;
    commentCollection.doc(comment.commentId).update(commentInfo);
  }

  //replays
  @override
  Future<void> createReplays(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    final newReplay =
        ReplayModel(
          userProfileUrl: replay.userProfileUrl,
          username: replay.username,
          replayId: replay.replayId,
          commentId: replay.commentId,
          postId: replay.postId,
          likes: [],
          description: replay.description,
          creatorUid: replay.creatorUid,
          createAt: replay.createAt,
        ).toJson();

    try {
      final replayDocRef = await replayCollection.doc(replay.replayId).get();

      if (!replayDocRef.exists) {
        replayCollection.doc(replay.replayId).set(newReplay);
      } else {
        replayCollection.doc(replay.replayId).update(newReplay);
      }
    } catch (e) {
      print("some error occured ${e}");
    }
  }

  @override
  Future<void> deleteReplays(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    try {
      replayCollection.doc(replay.replayId).delete();
    } catch (e) {
      print("some error occured ${e}");
    }
  }

  @override
  Future<void> likeReplays(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    final currentUid = await getCurrentUid();
    final replayRef = await replayCollection.doc(replay.replayId).get();

    if (replayRef.exists) {
      List likes = replayRef.get("likes");
      if (likes.contains(currentUid)) {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
        });
      } else {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
        });
      }
    }
  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    final replayCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    return replayCollection.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs.map((e) => ReplayModel.fromSnapshot(e)).toList(),
    );
  }

  @override
  Future<void> updateReplays(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    Map<String, dynamic> replayinfo = Map();
    if (replay.description != "" && replay.description != null)
      replayinfo['description'] = replay.description;
    replayCollection.doc(replay.replayId).update(replayinfo);
  }






    @override
  Future<void> savePost(String postId, String userId) async {
    var savedPosts = firebaseFirestore.collection('saved posts');
    var existing = await savedPosts
        .where("userId", isEqualTo: userId)
        .where("postId", isEqualTo: postId)
        .get();

    if (existing.docs.isEmpty) {
      savedPosts.add({
        "userId": userId,
        "postId": postId,
        "savedAt": FieldValue.serverTimestamp()
      });
    } else {
      print('post already present');
    }
  }


  Stream<List<SavedpostsEntity>> readSavedPost(String userId) {
    final savedPostsuser = firebaseFirestore
        .collection("saved posts")
        .where("userId", isEqualTo: userId);

    var savedposts = savedPostsuser.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => SavedpostModel.fromSnapshot(e)).toList());
    print(savedposts);

    return savedposts;
  }
  
@override
Future<void> deleteSavedPost(String postId, String userId) async {
  final savedPosts = firebaseFirestore.collection('saved posts');

  final existing = await savedPosts
      .where("userId", isEqualTo: userId)
      .where("postId", isEqualTo: postId)
      .get();

  for (var doc in existing.docs) {
    await savedPosts.doc(doc.id).delete();
  }
}

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: otherUid)
        .limit(1);
    return userCollection.snapshots().map(
      (QuerySnapshot) =>
          QuerySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
    );
  }


  @override
  Future<void> followUnfollowUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConst.users);

    try {
      await firebaseFirestore.runTransaction((transaction) async {
        final myDocRef = userCollection.doc(user.uid);
        final otherUserDocRef = userCollection.doc(user.otherUid);

        final myDocSnapshot = await transaction.get(myDocRef);
        final otherUserDocSnapshot = await transaction.get(otherUserDocRef);

        if (!myDocSnapshot.exists || !otherUserDocSnapshot.exists) {
          throw Exception("One or both users don't exist");
        }

        List myFollowingList = myDocSnapshot.get("following") ?? [];

        bool isAlreadyFollowing = myFollowingList.contains(user.otherUid);

        if (isAlreadyFollowing) {
          transaction.update(myDocRef, {
            "following": FieldValue.arrayRemove([user.otherUid]),
            "totalFollowing": (myDocSnapshot.get('totalFollowing') ?? 0) - 1
          });

          transaction.update(otherUserDocRef, {
            "followers": FieldValue.arrayRemove([user.uid]),
            "totalFollowers":
                (otherUserDocSnapshot.get('totalFollowers') ?? 0) - 1
          });
        } else {
          transaction.update(myDocRef, {
            "following": FieldValue.arrayUnion([user.otherUid]),
            "totalFollowing": (myDocSnapshot.get('totalFollowing') ?? 0) + 1
          });

          transaction.update(otherUserDocRef, {
            "followers": FieldValue.arrayUnion([user.uid]),
            "totalFollowers":
                (otherUserDocSnapshot.get('totalFollowers') ?? 0) + 1
          });
        }
      });

      print("Follow/unfollow transaction completed successfully");
    } catch (e) {
      print("Error in followUser transaction: $e");
      throw e;
    }
  }
  
  @override
  Future<List<PostEntity>> likepage() async{
    final currentuid = getCurrentUid();
final snapshot= await firebaseFirestore.collection("posts").where("likes",arrayContains: currentuid).get();
return snapshot.docs.map((doc)=>PostModel.fromSnapshot(doc)).toList();
  }


 
}