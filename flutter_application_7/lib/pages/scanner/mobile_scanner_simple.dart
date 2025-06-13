import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerSimple extends StatefulWidget {
  final String docCode;
  final String mode;

  const MobileScannerSimple({
    super.key,
    required this.docCode,
    required this.mode,
  });

  @override
  State<MobileScannerSimple> createState() => _MobileScannerSimpleState();
}

class _MobileScannerSimpleState extends State<MobileScannerSimple> {
  Barcode? _barcode;
  bool _isScanning = true;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (!_isScanning) return;

    final scanned = barcodes.barcodes.firstOrNull;
    if (scanned != null) {
      setState(() {
        _barcode = scanned;
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: _handleBarcode,
                  controller: MobileScannerController(),
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 2,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _barcode?.displayValue ?? 'Scan a barcode...',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_barcode != null) {
                          Navigator.pop(context, _barcode!.rawValue);
                        }
                      },
                      child: const Text('Search'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
