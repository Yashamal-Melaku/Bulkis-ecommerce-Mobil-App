import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChapaPayment extends StatefulWidget {
  const ChapaPayment({super.key, required this.title});

  final String title;

  @override
  State<ChapaPayment> createState() => _ChapaPaymentState();
}

class _ChapaPaymentState extends State<ChapaPayment> {
  // final int _counter = 0;

  Future<void> verify() async {
    Map<String, dynamic> verificationResult =
        await Chapa.getInstance.verifyPayment(
      txRef: 'GENERATED_TRANSACTION_REFERENCE',
    );
  }

  Future<void> pay() async {
    // Generate a random transaction reference with a custom prefix
    try {
      String txRef = TxRefRandomGenerator.generate(prefix: 'Pharmabet');

      // Access the generated transaction reference
      String storedTxRef = TxRefRandomGenerator.gettxRef;

      // Print the generated transaction reference and the stored transaction reference
      print('Generated TxRef: $txRef');
      print('Stored TxRef: $storedTxRef');
      await Chapa.getInstance.startPayment(
        context: context,
        onInAppPaymentSuccess: (successMsg) {
          print('successMsg: ' + successMsg);
        },
        onInAppPaymentError: (errorMsg) {
          print('errorMsg: ' + errorMsg);
        },
        amount: '1000',
        currency: 'ETB',
        txRef: storedTxRef,
      );
    } on ChapaException catch (e) {
      if (e is AuthException) {
        print('authException');
      } else if (e is InitializationException) {
        print('initializationException');
      } else if (e is NetworkException) {
        print('networkException');
      } else if (e is ServerException) {
        print('serverException');
      } else {
        print('unknown error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapa payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'pay to Belki',
            ),
            TextButton(
                onPressed: () async {
                  await pay();
                },
                child: const Text("Pay")),
            TextButton(
                onPressed: () async {
                  await verify();
                },
                child: const Text("Verify")),
          ],
        ),
      ),
    );
  }
}
