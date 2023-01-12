import 'dart:convert';

class Error {
	String? message;
	String? type;
	dynamic param;
	dynamic code;

	Error({this.message, this.type, this.param, this.code});

	factory Error.fromMap(Map<String, dynamic> data) => Error(
				message: data['message'] as String?,
				type: data['type'] as String?,
				param: data['param'] as dynamic,
				code: data['code'] as dynamic,
			);

	Map<String, dynamic> toMap() => {
				'message': message,
				'type': type,
				'param': param,
				'code': code,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Error].
	factory Error.fromJson(String data) {
		return Error.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Error] to a JSON string.
	String toJson() => json.encode(toMap());

	Error copyWith({
		String? message,
		String? type,
		dynamic param,
		dynamic code,
	}) {
		return Error(
			message: message ?? this.message,
			type: type ?? this.type,
			param: param ?? this.param,
			code: code ?? this.code,
		);
	}
}
