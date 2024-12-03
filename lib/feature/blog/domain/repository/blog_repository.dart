// import 'dart:io';

// import 'package:blog_app/core/error/failures.dart';
// import 'package:blog_app/feature/blog/domain/entities/blog.dart';
// import 'package:fpdart/fpdart.dart';

// abstract interface class BlogRepository {
//   Future<Either<Failures, Blog>> uploadBlog({
//     required File image,
//     required String title,
//     required String content,
//     required String posterId,
//     required List<String> topics,
//   });

//   Future<Either<Failures, List<Blog>>> getAllBlogs();
// }
import 'dart:io';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/feature/blog/domain/entities/blog.dart';

import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });
  Future<Either<Failures, List<Blog>>> getAllBlogs();
}
