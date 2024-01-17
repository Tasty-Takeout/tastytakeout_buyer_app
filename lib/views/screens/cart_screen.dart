import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tastytakeout_user_app/data_sources/hardcode.dart' as data;
import 'package:tastytakeout_user_app/globals.dart';
import 'package:tastytakeout_user_app/views/widgets/cart_item.dart';
import 'package:tastytakeout_user_app/views/widgets/order_item.dart';
import '../../view_models/ListOrdersViewModel.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/cart_confirm_bottom_sheet.dart';

class CartController extends GetxController {
  final title = 'Cart'.obs;
}

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ListOrdersViewModel(), fenix: true);
    Get.lazyPut(() => CartController());
  }
}

class _CartPageState extends State<CartPage> {
  final _listCartViewModel = Get.find<ListOrdersViewModel>();
  final _cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _listCartViewModel.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: CustomAppBar(title: "Giỏ hàng"),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(
              color: Colors.grey.shade300,
              width: 0.0,
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 12.0, 0, 0.0),
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                if (_listCartViewModel.isLoading.value ||
                    _listCartViewModel.filteredCartList.isEmpty) {
                  String notification = '';
                  if (_listCartViewModel.isLoading.value) {
                    notification = 'Đang tải dữ liệu...';
                  } else if (_listCartViewModel.filteredCartList.isEmpty) {
                    notification = 'Hãy thêm món vào giỏ!';
                  }
                  return Center(
                    child: RefreshIndicator(
                        onRefresh: () async {
                          _listCartViewModel.fetchCart();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/resources/gif/loading.gif',
                              width: 150,
                              height: 150,
                            ),
                            Text(
                              notification,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                  );
                } else {
                  return RefreshIndicator(
                      onRefresh: () async {
                        _listCartViewModel.fetchCart();
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 0.0, 0, 4),
                        itemCount: _listCartViewModel.filteredCartList.length,
                        itemBuilder: (context, cartIndex) {
                          return Column(children: [
                            CartItemWidget(
                                cartIndex: cartIndex, clickable: true),
                          ]);
                        },
                      ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}
