import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'global_variable.dart';

class ApiClient {
  final Dio _dio = Dio(); //Initialize dio

  //Login uses a post request method(email and password are required).
  Future login(email, password) async {
    try {
      Response response = await _dio.post(
        endPoint + '/user/login',
        data: {"email": email, "password": password},
      );

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  //Load all available contributors from Api database with get request method(accessToken required)
  Future contributors(accessToken) async {
    try {
      Response response = await _dio.get(endPoint + '/contributor',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }));

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  //Load all available contribution from Api database with get request method(accessToken required)
  Future contribution(accessToken) async {
    try {
      Response response = await _dio.get(endPoint + '/self-contribution',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }));

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  //Load all users in-order to get agent, get request method(accessToken required)
  Future getUserData(accessToken) async {
    try {
      Response response = await _dio.get(endPoint + '/auth/info',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  //Register User, post request method(email, firstName, lastName, phoneNumber, Password required)
  Future registerUser(email, firstname, lastname, phone_number, password) async {
    try {
      Response response = await _dio.post(
        endPoint + '/public/user/sign-up',
        data: {
          "email": email,
          "firstName": firstname,
          "lastName": lastname,
          "mobileNumber": phone_number,
          "password": password
        },
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  //Create a Contributor, post request method (firstName, lastName, address, phoneNumber, agentId, accessToken required)
  Future createContributor(firstName, lastName, address, mobileNumber, agent_id, accessToken) async {
    try {
      Response response = await _dio.post(endPoint + '/contributor',
          data: {
            "firstName": firstName,
            "lastName": lastName,
            "mobileNumber": mobileNumber,
            "address": address,
            "agent": agent_id,
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  //Create a Contribution, post request method (agentId, contributorId, contributionPlan, name, goal, startDate, endDate, accessToken required)
  Future createContribution(agentId, contributorId, contributionPlan, name, goal, startDate, endDate, accessToken) async {
    try {
      Response response = await _dio.post(
          endPoint + '/self-contribution/${contributorId}',
          data: {
            "agent": agentId,
            "contributor": contributorId,
            "contributionPlan": contributionPlan,
            "name": name,
            "goal": goal,
            "startDate": startDate,
            "endDate": endDate,
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

//Add Money to a contribution, this is an attempt to update a contribution so we use Put request Method(required field: contributionId, addedAmount, accessToken, date is auto-generated.)
  Future addMoney(contributionId, addedAmount, accessToken) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    try {
      Response response = await _dio.put(
          endPoint + '/self-contribution/${contributionId}',
          data: {'amount': addedAmount, 'date': formattedDate},
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
