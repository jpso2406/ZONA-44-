import 'package:flutter/material.dart';

class OrderAdminLoading extends StatelessWidget {
  const OrderAdminLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
