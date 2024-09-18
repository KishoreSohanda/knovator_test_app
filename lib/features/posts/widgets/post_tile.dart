import '../../../utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knovator_test_app/features/posts/controllers/post_list_controller.dart';
import 'package:knovator_test_app/models/post_model.dart';
import 'package:knovator_test_app/routes/routes.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final bool isRead;
  const PostTile({
    super.key,
    required this.post,
    required this.isRead,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final PostListController postListController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return VisibilityDetector(
        key: Key(widget.post.id.toString()),
        onVisibilityChanged: (visibilityInfo) {
          final visiblePercentage = visibilityInfo.visibleFraction * 100;

          if (visiblePercentage > 0) {
            postListController.onPostVisible(widget.post.id);
          } else {
            postListController.onPostInvisible(widget.post.id);
          }
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          color: postListController.isRead[widget.post.id] == true
              ? Colors.white
              : Colors.yellow[100],
          child: InkWell(
            onTap: () async {
              postListController.markPostAsRead(widget.post.id);
              await Get.toNamed(Routes.postDetail, arguments: widget.post.id);
              if (postListController.elapsedTimes[widget.post.id]! <
                  postListController.durations[widget.post.id]!) {}
              postListController.resumeTimer(widget.post.id);
            },
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  8.pw,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer),
                      8.pw,
                      Obx(() {
                        return Text(
                          '${postListController.elapsedTimes[widget.post.id] ?? 0} / ${postListController.durations[widget.post.id] ?? 0}s',
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
