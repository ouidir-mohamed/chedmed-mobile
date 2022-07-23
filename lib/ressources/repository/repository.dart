import 'package:chedmed/models/annonce_request.dart';
import 'package:chedmed/models/category.dart';
import 'package:chedmed/models/fav_request.dart';
import 'package:chedmed/models/favorite_request.dart';
import 'package:chedmed/models/filter_request.dart';
import 'package:chedmed/models/profile.dart';
import 'package:chedmed/models/user_request.dart';
import 'package:chedmed/models/user_response.dart';
import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/models/version_check.dart';

import 'package:chedmed/ressources/repository/fake_repository.dart';
import 'package:chedmed/ui/profile/profile.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part "repository_implementation.dart";
part 'repository.g.dart';

const BASE_URL = "http://51.77.137.247:5000/api/";

@RestApi(baseUrl: BASE_URL)
abstract class ChedMedApi {
  factory ChedMedApi(Dio dio, {String baseUrl}) = _ChedMedApi;

  @POST("/user/")
  Future<UserResponse> signUp(@Body() UserRequest request);

  @PUT("/user/")
  Future updateUser(@Body() UserRequest request);

  @GET("/category/withunders/")
  Future<List<Category>> getAllCategories();

  @POST("/post/")
  Future addPost(FormData formdata);

  @POST("/post/filter")
  Future<List<Annonce>> filterPosts(@Body() FilterRequest request);

  @GET("/post/{id}")
  Future<Annonce> getPostById(@Path("id") int postId);

  @POST("/post/profile")
  Future<List<Annonce>> userPosts();

  @POST("/post/favorite")
  Future<List<Annonce>> favoritePosts(@Body() FavoriteRequest request);

  @GET("/post/profile/{userId}")
  Future<List<Annonce>> userPostsById(@Path("userId") userId);

  @DELETE("/post/{annonceId}")
  Future deletePost(@Path("annonceId") annonceId);

  @POST("/favorite")
  Future addToFavorite(@Body() FavRequest request);

  @DELETE("/favorite")
  Future deleteFromFavorite(@Body() FavRequest request);

  @GET("/user/informations")
  Future<UserProfile> userInfo();

  @GET("/user/informations/{userId}")
  Future<UserProfile> userPublicInfo(@Path("userId") userId);

  @POST("/version/")
  Future<VersionCheckResponse> versionCheck(
      @Body() VersionCheckRequest request);
}

abstract class ChedMedApiFormData {
  factory ChedMedApiFormData(Dio dio, String baseUrl) = _ChedMedApiFormData;
  Future addPost(AnnonceRequest request);
  Future editPost(AnnonceRequest request, int annoceId);
}

final dio = Dio();

final chedMedApi = ChedMedApi(dio);
final chedMedApiFormData = ChedMedApiFormData(dio, BASE_URL);

//final chedMedApi = FakeApi();
