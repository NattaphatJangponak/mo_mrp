final products = [
  {
    "id": 1,
    "title": "Product 1",
    "description": "lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    "imageUrl":
        "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
  },
  {
    "id": 2,
    "title": "Product 2",
    "description":
        "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "imageUrl":
        "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
  },
  {
    "id": 3,
    "title": "Product 3",
    "description":
        "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    "imageUrl":
        "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
  },
  {
    "id": 4,
    "title": "Product 4",
    "description":
        "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
    "imageUrl":
        "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
  },
  {
    "id": 5,
    "title": "Product 5",
    "description":
        "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "imageUrl":
        "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
  },
  {
    "id": 6,
    "title": "Product 6",
    "description":
        "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "imageUrl":
        "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
  },
  {
    "id": 7,
    "title": "Product 7",
    "description":
        "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "imageUrl":
        "https://cdn.grange.co.uk/assets/new-cars/lamborghini/revuelto/revuelto-1_20241107093150469.png"
  }
];

class MockSerialNumber {
  final String serialNumber;

  MockSerialNumber({required this.serialNumber});
}

final List<MockSerialNumber> snPageData = [
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
  MockSerialNumber(serialNumber: "sdsdun4-032g-gn6in"),
];

class ScannerMock {
  final int id;
  final String title;
  final int quantity;

  ScannerMock({
    required this.id,
    required this.title,
    required this.quantity,
  });
}

final List<ScannerMock> scannerPageData = [
  ScannerMock(id: 1, title: "Product 1", quantity: 10),
  ScannerMock(id: 2, title: "Product 2", quantity: 5),
  ScannerMock(id: 3, title: "Product 3", quantity: 8),
  ScannerMock(id: 4, title: "Product 4", quantity: 12),
  ScannerMock(id: 5, title: "Product 5", quantity: 7),
  ScannerMock(id: 6, title: "Product 6", quantity: 15),
];

// lib/data.dart

/// Mock data สำหรับรายการ stock
final List<Map<String, String>> mockStockList = [
  {'code': 'WH/IN/00003', 'po': 'PO0003'},
  {'code': 'WH/IN/00002', 'po': 'PO0002'},
  {'code': 'WH/IN/00001', 'po': 'PO0001'},
  {'code': 'WH/IN/00006', 'po': 'PO0006'},
  {'code': 'WH/IN/00003', 'po': 'PO0003'},
];

/// Mock data สำหรับรายการ stock
final List<Map<String, String>> mockStockList2 = [
  {'code': 'WH/OUT/00003', 'so': 'SO0003'},
  {'code': 'WH/OUT/00002', 'so': 'SO0002'},
  {'code': 'WH/OUT/00001', 'so': 'SO0001'},
  {'code': 'WH/OUT/00006', 'so': 'SO0006'},
  {'code': 'WH/OUT/00003', 'so': 'SO0003'},
];

class CountingItem {
  final String product;
  int quantity;
  bool selected;
  final String locationId;
  final String lotId;

  CountingItem({
    required this.product,
    required this.quantity,
    required this.locationId,
    required this.lotId,
    this.selected = true,
  });
}

final List<CountingItem> countingStockMock = [
  CountingItem(
      product: 'Product01', quantity: 3, locationId: 'LOC001', lotId: 'LOT001'),
  CountingItem(
      product: 'Product02', quantity: 5, locationId: 'LOC002', lotId: 'LOT002'),
  CountingItem(
      product: 'Product03', quantity: 2, locationId: 'LOC001', lotId: 'LOT003'),
  CountingItem(
      product: 'Product04', quantity: 1, locationId: 'LOC003', lotId: 'LOT004'),
  CountingItem(
      product: 'Product05', quantity: 2, locationId: 'LOC002', lotId: 'LOT005'),
  CountingItem(
      product: 'Product06', quantity: 3, locationId: 'LOC001', lotId: 'LOT006'),
  CountingItem(
      product: 'Product07', quantity: 4, locationId: 'LOC003', lotId: 'LOT007'),
  CountingItem(
      product: 'Product08', quantity: 5, locationId: 'LOC004', lotId: 'LOT008'),
];

class LotMock {
  final int id;
  final String lot;
  final String product;
  final int qty;

  LotMock({
    required this.id,
    required this.lot,
    required this.product,
    required this.qty,
  });
}

final List<LotMock> lotPageData = [
  LotMock(
    id: 1,
    lot: "Lot 1",
    product: "Product 1",
    qty: 10,
  ),
  LotMock(
    id: 2,
    lot: "Lot 2",
    product: "Product 2",
    qty: 5,
  ),
  LotMock(
    id: 3,
    lot: "Lot 3",
    product: "Product 3",
    qty: 8,
  ),
  LotMock(
    id: 4,
    lot: "Lot 4",
    product: "Product 4",
    qty: 12,
  ),
  LotMock(
    id: 5,
    lot: "Lot 5",
    product: "Product 5",
    qty: 7,
  ),
  LotMock(
    id: 6,
    lot: "Lot 6",
    product: "Product 6",
    qty: 15,
  ),
];
