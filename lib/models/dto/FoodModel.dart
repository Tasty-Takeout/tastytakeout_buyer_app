/* json data of food
[
  {
    "id": 0,
    "category": {
      "id": 0,
      "name": "string"
    },
    "store": {
      "id": 0,
      "owner": 0,
      "name": "string",
      "image_url": "string",
      "address": "string"
    },
    "comments": [
      {
        "content": "string",
        "rating": 2147483647
      }
    ],
    "image_urls": "string",
    "name": "string",
    "description": "string",
    "price": 2147483647,
    "quantity": 2147483647,
    "created_at": "2024-01-04T17:54:03.879Z",
    "rating": 0
  }
]
 */

class FoodModel {
  late final int id;
  late List<String> imageUrls;
  late final String name;
  late final String description;
  late final int price;
  late int quantity;
  late final String createdAt;
  late final int rating;
  late final int storeId;
  late final String storeName;
  late final int categoryId;
  late final String categoryName;

  FoodModel({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.price = 0,
    this.quantity = 0,
    this.createdAt = '',
    this.rating = 0,
    this.storeId = 0,
    this.storeName = '',
    this.categoryId = 0,
    this.categoryName = '',
    this.imageUrls = const [],
  });

  void setQuantity(int setQuantity) {
    this.quantity = setQuantity;
  }

  int getQuantity() {
    return quantity;
  }

  static Future<FoodModel> defaultModel() {
    return Future.value(FoodModel(id: -1));
  }
}
