import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogPost {
  final int id;
  final String title;
  final String briefDescription;
  final String date;
  final String picture;
  final String file;

  BlogPost({
    required this.id,
    required this.title,
    required this.briefDescription,
    required this.date,
    required this.picture,
    required this.file,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      briefDescription: json['brief_description'],
      date: json['date'],
      picture: json['picture'],
      file: json['file'],
    );
  }
}

class BlogApi {
  static const String baseUrl = 'http://192.168.124.222:8000';

  Future<List<BlogPost>> fetchBlogPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/blog_list'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<BlogPost> blogPosts =
          body.map((dynamic item) => BlogPost.fromJson(item)).toList();
      return blogPosts;
    } else {
      throw Exception('Failed to load blog posts');
    }
  }

  Future<BlogPost> fetchLatestBlog() async {
    final blogPosts = await fetchBlogPosts();
    blogPosts.sort((a, b) => b.date.compareTo(a.date));
    return blogPosts.first;
  }
}
