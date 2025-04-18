// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/constants/custom_snackbar.dart';

class QrCodeScanner extends StatefulWidget {
  final String orderId;

  const QrCodeScanner({Key? key, required this.orderId}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 3, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: CustomButton(
                      onPressed: () {
                        if (result != null && result!.code == widget.orderId) {
                          updateOrderStatus();
                        } else {
                          customSnackbar(
                              context: context,
                              message: 'QR code does not match');
                        }
                      },
                      title: 'Finish',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      customSnackbar(context: context, message: 'Permission is not allowed');
    }
  }

  void updateOrderStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({'status': 'completed'});

      // Show success message
      customSnackbar(
        message: 'Order Successfuly Completed',
        context: context,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      // Handle errors
      print('Error updating order status: $e');

      customSnackbar(
          message: 'Error updating order status', backgroundColor: Colors.red);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}




// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:sellers/constants/custom_button.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class QrCodeScanner extends StatefulWidget {
//   final String orderId;
//   const QrCodeScanner({Key? key, required this.orderId}) : super(key: key);

//   @override
//   State<QrCodeScanner> createState() => _QrCodeScannerState();
// }

// class _QrCodeScannerState extends State<QrCodeScanner> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 3, child: _buildQrView(context)),
//           Expanded(
//             flex: 1,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   if (result != null)
//                     Text(
//                         'Barcode Type: ${(result!.format)}   Data: ${result!.code}')
//                   else
//                     const Text('Scan a code'),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.toggleFlash();
//                             setState(() {});
//                           },
//                           child: FutureBuilder(
//                             future: controller?.getFlashStatus(),
//                             builder: (context, snapshot) {
//                               return Text('Flash: ${snapshot.data}');
//                             },
//                           ),
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: Container(
//                           color: Colors.white,
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.flipCamera();
//                               setState(() {});
//                             },
//                             child: FutureBuilder(
//                               future: controller?.getCameraInfo(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.data != null) {
//                                   return Text(
//                                       'Camera facing ${(snapshot.data!)}');
//                                 } else {
//                                   return const Text('loading');
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: CustomButton(
//                           onPressed: () async {
//                             await controller?.pauseCamera();
//                           },
//                           title: 'pause',
//                           color: Colors.red,
//                           height: 50,
//                           width: 100,
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: CustomButton(
//                           onPressed: () async {
//                             await controller?.resumeCamera();
//                           },
//                           title: 'resume',
//                           height: 50,
//                           color: Colors.green,
//                           width: 120,
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 50),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (result != null && result!.code == widget.orderId) {
//                         // The scanned QR code matches the orderId
//                         updateOrderStatus();
//                       } else {
//                         // Show a message or perform any other action for a mismatch
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text('QR code does not match')),
//                         );
//                       }
//                     },
//                     child: const Text('Complete Order'),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         borderColor: Colors.red,
//         borderRadius: 10,
//         borderLength: 30,
//         borderWidth: 10,
//         cutOutSize: scanArea,
//       ),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No Permission')),
//       );
//     }
//   }

//   void updateOrderStatus() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(widget.orderId)
//           .update({'status': 'completed'});

//       // Add additional logic here if needed

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Order Completed')),
//       );
//     } catch (e) {
//       // Handle errors
//       print('Error updating order status: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error updating order status')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
