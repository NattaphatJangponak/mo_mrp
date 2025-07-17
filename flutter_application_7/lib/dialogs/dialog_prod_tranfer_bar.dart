import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_7/pages/scanner/dialog_qr_add_text.dart';

//..............................................................

String extractBarcode(String barcode) {
  final RegExp regExp = RegExp(r'\[(.*?)\]'); // ใช้ regex หาค่าที่อยู่ใน []
  final match = regExp.firstMatch(barcode);

  // ถ้ามีค่าผลลัพธ์จากการ match จะดึงออกมา
  if (match != null) {
    return match.group(1) ?? ''; // กลับค่าภายในวงเล็บเหลี่ยม
  } else {
    return ''; // ถ้าไม่พบค่าภายในวงเล็บเหลี่ยม
  }
}

void showTransferProductDialogBar(
    BuildContext context, String code, String barcode, String qty) {
  String qtyFormatted = qty;
  if (qty.isNotEmpty) {
    List<String> qtyParts = qty.split(':');
    if (qtyParts.length > 1) {
      String numericQty = qtyParts[1].trim();
      if (numericQty.contains('.')) {
        qtyFormatted = numericQty.split('.')[0];
      } else {
        qtyFormatted = numericQty;
      }
    }
  }

  final barcodeController = TextEditingController(text: barcode);
  final issueQtyController = TextEditingController(text: qtyFormatted);
  final locationFromController = TextEditingController();
  final locationToController = TextEditingController();
  final barcodeFocus = FocusNode();
  TextEditingController? currentFocusController;

  // สร้างค่าของ barcode ที่แยกออกมาแล้วจากวงเล็บเหลี่ยม
  String extractedBarcode = extractBarcode(barcode);
  print("Extracted Barcode: $extractedBarcode"); // ตรวจสอบผลลัพธ์

  // อัพเดตค่า barcodeController ด้วยค่า extractedBarcode
  barcodeController.text = extractedBarcode;
  // ValueNotifier สำหรับการเก็บข้อมูล location
  ValueNotifier<List<String>> locationListNotifier = ValueNotifier([]);

  String? selectedLocationFrom;

  String? selectedLocationTo; // เพิ่มตัวแปรสำหรับ Location To

  Future<void> _fetchLocationData() async {
    final String url = 'http://192.168.1.122:8069/get_list_location';
    final uri = Uri.parse(url);

    final request = http.Request("GET", uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      })
      ..body = jsonEncode({});

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);

      if (jsonMap.containsKey('result')) {
        final List<dynamic> resultList = jsonMap['result'];
        // อัพเดทข้อมูลใน ValueNotifier
        locationListNotifier.value =
            resultList.map((e) => e['code'] as String).toList();
      } else {
        throw Exception('⚠️ No "result" key found');
      }
    } else {
      throw Exception('❌ Failed to load locations');
    }
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Transfer Barcode"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: code,
                    enabled: false,
                    decoration: const InputDecoration(labelText: 'Code'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: barcodeController,
                    focusNode: barcodeFocus,
                    decoration: const InputDecoration(labelText: 'Barcode'),
                    onTap: () => currentFocusController = barcodeController,
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 12),

                  // Location From Dropdown
                  FutureBuilder<void>(
                    future: _fetchLocationData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return DropdownButton<String>(
                          value: selectedLocationFrom,
                          hint: const Text('Select Location From'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLocationFrom =
                                  newValue; // อัปเดต selectedLocationFrom
                            });
                          },
                          items: locationListNotifier.value
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Location To Dropdown
                  FutureBuilder<void>(
                    future: _fetchLocationData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return DropdownButton<String>(
                          value: selectedLocationTo,
                          hint: const Text('Select Location To'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLocationTo =
                                  newValue; // อัปเดต selectedLocationTo
                            });
                          },
                          items: locationListNotifier.value
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),

                  TextFormField(
                    controller: issueQtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Issue Qty'),
                  ),

                  const SizedBox(height: 12),

                  const SizedBox(height: 12),
                  // Location from dropdown
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                tooltip: 'Scan QR',
                onPressed: () async {
                  final result = await showQrScannerDialog(context);
                  if (result != null && currentFocusController != null) {
                    final text = currentFocusController!.text;
                    final selection = currentFocusController!.selection;

                    final newText = text.replaceRange(
                      selection.start,
                      selection.end,
                      result,
                    );

                    currentFocusController!.text = newText;
                    currentFocusController!.selection = TextSelection.collapsed(
                      offset: selection.start + result.length,
                    );
                  }
                },
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  // สร้าง payload ในรูปแบบที่ต้องการ
                  final payload = {
                    "jsonrpc": "2.0",
                    "params": {
                      "code": code,
                      "barcode": barcodeController.text.trim(), // Barcode
                      "location_from":
                          selectedLocationFrom ?? "", // Location from
                      "location_to": selectedLocationTo ?? "", // Location to
                      "transfer_qty":
                          int.tryParse(issueQtyController.text.trim()) ??
                              0, // Transfer quantity
                    }
                  };

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("📦 Sending JSON:\n${jsonEncode(payload)}"),
                  ));

                  try {
                    // ส่ง POST request ไปยัง API
                    final response = await http.post(
                      Uri.parse(
                          "http://192.168.1.122:8069/set_tranfer_location_barcode"),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode(payload), // แปลงข้อมูลเป็น JSON
                    );

                    if (response.statusCode == 200) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Success")),
                      );
                      print("📦 Sending JSON:\n${jsonEncode(payload)}");
                    } else {
                      throw Exception("Failed: ${response.statusCode}");
                    }
                  } catch (e) {
                    // จัดการข้อผิดพลาดจากการส่งคำขอ
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Error: $e")),
                    );
                  }
                },
                child: const Text("Add"),
              )
            ],
          );
        },
      );
    },
  );

  // เรียกใช้ _fetchLocationData เพื่อดึงข้อมูล
  _fetchLocationData();
}
