import 'dart:io';

import 'package:blog_app/core/general/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/general/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/snak_bar.dart';

import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/page/blog_page.dart';
import 'package:blog_app/feature/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;
  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    setState(() {
      image = pickedImage;
    });
  }

  void uploadBlog() {
    if (_formKey.currentState!.validate() &&
        image != null &&
        selectedTopics.isNotEmpty) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(UploadBlogEvent(
          posterId: posterId,
          title: _titleController.text,
          content: _contentController.text,
          topics: selectedTopics,
          image: image!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
        title: const Text('Add new blog'),
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.massage);
          } else if (state is BLogUploadBlogSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: selectImage,
                    child: DottedBorder(
                      radius: const Radius.circular(10),
                      borderType: BorderType.RRect,
                      color: AppPallete.borderColor,
                      strokeCap: StrokeCap.round,
                      dashPattern: const [10, 4],
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        child: image != null
                            ? Image.file(image!)
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Select your image',
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'Business',
                        'Technology',
                        'Programing',
                        'Entertainment'
                      ]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTopics.contains(e)) {
                                    selectedTopics.remove(e);
                                  } else {
                                    selectedTopics.add(e);
                                  }

                                  setState(() {});
                                },
                                child: Chip(
                                  color: selectedTopics.contains(e)
                                      ? const WidgetStatePropertyAll(
                                          AppPallete.gradient1)
                                      : null,
                                  side: selectedTopics.contains(e)
                                      ? null
                                      : const BorderSide(
                                          color: AppPallete.borderColor),
                                  label: Text(e),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  BlogEditor(
                      hintText: 'Blog title', controller: _titleController),
                  BlogEditor(
                      hintText: 'Blog discription',
                      controller: _contentController),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
