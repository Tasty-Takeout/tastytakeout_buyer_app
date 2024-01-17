import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tastytakeout_user_app/data_sources/hardcode.dart' as data;
import 'package:tastytakeout_user_app/models/DTO/OrderModel.dart';

import '../data_sources/cart_source.dart';
import '../data_sources/order_source.dart';
import '../globals.dart';

class ListOrdersViewModel extends GetxController {
  var orderList = <OrderModel>[].obs;
  var filteredOrderList = <OrderModel>[].obs;
  var cartList = <OrderModel>[].obs;
  var isLoading = true.obs;

  final List<String> OrderStatus = [
    data.PENDING,
    data.PREPARE,
    data.DELIVERING,
    data.COMPLETED
  ];
  List<String> selectedStatus = [data.PENDING];

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchOrders() async {
    //List<OrderModel> orders = data.orders;
    if (orderList.isEmpty) {
      isLoading.value = true;
    }

    orderList.value = await OrdersSource().fetchOrders();
    orderList.value.reversed;
    filterOrdersByStatus();
    isLoading.value = false;
  }

  Future<void> fetchCart() async {
    //List<OrderModel> carts = data.carts;
    if (cartList.isEmpty) {
      isLoading.value = true;
    }

    cartList.value = await CartSource().fetchCartInfoToPendingOrders();
    cartList.value.reversed;
    isLoading.value = false;
  }

  Future<bool> updateQuantity(int cartId, int quantity) async {
    final baseUrl = Uri.http(serverIp, '/carts/$cartId/');
    try {
      final response = await patch(
        baseUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxODg1OTUxNjI4LCJpYXQiOjE3MDQ1MTE2MjgsImp0aSI6IjU1MGFiOWU0MGM4MTQ2MDNhNmQxMjcxZjRiZjYxNmQ4IiwidXNlcl9pZCI6MTAsInJvbGUiOiJCVVlFUiJ9.Um--pPRWNG7VPh9F7ARYaRIn2Ab5yDvrpZvfsO9_9vA'
        },
        body: jsonEncode(
          <String, String>{
            'quantity': quantity.toString(),
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Error fetching cart detail');
      } else {
        fetchCart();
        return true;
      }
    } catch (e) {
      print('Error in updateQuantity ' + e.toString());
      return false;
    }
  }

  Future<bool> deleteCart(int cartId) async {
    final baseUrl = Uri.http(serverIp, '/carts/$cartId/');
    try {
      final response = await delete(
        baseUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxODg1OTUxNjI4LCJpYXQiOjE3MDQ1MTE2MjgsImp0aSI6IjU1MGFiOWU0MGM4MTQ2MDNhNmQxMjcxZjRiZjYxNmQ4IiwidXNlcl9pZCI6MTAsInJvbGUiOiJCVVlFUiJ9.Um--pPRWNG7VPh9F7ARYaRIn2Ab5yDvrpZvfsO9_9vA'
        },
      );
      if (response.statusCode != 204) {
        throw Exception('Error fetching cart detail');
      } else {
        fetchCart();
        return true;
      }
    } catch (e) {
      print('Error in deleteCart ' + e.toString());
      return false;
    }
  }

  void filterOrdersByStatus() {
    filteredOrderList.value =
        orderList.where((order) => order.status == selectedStatus[0]).toList();
  }

  void exportFromCartToOrder(int cartIndex) {
    cartList[cartIndex].status = data.PENDING;

    orderList.add(cartList[cartIndex]);
    selectedStatus[0] = data.PENDING;
    filterOrdersByStatus();
    cartList.removeAt(cartIndex);
  }
}
