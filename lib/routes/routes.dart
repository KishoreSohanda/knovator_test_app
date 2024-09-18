import 'package:get/get.dart';
import 'package:knovator_test_app/features/error/screens/error_screen.dart';
import 'package:knovator_test_app/features/post_details/screens/post_detail_screen.dart';
import 'package:knovator_test_app/features/posts/screens/post_list_screen.dart';

class Routes {
  static const String postList = '/';
  static const String postDetail = '/post-detail';
  static const String error = '/error';
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.postList,
      page: () => const PostListScreen(),
    ),
    GetPage(
      name: Routes.postDetail,
      page: () => PostDetailScreen(postId: Get.arguments),
    ),
    GetPage(
      name: Routes.error,
      page: () => const ErrorScreen(),
    ),
  ];
}
