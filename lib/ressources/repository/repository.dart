import 'package:chedmed/models/annonce_request.dart';
import 'package:chedmed/models/category.dart';
import 'package:chedmed/models/filter_request.dart';
import 'package:chedmed/models/user_request.dart';
import 'package:chedmed/models/user_response.dart';
import 'package:chedmed/models/annonce.dart';

import 'package:chedmed/ressources/repository/fake_repository.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part "repository_implementation.dart";
part 'repository.g.dart';

const BASE_URL = "http://192.168.60.216:5000/api/";

@RestApi(baseUrl: BASE_URL)
abstract class ChedMedApi {
  factory ChedMedApi(Dio dio, {String baseUrl}) = _ChedMedApi;

  @POST("/user/")
  Future<UserResponse> signUp(@Body() UserRequest request);

  @GET("/category/withunders/")
  Future<List<Category>> getAllCategories();

  @POST("/post/")
  Future addPost(FormData formdata);

  @POST("/post/filter")
  Future<List<Annonce>> filterPosts(@Body() FilterRequest request);
}

abstract class ChedMedApiFormData {
  factory ChedMedApiFormData(Dio dio, String baseUrl) = _ChedMedApiFormData;
  Future addPost(AnnonceRequest request);
}

final dio = Dio();

final chedMedApi = ChedMedApi(dio);
final chedMedApiFormData = ChedMedApiFormData(dio, BASE_URL);

//final chedMedApi = FakeApi();
