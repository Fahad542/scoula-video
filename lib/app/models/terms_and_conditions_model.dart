class Terms_and_conditions_model {
  final String status;
  final String statusMessage;
  final ResponseData response;

  Terms_and_conditions_model({
    required this.status,
    required this.statusMessage,
    required this.response,
  });

  factory Terms_and_conditions_model.fromJson(Map<String, dynamic> json) {
    return Terms_and_conditions_model(
      status: json['status'] as String,
      statusMessage: json['status_message'] as String,
      response: ResponseData.fromJson(json['response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_message': statusMessage,
      'response': response.toJson(),
    };
  }
}

class ResponseData {
  final List<PrivacyData> data;

  ResponseData({required this.data});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      data: (json['data'] as List<dynamic>)
          .map((e) => PrivacyData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class PrivacyData {
  final String privacyData;

  PrivacyData({required this.privacyData});

  factory PrivacyData.fromJson(Map<String, dynamic> json) {
    return PrivacyData(
      privacyData: json['privacydata'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privacydata': privacyData,
    };
  }
}
