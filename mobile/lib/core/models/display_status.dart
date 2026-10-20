import 'package:json_annotation/json_annotation.dart';

/// Lima status submission di UI; dihitung server (docs/erd.md).
@JsonEnum(fieldRename: FieldRename.snake)
enum DisplayStatus { assigned, missing, turnedIn, graded, returned }

@JsonEnum(fieldRename: FieldRename.snake)
enum CourseRole { teacher, student }
