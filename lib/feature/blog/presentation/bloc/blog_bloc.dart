import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/blog/domain/entities/blog.dart';
import 'package:blog_app/feature/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecase/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<UploadBlogEvent>(_onUploadBlogEvent);
    on<BlogGetAllBlogs>(_onBlogGetAllBlogs);
  }

  void _onBlogGetAllBlogs(
      BlogGetAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs.call(NoParams());
    res.fold(
      (l) => emit(
        BlogFailure(
          massage: l.toString(),
        ),
      ),
      (r) => emit(
        BlogGetAllBlogSuccess(blogs: r),
      ),
    );
  }

  void _onUploadBlogEvent(
      UploadBlogEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog.call(
      UploadBlogParams(
          image: event.image,
          title: event.title,
          content: event.content,
          posterId: event.posterId,
          topics: event.topics),
    );
    res.fold(
      (l) => emit(BlogFailure(massage: l.toString())),
      (r) => emit(BLogUploadBlogSuccess()),
    );
  }
}
