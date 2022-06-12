part of 'repository.dart';

class _ChedMedApiFormData implements ChedMedApiFormData {
  final Dio _dio;
  String baseUrl;
  _ChedMedApiFormData(
    this._dio,
    this.baseUrl,
  );

  @override
  Future addPost(AnnonceRequest request) async {
    FormData formData = await request.toFormData();

    return _dio.post(baseUrl + "post/", data: formData);
  }
}
