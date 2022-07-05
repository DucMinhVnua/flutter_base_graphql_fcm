/* 
  define base client GrapghQL (query & mutation)
  body: dữ liệu query or mutation
  variables: dữ liệu cung cấp cho body (nếu có)
  headers: headers (nếu có)
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base_graphql_fcm/utils/utils_constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AppBaseGraphQL {
  static Future<dynamic> callApi(
      {required BuildContext context,
      required String body,
      Map<String, dynamic>? variables,
      Map<String, String>? headers}) async {
    try {
      bool isConnectionAvailable = await checkInternetConnection();
      if (isConnectionAvailable == true) {
        final _httpLink = HttpLink(UtilsConstants().BASE_ENDPOINT,
            defaultHeaders: {"content-type": "application/json", ...headers!});

        final _authLink = AuthLink(
          getToken: () async => 'Bearer accessToken',
        );

        Link link = _authLink.concat(_httpLink);

        GraphQLClient client = GraphQLClient(
          cache: GraphQLCache(),
          link: link,
        );

        QueryOptions options = QueryOptions(
          document: gql(body),
          variables: variables!,
        );

        QueryResult queryResult = await client.query(options);
        // AppUtils.showPopup(
        //     context: context, title: "Thông báo", content: "show thành công");
        return queryResult;
      } else {
        // AppUtils.showPopup(
        //     context: context,
        //     title: "Thông báo",
        //     content: "Không có kết nối Internet.");
        return "";
      }
    } on Exception catch (e) {
      // AppUtils.showPopup(
      //     context: context, title: "Exception", content: e.toString());
    }
  }

  static Future<bool> checkInternetConnection() async {
    bool isConnect = false;
    try {
      // Tim kiem google.com
      final result = await InternetAddress.lookup('google.com');

      // check internet
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnect = true;
      }
    } on SocketException catch (_) {
      isConnect = false;
    }
    return isConnect;
  }
}
