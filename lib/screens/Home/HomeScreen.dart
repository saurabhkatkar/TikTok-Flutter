import 'package:flutter/material.dart';
import 'package:tiktok_flutter/bloc/videos.bloc.dart';
import 'package:tiktok_flutter/data/videos_api.dart';
import 'package:tiktok_flutter/models/video.dart';
import 'package:tiktok_flutter/widgets/actions_toolbar.dart';
import 'package:tiktok_flutter/widgets/video_description.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatelessWidget {
  static final VideosBloc videosBloc = VideosBloc(VideosAPI());
  final Stream<List<Video>> listVideos = videosBloc.listVideos;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
              child: Center(
                  child: StreamBuilder(
                      initialData: List<Video>(),
                      stream: listVideos,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        List<Video> videos = snapshot.data;
                        if (videos.length > 0) {
                          return PageView.builder(
                            controller: PageController(
                              initialPage: 0,
                              viewportFraction: 1,
                            ),
                            onPageChanged: (index) {
                              index = index % (videos.length);
                              int prev = (index - 1) % (videos.length);
                              int next = (index + 1) % (videos.length);

                              videosBloc.videoManager
                                  .changeVideo(index, prev, next);
                            },
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              index = index % (videos.length);
                              return VideoCard(
                                  video: videosBloc
                                      .videoManager.listVideos[index]);
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }))),
        ),
      ],
    );
  }
}

class VideoCard extends StatelessWidget {
  final Video video;

  const VideoCard({Key key, this.video}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = video.controller;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        controller != null && controller.value.initialized
            ? GestureDetector(
                onTap: () {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                },
                child: SizedBox.expand(
                    child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size?.width ?? 0,
                    height: controller.value.size?.height ?? 0,
                    child: VideoPlayer(controller),
                  ),
                )))
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  LinearProgressIndicator(),
                  SizedBox(
                    height: 56,
                  )
                ],
              ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                VideoDescription(video.user, video.videoTitle, video.songName),
                ActionsToolbar(video.likes, video.comments, video.userPic),
              ],
            ),
            SizedBox(height: 65)
          ],
        )
      ],
    );
  }
}
