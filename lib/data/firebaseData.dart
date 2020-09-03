import 'package:tiktok_flutter/models/video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Video>> getVideoListForUser(String userId) async {
  var videoList = <Video>[];

  var videos = await FirebaseFirestore.instance
      .collection("Videos")
      .doc("AllVideos")
      .collection("VideoList")
      .get();

  videos.docs.forEach((element) {
    Video video = Video.fromJson(element.data());
    videoList.add(video);
  });

  var userData = await FirebaseFirestore.instance
      .collection("Users")
      .where("username", isEqualTo: userId)
      .get();

  var videosViewed = userData.docs[0].data()['videosViewed'];

  Map<String, bool> videosV = Map();

  videosViewed.forEach((video) {
    videosV[video] = true;
  });

  var filteredVideos = <Video>[];

  videoList.forEach((element) {
    if (videosV[element.id] == null || videosV[element.id] == false) {
      filteredVideos.add(element);
    }
  });

  return filteredVideos;
}

Future<bool> removeVideosFromFeed(String userId, List<String> videoIds) async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .update({"videosViewed": FieldValue.arrayUnion(videoIds)});
  return true;
}

Future<bool> clearHistory(String userId) async {
  var user =
      await FirebaseFirestore.instance.collection('Users').doc(userId).get();
  var listToRemove = user.data()['videosViewed'];
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .update({"videosViewed": FieldValue.arrayRemove(listToRemove)});
  return true;
}
