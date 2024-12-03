// import 'package:blog_app/core/error/failures.dart';
// import 'package:blog_app/core/usecase/usecase.dart';
// import 'package:blog_app/feature/blog/domain/entities/blog.dart';
// import 'package:blog_app/feature/blog/domain/repository/blog_repository.dart';
// import 'package:fpdart/fpdart.dart';

// class GetAllBlogs implements Usecase<List<Blog>, NoParams> {
//   BlogRepository blogRepository;
//   GetAllBlogs({
//     required this.blogRepository,
//   });

//   @override
//   Future<Either<Failures, List<Blog>>> call(NoParams params) async {
//     return await blogRepository.getAllBlogs();
//   }
// }
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/blog/domain/entities/blog.dart';
import 'package:blog_app/feature/blog/domain/repository/blog_repository.dart';

import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements Usecase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);
  @override
  Future<Either<Failures, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
