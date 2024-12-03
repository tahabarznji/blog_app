// import 'dart:io';

// import 'package:blog_app/core/exceptions/server_exceptions.dart';
// import 'package:blog_app/feature/blog/data/model/blog_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// abstract interface class BlogRemoteDataSource {
//   Future<BlogModel> uploadBlog(BlogModel blogModel);
//   Future<String> uploadBlogImage({
//     required File image,
//     required BlogModel blog,
//   });
//   Future<List<BlogModel>> getAllBlogs();
// }

// class BlogRemoteDataSourceImpt implements BlogRemoteDataSource {
//   SupabaseClient supabaseClient;
//   BlogRemoteDataSourceImpt({required this.supabaseClient});

//   @override
//   Future<BlogModel> uploadBlog(BlogModel blog) async {
//     print('uploadBlog called');
//     print('blog: ${blog.toJson()}');

//     try {
//       final blogData =
//           await supabaseClient.from('blogs').insert(blog.toJson()).select();

//       print('blogData: $blogData');

//       return BlogModel.fromMap(blogData.first);
//     } on PostgrestException catch (e) {
//       print('PostgrestException');
//       print(e.toString());
//       throw ServerExceptions(massage: e.toString());
//     } catch (e) {
//       print('catch');
//       print(e.toString());
//       throw ServerExceptions(massage: e.toString());
//     }
//   }

//   @override
//   Future<String> uploadBlogImage(
//       {required File image, required BlogModel blog}) async {
//     try {
//       await supabaseClient.storage.from('blog_images').upload(blog.id, image);
//       return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
//     } catch (e) {
//       throw ServerExceptions(massage: e.toString());
//     }
//   }

//   @override
//   Future<List<BlogModel>> getAllBlogs() async {
//     try {
//       final List<dynamic> response =
//           await supabaseClient.from('blogs').select('*, profiles(*)');

//       final blogs = response
//           .map<BlogModel>(
//             (dynamic e) =>
//                 BlogModel.fromMap(e).copyWith(userName: e['profiles']['name']),
//           )
//           .toList();

//       return blogs;
//     } catch (e) {
//       throw ServerExceptions(massage: e.toString());
//     }
//   }
// }
import 'dart:io';

import 'package:blog_app/core/exceptions/server_exceptions.dart';
import 'package:blog_app/feature/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(massage: e.toString());
    } catch (e) {
      throw ServerExceptions(massage: e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(
            blog.id,
            image,
          );
      return supabaseClient.storage.from('blog_images').getPublicUrl(
            blog.id,
          );
    } on StorageException catch (e) {
      throw ServerExceptions(massage: e.toString());
    } catch (e) {
      throw ServerExceptions(massage: e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerExceptions(massage: e.toString());
    } catch (e) {
      throw ServerExceptions(massage: e.toString());
    }
  }
}
