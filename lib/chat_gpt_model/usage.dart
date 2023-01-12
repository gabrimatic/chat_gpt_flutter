import 'dart:convert';

class Usage {
  int? promptTokens;
  int? completionTokens;
  int? totalTokens;

  Usage({this.promptTokens, this.completionTokens, this.totalTokens});

  factory Usage.fromMap(Map<String, dynamic> data) => Usage(
        promptTokens: data['prompt_tokens'] as int?,
        completionTokens: data['completion_tokens'] as int?,
        totalTokens: data['total_tokens'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'prompt_tokens': promptTokens,
        'completion_tokens': completionTokens,
        'total_tokens': totalTokens,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Usage].
  factory Usage.fromJson(String data) {
    return Usage.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Usage] to a JSON string.
  String toJson() => json.encode(toMap());

  Usage copyWith({
    int? promptTokens,
    int? completionTokens,
    int? totalTokens,
  }) {
    return Usage(
      promptTokens: promptTokens ?? this.promptTokens,
      completionTokens: completionTokens ?? this.completionTokens,
      totalTokens: totalTokens ?? this.totalTokens,
    );
  }
}
