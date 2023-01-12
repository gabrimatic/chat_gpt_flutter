import 'dart:convert';

class Choice {
  String? text;
  int? index;
  dynamic logprobs;
  String? finishReason;

  Choice({this.text, this.index, this.logprobs, this.finishReason});

  factory Choice.fromMap(Map<String, dynamic> data) => Choice(
        text: data['text'] as String?,
        index: data['index'] as int?,
        logprobs: data['logprobs'] as dynamic,
        finishReason: data['finish_reason'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'text': text,
        'index': index,
        'logprobs': logprobs,
        'finish_reason': finishReason,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Choice].
  factory Choice.fromJson(String data) {
    return Choice.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Choice] to a JSON string.
  String toJson() => json.encode(toMap());

  Choice copyWith({
    String? text,
    int? index,
    dynamic logprobs,
    String? finishReason,
  }) {
    return Choice(
      text: text ?? this.text,
      index: index ?? this.index,
      logprobs: logprobs ?? this.logprobs,
      finishReason: finishReason ?? this.finishReason,
    );
  }
}
