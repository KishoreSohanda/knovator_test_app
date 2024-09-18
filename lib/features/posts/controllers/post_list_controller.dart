import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:knovator_test_app/models/post_model.dart';
import 'package:knovator_test_app/routes/routes.dart';
import 'package:knovator_test_app/utils/utils.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PostListController extends GetxController {
  var posts = <Post>[].obs;
  var isRead = <int, bool>{}.obs;
  var durations = <int, int>{};
  var elapsedTimes = <int, int>{}.obs;
  var timers = <int, Timer?>{}.obs;
  var visiblePosts = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedPosts = prefs.getStringList('posts');

    if (storedPosts != null) {
      List<Post> loadedPosts = storedPosts
          .map((postJson) => Post.fromJson(json.decode(postJson)))
          .toList();

      try {
        final response = await http
            .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
        if (response.statusCode == 200) {
          List<dynamic> jsonData = json.decode(response.body);
          var fetchedPosts =
              jsonData.map((json) => Post.fromJson(json)).toList();

          if (!_arePostsEqual(fetchedPosts, loadedPosts)) {
            posts.assignAll(fetchedPosts);
            _savePostsToLocalStorage(fetchedPosts);
          } else {
            posts.assignAll(loadedPosts);
          }
          _initializeTimers();
        }
      } catch (e) {
        // print("Error fetching posts: $e");
        Utils.showToasterFailed('Something Went Wrong!');
        Get.toNamed(Routes.error);
      }
    } else {
      _fetchPostsFromAPI();
    }
  }

  Future<void> _fetchPostsFromAPI() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        var fetchedPosts = jsonData.map((json) => Post.fromJson(json)).toList();
        posts.assignAll(fetchedPosts);
        _initializeTimers();
        _savePostsToLocalStorage(fetchedPosts);
      }
    } catch (e) {
      // print("Error fetching posts: $e");
      Utils.showToasterFailed('Something Went Wrong!');
      Get.toNamed(Routes.error);
    }
  }

  bool _arePostsEqual(List<Post> posts1, List<Post> posts2) {
    if (posts1.length != posts2.length) return false;
    for (int i = 0; i < posts1.length; i++) {
      if (posts1[i].id != posts2[i].id ||
          posts1[i].title != posts2[i].title ||
          posts1[i].body != posts2[i].body) {
        return false;
      }
    }
    return true;
  }

  void _initializeTimers() {
    for (var post in posts) {
      durations[post.id] = _getRandomDuration();
      elapsedTimes[post.id] = 0;
      if (visiblePosts.contains(post.id)) {
        _startTimer(post.id);
      }
    }
  }

  int _getRandomDuration() {
    List<int> possibleDurations = [10, 20, 25];
    possibleDurations.shuffle();
    return possibleDurations.first;
  }

  void _startTimer(int postId) {
    timers[postId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTimes[postId] = elapsedTimes[postId]! + 1;
      if (elapsedTimes[postId]! >= durations[postId]!) {
        timers[postId]?.cancel();
      }
    });
  }

  void pauseTimer(int postId) {
    timers[postId]?.cancel();
    timers[postId] = null;
  }

  void resumeTimer(int postId) {
    if (timers[postId] == null) {
      _startTimer(postId);
    }
  }

  Future<void> _savePostsToLocalStorage(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> postJsons =
        posts.map((post) => json.encode(post.toJson())).toList();
    prefs.setStringList('posts', postJsons);
  }

  void markPostAsRead(int postId) {
    isRead[postId] = true;
    pauseTimer(postId);
  }

  void onPostVisible(int postId) {
    if (!visiblePosts.contains(postId)) {
      visiblePosts.add(postId);
      resumeTimer(postId);
    }
  }

  void onPostInvisible(int postId) {
    if (visiblePosts.contains(postId)) {
      visiblePosts.remove(postId);
      pauseTimer(postId);
    }
  }
}
