import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knovator_test_app/features/post_details/controllers/post_detail_controller.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;

  PostDetailScreen({super.key, required this.postId});

  final PostDetailController postDetailController =
      Get.put(PostDetailController());

  @override
  Widget build(BuildContext context) {
    postDetailController.fetchPostDetail(postId);

    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: Obx(() {
        if (postDetailController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        var post = postDetailController.post.value;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(post.body, style: const TextStyle(fontSize: 18)),
            ],
          ),
        );
      }),
    );
  }
}
