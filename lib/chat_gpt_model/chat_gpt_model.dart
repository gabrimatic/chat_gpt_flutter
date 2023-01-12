import 'dart:convert';

import 'choice.dart';
import 'usage.dart';

class ChatGptModel {
  String? id;
  String? object;
  int? created;
  String? model;
  List<Choice>? choices;
  Usage? usage;

  ChatGptModel({
    this.id,
    this.object,
    this.created,
    this.model,
    this.choices,
    this.usage,
  });

  factory ChatGptModel.fromMap(Map<String, dynamic> data) => ChatGptModel(
        id: data['id'] as String?,
        object: data['object'] as String?,
        created: data['created'] as int?,
        model: data['model'] as String?,
        choices: (data['choices'] as List<dynamic>?)
            ?.map((e) => Choice.fromMap(e as Map<String, dynamic>))
            .toList(),
        usage: data['usage'] == null
            ? null
            : Usage.fromMap(data['usage'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'object': object,
        'created': created,
        'model': model,
        'choices': choices?.map((e) => e.toMap()).toList(),
        'usage': usage?.toMap(),
      };

  String get result {
    String res = '';
    if (choices == null) return 'IDK!';

    choices!.forEach((element) {
      res += '${element.text}\n';
    });
    return res;
  }

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChatGptModel].
  factory ChatGptModel.fromJson(String data) {
    return ChatGptModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChatGptModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ChatGptModel copyWith({
    String? id,
    String? object,
    int? created,
    String? model,
    List<Choice>? choices,
    Usage? usage,
  }) {
    return ChatGptModel(
      id: id ?? this.id,
      object: object ?? this.object,
      created: created ?? this.created,
      model: model ?? this.model,
      choices: choices ?? this.choices,
      usage: usage ?? this.usage,
    );
  }
}
