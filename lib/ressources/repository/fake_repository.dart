import 'package:chedmed/models/user_response.dart';
import 'package:chedmed/models/user_request.dart';
import 'package:chedmed/models/category.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:dio/src/form_data.dart';

// class FakeApi implements ChedMedApi {
//   @override
//   Future<List<Category>> getAllCategories() async {
//     await Future.delayed(Duration(seconds: 2));
//     return ([
//       {"id": 1, "name": "Cat 1", "icon": null, "underCategory": []},
//       {
//         "id": 2,
//         "name": "Téléphones",
//         "icon": null,
//         "underCategory": [
//           {"id": 3, "name": "Smartphones", "category_id": 2},
//           {"id": 4, "name": "Accessoires", "category_id": 2}
//         ]
//       },
//       {"id": 3, "name": "Véhicules", "icon": null, "underCategory": []},
//       {"id": 4, "name": "Ordinateurs", "icon": null, "underCategory": []},
//       {
//         "id": 5,
//         "name": "Vétements",
//         "icon": null,
//         "underCategory": [
//           {"id": 5, "name": "Vetements pour hommes", "category_id": 5},
//           {"id": 6, "name": "Vetements pour femmes", "category_id": 5}
//         ]
//       },
//       {"id": 6, "name": "Meubles", "icon": null, "underCategory": []},
//       {
//         "id": 7,
//         "name": "Immobilier",
//         "icon": null,
//         "underCategory": [
//           {"id": 1, "name": "location", "category_id": 7},
//           {"id": 2, "name": "vente", "category_id": 7}
//         ]
//       },
//       {"id": 8, "name": "Divers", "icon": null, "underCategory": []}
//     ].map((e) => Category.fromJson(e)).toList());
//   }

//   @override
//   Future<UserResponse> signUp(UserRequest request) async {
//     return UserResponse(id: 69, username: "username", token: "token");
//   }

  
// }
