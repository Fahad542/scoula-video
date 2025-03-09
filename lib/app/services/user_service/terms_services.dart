import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:webinar/app/models/support_model.dart';
import 'package:webinar/common/utils/constants.dart';
import 'package:webinar/common/utils/http_handler.dart';
import 'package:dio/dio.dart' as dio;
import '../../../common/enums/error_enum.dart';
import '../../../common/utils/error_handler.dart';
import '../../models/terms_and_conditions_model.dart';

class TermService
{

  static Future<List<PrivacyData>> get_terms_and_conditions()async {
    List<PrivacyData> data = [];

    try {
      String url = '${Constants.baseUrl}providers/terms';


      Response res = await httpGetWithToken(
        url,
      );


      var jsonResponse = jsonDecode(res.body);
      if (jsonResponse['status'] == "200") {
        // Navigate to the 'response > data' path
        if (jsonResponse['response']?['data'] != null) {
          (jsonResponse['response']['data'] as List).forEach((json) {
            data.add(PrivacyData.fromJson(json));
          });

        }
        return data;
      } else {

        // Handle API error
        ErrorHandler().showError(
            ErrorEnum.error, jsonResponse['status_message'] ?? "Unknown error");
        return data;
      }
    } catch (e) {

      // Log the error for debugging
      print('Error fetching terms: $e');
      return data;
    }
  }}