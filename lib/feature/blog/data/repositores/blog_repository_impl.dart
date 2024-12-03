// import 'dart:io';

// import 'package:blog_app/core/error/failures.dart';
// import 'package:blog_app/core/exceptions/server_exceptions.dart';

// import 'package:blog_app/feature/blog/data/datasource/blog_remote_data_source.dart';
// import 'package:blog_app/feature/blog/data/model/blog_model.dart';
// import 'package:blog_app/feature/blog/domain/entities/blog.dart';
// import 'package:blog_app/feature/blog/domain/repository/blog_repository.dart';
// import 'package:fpdart/fpdart.dart';

// import 'package:uuid/uuid.dart';

// class BlogRepositoryImpl implements BlogRepository {
//   BlogRemoteDataSource blogRemoteDataSource;
//   BlogRepositoryImpl({required this.blogRemoteDataSource});

//   @override
//   Future<Either<Failures, Blog>> uploadBlog(
//       {required File image,
//       required String title,
//       required String content,
//       required String posterId,
//       required List<String> topics}) async {
//     try {
//       BlogModel blogModel = BlogModel(
//           id: const Uuid().v1(),
//           posterId: posterId,
//           title: title,
//           content: content,
//           imageUrl: '',
//           topics: topics,
//           updatedAt: DateTime.now(),);

//       final String imageUrl = await blogRemoteDataSource.uploadBlogImage(
//           image: image, blog: blogModel);

//       blogModel = blogModel.copyWith(imageUrl: imageUrl);

//       return right(blogModel);
//     } on ServerExceptions catch (e) {
//       return left(
//         Failures(
//           e.toString(),
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failures, List<Blog>>> getAllBlogs() async {
//     try {
//       final blogs = await blogRemoteDataSource.getAllBlogs();
//       return right(blogs.map((blogModel) => blogModel as Blog).toList());
//     } on ServerExceptions catch (e) {
//       return left(
//         Failures(
//           e.toString(),
//         ),
//       );
//     }
//   }
// }
import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/exceptions/server_exceptions.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/feature/blog/data/datasource/blog_local_data_source.dart';
import 'package:blog_app/feature/blog/data/datasource/blog_remote_data_source.dart';
import 'package:blog_app/feature/blog/data/model/blog_model.dart';
import 'package:blog_app/feature/blog/domain/entities/blog.dart';
import 'package:blog_app/feature/blog/domain/repository/blog_repository.dart';

import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );
  @override
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures('No internet connection'));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerExceptions catch (e) {
      return left(Failures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failures(e.toString()));
    }
  }
}
