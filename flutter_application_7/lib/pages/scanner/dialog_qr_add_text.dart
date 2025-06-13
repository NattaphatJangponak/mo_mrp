import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> showQrScannerDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const DialogQrScanner(),
  );
}

class DialogQrScanner extends StatefulWidget {
  const DialogQrScanner({super.key});

  @override
  State<DialogQrScanner> createState() => _DialogQrScannerState();
}

class _DialogQrScannerState extends State<DialogQrScanner> {
  Barcode? _barcode;
  bool _isScanning = true;
  final MobileScannerController _controller = MobileScannerController();

  void _handleBarcode(BarcodeCapture capture) {
    if (!_isScanning) return;

    final scanned = capture.barcodes.firstOrNull;
    if (scanned != null) {
      setState(() {
        _barcode = scanned;
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text(
        'Scan QR Code',
        style: TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          children: [
            // 👁️ กล้องสแกน
            MobileScanner(
              controller: _controller,
              onDetect: _handleBarcode,
            ),

            // 🔲 กรอบสี่เหลี่ยมตรงกลาง
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
              ),
            ),

            // ➖ เส้นขั้นกลางแนวนอน (พาดกลางกรอบ)
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 180,
                height: 2,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Text(
          _barcode?.displayValue ?? 'Scan a barcode...',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: _barcode != null
              ? () => Navigator.pop(context, _barcode!.rawValue)
              : null,
          child: Text(_barcode != null ? 'Add' : 'Waiting...'),
        ),
      ],
    );
  }
}
