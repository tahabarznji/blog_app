part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogGetAllBlogSuccess extends BlogState {
  final List<Blog> blogs;

  BlogGetAllBlogSuccess({required this.blogs});
}

final class BLogUploadBlogSuccess extends BlogState {}

final class BlogFailure extends BlogState {
  final String massage;

  BlogFailure({required this.massage});
}

final class BlogLoading extends BlogState {}
