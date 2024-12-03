// import 'dart:convert';

// import 'package:blog_app/feature/blog/domain/entities/blog.dart';

// class BlogModel extends Blog {
//   BlogModel({
//     required super.id,
//     required super.posterId,
//     required super.title,
//     required super.content,
//     required super.imageUrl,
//     required super.topics,
//     required super.updatedAt,
//     super.userName,
//   });

//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};

//     result.addAll({'id': id});
//     result.addAll({'poster_id': posterId});
//     result.addAll({'title': title});
//     result.addAll({'content': content});
//     result.addAll({'image_url': imageUrl});
//     result.addAll({'topics': topics});
//     result.addAll({'updated_at': updatedAt.toIso8601String()});
//     //toIso8601String is the method thats send the time as a string
//     //and send it to the backend but the backend will work with it as a time stamp

//     return result;
//   }

//   factory BlogModel.fromMap(Map<String, dynamic> map) {
//     return BlogModel(
//       id: map['id'] ?? '',
//       posterId: map['poster_id'] ?? '',
//       title: map['title'] ?? '',
//       content: map['content'] ?? '',
//       imageUrl: map['image_url'] ?? '',
//       topics: List<String>.from(map['topics']),
//       updatedAt: DateTime.parse(map['updated_at']),
//     );
//   }

//   BlogModel copyWith({
//     String? id,
//     String? posterId,
//     String? title,
//     String? content,
//     String? imageUrl,
//     List<String>? topics,
//     DateTime? updatedAt,
//     String? userName,
//   }) {
//     return BlogModel(
//       userName: userName ?? this.userName,
//       id: id ?? this.id,
//       posterId: posterId ?? this.posterId,
//       title: title ?? this.title,
//       content: content ?? this.content,
//       imageUrl: imageUrl ?? this.imageUrl,
//       topics: topics ?? this.topics,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory BlogModel.fromJson(String source) =>
//       BlogModel.fromMap(json.decode(source));
// }
import 'package:blog_app/feature/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
    super.posterName,
  });
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String,
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }
  BlogModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
