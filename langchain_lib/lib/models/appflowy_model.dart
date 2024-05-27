import 'package:json_annotation/json_annotation.dart';

part 'appflowy_model.g.dart';

@JsonSerializable()
class Root {
  final Document document;

  Root({required this.document});

  factory Root.fromJson(Map<String, dynamic> json) => _$RootFromJson(json);
  Map<String, dynamic> toJson() => _$RootToJson(this);
}

@JsonSerializable()
class Document {
  final String typeField;
  final List<Children> children;

  Document({required this.typeField, required this.children});

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}

@JsonSerializable()
class Children {
  final String typeField;
  final Data data;

  Children({required this.typeField, required this.data});

  factory Children.fromJson(Map<String, dynamic> json) =>
      _$ChildrenFromJson(json);
  Map<String, dynamic> toJson() => _$ChildrenToJson(this);
}

@JsonSerializable()
class Data {
  final int? level;
  final List<Delum> delta;
  final String? align;

  Data({this.level, required this.delta, this.align});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Delum {
  final String insert;
  final Attributes? attributes;

  Delum({required this.insert, this.attributes});

  factory Delum.fromJson(Map<String, dynamic> json) => _$DelumFromJson(json);
  Map<String, dynamic> toJson() => _$DelumToJson(this);
}

@JsonSerializable()
class Attributes {
  final bool? bold;
  final bool? italic;
  final String? file;
  final String? sql;

  Attributes({this.bold, this.italic, this.file, this.sql});

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);
  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
