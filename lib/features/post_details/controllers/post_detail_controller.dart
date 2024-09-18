import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:knovator_test_app/models/post_model.dart';
import 'package:knovator_test_app/routes/routes.dart';
import 'package:knovator_test_app/utils/utils.dart';

class PostDetailController extends GetxController {
  var post = Post(id: 0, title: '', body: '', userId: 0).obs;
  var isLoading = true.obs;

  Future<void> fetchPostDetail(int postId) async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
      if (response.statusCode == 200) {
        post.value = Post.fromJson(json.decode(response.body));
      }
    } catch (e) {
      // print("Error fetching posts: $e");
      Utils.showToasterFailed('Something Went Wrong!');
      Get.toNamed(Routes.error);
    } finally {
      isLoading(false);
    }
  }
}
