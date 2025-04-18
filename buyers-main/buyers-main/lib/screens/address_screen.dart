import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetStorage();
    String address = store.read('address');

    return Scaffold(
      body: Center(
        child: Text(
          address,
        ),
      ),
    );
  }
}
