import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:lumeo/features/data/model/user/user_model.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  FirebaseRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

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
      await firebaseAuth
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          )
          .then((value) async {
            if (value.user?.uid != null) {
              await createUser(user);
            }
          });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong");
      }
    }
  }

// @override
// Future<void> signUpUser(UserEntity user) async {
//   print("=== DEBUG: signUpUser() called ===");
//   print("Email: ${user.email}, Password: ${user.password}");

//   try {
//     print("=== DEBUG: Attempting to create user with email and password ===");
//     await firebaseAuth
//         .createUserWithEmailAndPassword(
//           email: user.email!,
//           password: user.password!,
//         )
//         .then((value) async {
//           print("=== DEBUG: FirebaseAuth createUserWithEmailAndPassword success ===");

//           if (value.user?.uid != null) {
//             print("=== DEBUG: User UID: ${value.user?.uid} ===");
//             await createUser(user);
//             print("=== DEBUG: createUser() called successfully ===");
//           } else {
//             print("=== DEBUG: UID is null after sign-up ===");
//           }
//         });

//     print("=== DEBUG: signUpUser() completed successfully ===");
//     return;
//   } on FirebaseAuthException catch (e) {
//     print("=== ERROR: FirebaseAuthException caught ===");
//     print("Error Code: ${e.code}, Message: ${e.message}");

//     if (e.code == "email-already-in-use") {
//       toast("email is already taken");
//     } else {
//       toast("something went wrong");
//     }
//   } catch (e) {
//     print("=== ERROR: Unknown exception caught ===");
//     print("Exception: $e");
//     toast("Unexpected error occurred");
//   }
// }


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
    if (user.profileUrl != "" && user.profileUrl != null) {
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
}
