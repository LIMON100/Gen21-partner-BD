import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../common/log_data.dart';
import '../models/booking_new_model.dart' as BookingModelNew;
import '../models/order_request_response_model.dart';
import '../models/orders_model.dart' as OrdersModel;

import '../../common/uuid.dart';
import '../models/address_model.dart';
import '../models/award_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/category_model.dart';
import '../models/custom_page_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/notification_model.dart';
import '../models/option_group_model.dart';
import '../models/option_model.dart';
import '../models/payment_model.dart';
import '../models/receive_booking_response.dart';
import '../models/review_model.dart';
import '../models/setting_model.dart';
import '../models/statistic.dart';
import '../models/user_model.dart';
import 'api_provider.dart';

class LaravelApiClient extends GetxService with ApiClient {
  dio.Dio _httpClient;
  dio.Options _optionsNetwork;
  dio.Options _optionsCache;
  int newBkId = 0;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    if (_httpClient == null) {
      BaseOptions options = new BaseOptions(
          baseUrl: this.baseUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: 60 * 1000, // 60 seconds
          receiveTimeout: 60 * 1000 // 60 seconds
          );
      _httpClient = new dio.Dio(options);
    }
  }

  Future<LaravelApiClient> init() async {
    if (foundation.kIsWeb || foundation.kDebugMode) {
      _optionsNetwork = dio.Options();
      _optionsCache = dio.Options();
    } else {
      _optionsNetwork = buildCacheOptions(Duration(days: 3), forceRefresh: true);
      _optionsCache = buildCacheOptions(Duration(minutes: 10), forceRefresh: false);
      _httpClient.interceptors.add(DioCacheManager(CacheConfig(baseUrl: getApiBaseUrl(""))).interceptor);
    }
    return this;
  }

  void forceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = dio.Options();
    }
  }

  void unForceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = buildCacheOptions(duration, forceRefresh: false);
    }
  }

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/user?version=2").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> login(User user) async {
    try {
      Uri _uri = getApiBaseUri("provider/login?version=2");
      printUri(StackTrace.current, _uri);
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(user.toJson()),
        options: _optionsNetwork,
      );
      print("jsdnfnsa: data ${json.encode(user.toJson())}");
      print("jsdnfnsa: response ${response.toString()}");

      if (response.data['success'] == true) {
        response.data['data']['auth'] = true;
        return User.fromJson(response.data['data']);
      } else {
        throw new Exception(response.data['message']);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw new Exception("Timeout occurred!");
      }
      if (e.type == DioErrorType.receiveTimeout) {
        throw new Exception("Timeout occurred!");
      }
    }
  }

  Future<User> register(User user) async {
    printWrapped("gen_log user.data: ${user.toString()}");
    Uri _uri = getApiBaseUri("provider/register?version=2");
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    print("RESPONSE DATA:  $response");
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      printWrapped("gen_log response.data: ${response.data}");
      return User.fromJson(response.data['data']);
    }
    else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    try {
      Uri _uri = getApiBaseUri("provider/send_reset_link_email?version=2");
      Get.log(_uri.toString());
      // to remove other attributes from the user object
      user = new User(email: user.email);
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(user.toJson()),
        options: _optionsNetwork,
      );
      printWrapped("ndsfdssdjn data: ${json.encode(user.toJson())}");
      printWrapped("ndsfdssdjn response: ${response.toString()}");
      if (response.data['success'] == true) {
        return true;
      } else {
        throw new Exception(response.data['message']);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw new Exception("Timeout occurred!");
      }
      if (e.type == DioErrorType.receiveTimeout) {
        throw new Exception("Timeout occurred!");
      }
    }
  }

  Future<User> updateUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/users/${user.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Statistic>> getHomeStatistics() async {
    print("getHomeStatistics");
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getHomeStatistics() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/dashboard").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Statistic>((obj) => Statistic.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
      // print("ERROR");
    }
  }

  Future<List<Address>> getAddresses() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:=',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Address>((obj) => Address.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> searchEServices(String keywords, List<String> categories, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'eProvider;categories',
      'version': '2'
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> createEService(EService eService) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(eService.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return EService.fromJson(response.data['data']);
      } else {
        throw new Exception(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<EService> updateEService(EService eService) async {
    if (!authService.isAuth || !eService.hasData) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_services/${eService.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.patchUri(
      _uri,
      data: json.encode(eService.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteEService(String eServiceId) async {
    if (!authService.isAuth || eServiceId == null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteEService(String eServiceId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_services/${eServiceId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Option> createOption(Option option) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("options").replace(queryParameters: _queryParameters);
    print(option.toJson());
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(option.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Option.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Option> updateOption(Option option) async {
    if (!authService.isAuth || !option.hasData) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("options/${option.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    print(option.toJson());
    var response = await _httpClient.patchUri(
      _uri,
      data: json.encode(option.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Option.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteOption(String optionId) async {
    if (!authService.isAuth || optionId == null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteOption(String optionId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("options/${optionId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EProvider> getEProvider(String eProviderId) async {
    const _queryParameters = {
      'with': 'eProviderType;availabilityHours;users',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EProvider>> getEProviders() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getEProviders() ]");
    }
    var _queryParameters = {
      'only': 'id;name',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/e_providers").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EProvider>((obj) => EProvider.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Review>> getEProviderReviews(String userId) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getEProviderReviews() ]");
    }
    var _queryParameters = {
      // 'with': 'eService;user',
      // 'only': 'id;review;rate;user;eService;created_at',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      // 'limit': '10',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/e_provider_reviews").replace(queryParameters: _queryParameters);
    printWrapped("skjnfjkndskja uri: $_uri");
    printUri(StackTrace.current, _uri);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    printWrapped("skjnfjkndskja response: ${response.toString()}");

    if (response.statusCode == 200) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      print("NO DATA FOUND");
      // throw new Exception(response.statusMessage);
    }
  }

  Future<Review> getEProviderReview(String reviewId) async {

    var _queryParameters = {
      'with': 'eService;user',
      'only': 'id;review;rate;user;eService',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_service_reviews/$reviewId").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Award>> getEProviderAwards(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("awards").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Award>((obj) => Award.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getEProviderExperiences(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'version': '2'

    };
    Uri _uri = getApiBaseUri("experiences").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Experience>((obj) => Experience.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderFeaturedEServices(int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderPopularEServices(int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderAvailableEServices(int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderMostRatedEServices(int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<User>> getEProviderEmployees(String eProviderId) async {
    var _queryParameters = {'with': 'users', 'only': 'users;users.id;users.name;users.email;users.phone_number;users.device_token', 'version': '2'};
    Uri _uri = getApiBaseUri("e_providers/$eProviderId").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getUsersByUserId(String userId) async {
    var _queryParameters = {
      'with': 'users',
      'only': 'users;users.id;users.name;users.email;users.phone_number;users.device_token',
      'user_id': userId,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("single_user").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['user'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderEServices(int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var _queryParameters = {
      'with': 'user',
      'only': 'created_at;review;rate;user',
      'search': "e_service_id:$eServiceId",
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'limit': '10',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_service_reviews").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {'with': 'options;options.media', 'only': 'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id;options.media', 'search': "options.e_service_id:$eServiceId", 'searchFields': 'options.e_service_id:=', 'orderBy': 'name', 'sortBy': 'desc','version': '2'};
    Uri _uri = getApiBaseUri("option_groups").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<OptionGroup>((obj) => OptionGroup.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<OptionGroup>> getOptionGroups() async {
    var _queryParameters = {'with': 'options', 'only': 'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id', 'orderBy': 'name', 'sortBy': 'desc', 'version': '2'};
    Uri _uri = getApiBaseUri("option_groups").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<OptionGroup>((obj) => OptionGroup.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<BookingModelNew.BookingNew>> getBookings(String statusId, int page) async {
    var _queryParameters = {'with': 'bookingStatus;payment;payment.paymentStatus', 'api_token': authService.apiToken, 'search': 'booking_status_id:${statusId}', 'orderBy': 'created_at', 'sortedBy': 'desc', 'limit': '4', 'offset': ((page - 1) * 4).toString(), 'version': '2'};
    Uri _uri = getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);

    print("BOOKING");
    print(response);
    if (response.data['success'] == true) {
      return response.data['data'].map<BookingModelNew.BookingNew>((obj) => BookingModelNew.BookingNew.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<BookingModelNew.BookingNew>> getBookingsNew(String statusId, int page, orderId) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'is_provider_app': '1',
      // 'booking_status_id': '${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '100',
      'id': orderId,
      // 'offset': ((page - 1) * 4).toString(),
      'version': '2'
    };

    Uri _uri = getApiBaseUri("booking-list").replace(queryParameters: _queryParameters);

    Get.log(_uri.toString());
    printWrapped("sdfasdfkha '_uri.toString()' ${_uri.toString()}");
    printWrapped("sdfasdfkha '_queryParameters' ${_queryParameters.toString()}");

    printWrapped("sdfasdfkha 'api_token': authService.apiToken : ${authService.apiToken}");

    // var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    var response = await _httpClient.postUri(_uri, options: _optionsNetwork);
    printWrapped("sdfasdfkha getBookingsNew response In provider APP: ${response.toString()}");

    printWrapped("sdfasdfkha response: ${response.toString()}");
    if (response.data['success'] == true) {
      return response.data['data'].map<BookingModelNew.BookingNew>((obj) => BookingModelNew.BookingNew.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<BookingStatus>> getBookingStatuses() async {
    final response = await rootBundle.loadString('config/statuses.json');
    final jsonResponse = await json.decode(response);
    print("fsjfsads5: ${jsonResponse.toString()}");
    print("fsjfsads6 status: ${jsonResponse['success']} data: ${jsonResponse['data']}");
    if (jsonResponse['success'] == true) {
      return jsonResponse['data'].map<BookingStatus>((obj) => BookingStatus.fromJson(obj)).toList();
    } else {
      throw new Exception(jsonResponse['message']);
    }
  }

  Future<BookingModelNew.BookingNew> getBooking(String bookingId) async {
    var _queryParameters = {
      'with': 'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("BOOKING DATA");
    print(response);

    if (response.data['success'] == true) {
      return BookingModelNew.BookingNew.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<BookingModelNew.BookingNew> getBookingDetails(String bookingId) async {
    var _queryParameters = {
      'with': 'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return BookingModelNew.BookingNew.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<BookingModelNew.BookingNew> updateBooking(BookingModelNew.BookingNew booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("bookings/${booking.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.putUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return BookingModelNew.BookingNew.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<BookingModelNew.BookingNew> updateBookingNew(BookingModelNew.BookingNew booking, String orderId) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': booking.id,
      'booking_status_id': booking.status.id,
      'version': '2'
    };
    printWrapped("jsdnfjksnakj _queryParameters  ${_queryParameters.toString()}");
    Uri _uri = getApiBaseUri("booking-status-update").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return BookingModelNew.BookingNew.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> updatePayment(Payment payment) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updatePayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/payments/${payment.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.putUri(_uri, data: payment.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  // Future<List<Notification>> getNotifications() async {
  //   if (!authService.isAuth) {
  //     throw new Exception("You don't have the permission to access to this area!".tr + "[ getNotifications() ]");
  //   }
  //   var _queryParameters = {
  //     'search': 'notifiable_id:${authService.user.value.id}',
  //     'searchFields': 'notifiable_id:=',
  //     'searchJoin': 'and',
  //     'orderBy': 'created_at',
  //     'sortedBy': 'desc',
  //     'limit': '50',
  //     'only': 'id;type;data;read_at;created_at',
  //     'api_token': authService.apiToken,
  //     'version': '2'
  //   };
  //   Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
  //   printUri(StackTrace.current, _uri);
  //   print("ndjkfnjka _queryParameters ${_queryParameters.toString()}");
  //   var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
  //   print("NOTIFICATION STATUS: $_uri");
  //   print("ndjkfnjka response ${response.toString()}");
  //
  //   return response.data.map<Notification>((obj) => Notification.fromJson(obj)).toList();
  // }

  // In LaravelApiClient.dart

  Future<List<Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw Exception("You don't have the permission to access to this area!".tr + "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    printWrapped("sjdnfjsajk ${_uri.toString()}");

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    printWrapped("sjdnfjsajk ${response.toString()}");

    // Check the response status and data structure
    if (response.statusCode == 200 && response.data['success'] == true) {
      // 1. Access the 'data' key, which holds the list
      List<dynamic> notificationList = response.data['data'];

      // 2. Now, call .map() on the list
      return notificationList.map<Notification>((obj) => Notification.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getNotifications()");
      throw Exception(response.data['message'] ?? 'Failed to get notifications');
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ markAsReadNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.patchUri(_uri, data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendNotification(List<User> users, User from, String type, String text, String id) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ sendNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
      'id': id,
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(data.toString());
    var response = await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ removeNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications/count").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("RRRRR");
    print(response);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("faq_categories").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<FaqCategory>((obj) => FaqCategory.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    print(response);
    if (response.data['success'] == true) {
      return response.data['data'].map<Faq>((obj) => Faq.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    final response = await rootBundle.loadString('config/settings.json');
    final jsonResponse = await json.decode(response);
    print("fsjfsads5: ${jsonResponse.toString()}");
    print("fsjfsads6 status: ${jsonResponse['success']} data: ${jsonResponse['data']}");
    if (jsonResponse['success'] == true) {
      return Setting.fromJson(jsonResponse['data']);
    } else {
      throw new Exception(jsonResponse['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    final response = await rootBundle.loadString('config/custom_pages.json');
    final jsonResponse = await json.decode(response);
    print("fsjfsads5: ${jsonResponse.toString()}");
    print("fsjfsads6 status: ${jsonResponse['success']} data: ${jsonResponse['data']}");
    if (jsonResponse['success'] == true) {
      return jsonResponse['data'].map<CustomPage>((obj) => CustomPage.fromJson(obj)).toList();
    } else {
      throw new Exception(jsonResponse['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id?version=2");
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadImage(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("uploads/store").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    var response = await _httpClient.postUri(_uri, data: formData);
    print(response.data);
    if (response.data['data'] != false) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<ReceiveBooking> acceptBookingRequest({var data}) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };

    Uri _uri = getApiBaseUri("order-accept").replace(queryParameters: _queryParameters);

    var newData = {"e_service": data["e_service"], "event_id": data["event_id"],
    "booking_status_id": data["booking_status_id"], "quantity": data["quantity"], "added_unit": data["added_unit"],
      "order_id": data["order_id"], "address_id": null, "booking_at": data["booking_at"]};
    print(newData);

    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: newData,
      options: Options(
        headers: {
          'Content-type': 'application/json',
        },
      ),
    );

    printWrapped("sjnfjkafyujhnma response ${response.toString()}");
    print("CHECKBOID");
    Map<String, dynamic> data2 = json.decode(response.toString());
    newBkId = data2['data']['id'];

    if (response.statusCode == 200) {
      print("dfbhaadsa in if");
      return ReceiveBooking.fromJson(response.data);

    } else {
      print("dfbhaadsa in else1234343");
      throw new Exception(response.data['message']);
    }
  }

  Future<OrdersModel.Orders> getOrders() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'order_by': "DESC",
      'limit': '100',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("provider/order-list").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("sjdnfab response ${response.toString()}");
    // if (response.data['success'] == true) {
    var temp = OrdersModel.Orders.fromJson(response.data);
    // var temp = OrderModel.fromJson(response.data);
    print("dsfajd ${temp.toString()}");
    return temp;
    // } else {
    //   throw new Exception(response.data['message']);
    // }
  }

  Future<OrderRequestResponse> getBookingRequestedServices(String orderId) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'order_id': orderId,
      'version': '2'
    };
    print("INSIDEORDERINFO");
    Uri _uri = getApiBaseUri("order-information").replace(queryParameters: _queryParameters);
    printWrapped("jsndjkfa url: ${_uri}");
    // Uri _uri = getApiBaseUri("order-information");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    printWrapped("jfnjsadhjdsdhs response ${response.toString()}");
    // if (response.data['success'] == true) {
    var temp = OrderRequestResponse.fromJson(response.data);
    // var temp = OrderModel.fromJson(response.data);
    printWrapped("jfnjsadhjdsdhs ${temp.toString()}");
    return temp;
  }

  Future updateProviderInfo(body, apiKey)  async{
    printWrapped("apiKey ${authService.apiToken} apiKey: $apiKey");
    var _queryParameters = {
      'api_token': apiKey,
      'version': '2'
    };

    printWrapped("gen_log body  ${body}");
    Uri _uri = getApiBaseUri("provider/update-provider").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    printWrapped("gen_log header  ${_httpClient.options.headers}");
    var response = await _httpClient.postUri(_uri, data: body, options: _optionsNetwork);
    printWrapped("response  ${response.toString()}");

    if (response.data['success'] == true) {
      return BookingModelNew.BookingNew.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
}
