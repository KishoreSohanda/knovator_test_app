import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knovator_test_app/features/posts/controllers/post_list_controller.dart';
import 'package:knovator_test_app/features/posts/widgets/post_tile.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostListController postListController = Get.put(PostListController());
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Obx(() {
        if (postListController.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: postListController.posts.length,
          itemBuilder: (context, index) {
            var post = postListController.posts[index];
            bool isRead = postListController.isRead[post.id] ?? false;

            return PostTile(
              isRead: isRead,
              post: post,
            );
          },
        );
      }),
    );
  }
}
