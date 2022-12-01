import 'package:chedmed/models/annonce_request.dart';
import 'package:chedmed/models/category.dart';
import 'package:chedmed/models/conversation.dart';
import 'package:chedmed/models/conversation_request.dart';
import 'package:chedmed/models/fav_request.dart';
import 'package:chedmed/models/favorite_request.dart';
import 'package:chedmed/models/filter_request.dart';
import 'package:chedmed/models/message_request.dart';
import 'package:chedmed/models/notification_check_response.dart';
import 'package:chedmed/models/notifications_request.dart';
import 'package:chedmed/models/profile.dart';
import 'package:chedmed/models/token_request.dart';
import 'package:chedmed/models/typing_request.dart';
import 'package:chedmed/models/user_request.dart';
import 'package:chedmed/models/user_response.dart';
import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/models/version_check.dart';

import 'package:chedmed/ressources/repository/fake_repository.dart';
import 'package:chedmed/ui/profile/profile.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../models/message.dart';
part "repository_implementation.dart";
part 'repository.g.dart';

const BASE_URL = "https://www.sahel-app.com/api/";
//const BASE_URL = "http://192.168.230.216:5000/api/";

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

  @POST("/notification/check/")
  Future<NotificationCheckResponse> checkNotifications(
      @Body() NotificationsRequest request);

  @POST("/notification/posts/")
  Future<List<Annonce>> getNotificationPosts(
      @Body() NotificationsRequest request);

  @POST("/version/")
  Future<VersionCheckResponse> versionCheck(
      @Body() VersionCheckRequest request);

  @GET("/conversation/withmessages/{page}/")
  Future<List<Conversation>> getConversations(@Path("page") int page);

  @GET("/conversation/{conversationId}/messages/{lastMessageId}/")
  Future<Conversation> getConversation(
    @Path("conversationId") int conversationId,
    @Path("lastMessageId") int lastMessageId,
  );

  @POST("/conversation/")
  Future<Conversation> createOrGetConversation(
      @Body() ConversationRequest request);

  @GET("/conversation/withUser/{id}/")
  Future<Conversation?> gatConversationWithUser(@Path("id") int receipientId);

  @POST("/message/")
  Future<Message> sendMessage(@Body() MessageRequest message);

  @POST("/message/typing/")
  Future<void> imTyping(@Body() TypingRequest typingRequest);

  @PUT("/user/updateToken/")
  Future<void> uptadeUserToken(@Body() TokenRequest message);

  @GET("/message/seen/{messageId}/")
  Future<void> markAsSeen(
    @Path("messageId") int messageId,
  );
}

abstract class ChedMedApiFormData {
  factory ChedMedApiFormData(Dio dio, String baseUrl) = _ChedMedApiFormData;
  Future addPost(AnnonceRequest request);
  Future editPost(AnnonceRequest request, int annoceId);
}

late Dio dio;
late ChedMedApi chedMedApi;
late ChedMedApiFormData chedMedApiFormData;

initSahelApi() {
  dio = Dio();
  chedMedApi = ChedMedApi(dio);
  chedMedApiFormData = ChedMedApiFormData(dio, BASE_URL);
}
//final chedMedApi = FakeApi();
