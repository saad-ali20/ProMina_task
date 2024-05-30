import 'package:dio/dio.dart';
import 'package:my_gallery/models/images_resp_model.dart';
import 'package:my_gallery/models/user_model.dart';

class NetworkServices {
  static late Dio _dio;
  static String token = '';
  static List<MultipartFile> globalimageFileList = [];

  static Map<String, dynamic> headers = {
    'Connection': 'keep-alive',
    'Content-Type': 'application/json;charset=UTF-8',
    'Accept': 'application/json; charset=UTF-8',
    'Access-Control-Allow-Origin': '*',
  };
  static init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://flutter.prominaagency.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
    _dio.options.headers = headers;
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    _dio.options.headers = headers;

    return await _dio.get(
      url,
      queryParameters: query,
      options: Options(
        // followRedirects: false,
        // will not throw errors
        headers: {
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) => true,
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    Function? onSendProgress,
    required dynamic data,
  }) async {
    // if (sendToken)
    _dio.options.headers = headers;

    final response = await _dio.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) => true,
      ),
    );
    return response;
  }

  Future<UserModel> login(String username, String password) async {
    final formData = FormData.fromMap({
      'email': username,
      'password': password,
    });
    late var response;
    try {
      response = await postData(
        url: 'auth/login',
        data: formData,
      );
    } catch (e) {
      throw Exception('Failed to login');
    }

    if (response.statusCode == 200) {
      token = response.data['token'];
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> addImages() async {
    String url = "upload";
    try {
      FormData formData = FormData.fromMap({"img": globalimageFileList});
      await postData(
        url: url,
        data: formData,
      ).then((value) {
        globalimageFileList.clear();
      });
    } catch (e) {
      throw Exception('Failed to upload images');
    }
  }

  static List<String> images = [];
  Future<List<String>> getImages() async {
    final response = await getData(url: 'my-gallery');
    if (response.statusCode == 200) {
      images = ImagesResponseModel.fromJson(response.data).data.images;
      return images;
    } else {
      throw Exception('Failed to load images');
    }
  }
}
