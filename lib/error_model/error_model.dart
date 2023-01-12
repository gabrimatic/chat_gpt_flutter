import 'dart:convert';

import 'error.dart';

class ErrorModel {
	Error? error;

	ErrorModel({this.error});

	factory ErrorModel.fromMap(Map<String, dynamic> data) => ErrorModel(
				error: data['error'] == null
						? null
						: Error.fromMap(data['error'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'error': error?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ErrorModel].
	factory ErrorModel.fromJson(String data) {
		return ErrorModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ErrorModel] to a JSON string.
	String toJson() => json.encode(toMap());

	ErrorModel copyWith({
		Error? error,
	}) {
		return ErrorModel(
			error: error ?? this.error,
		);
	}
}
