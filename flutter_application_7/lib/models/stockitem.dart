class StockItem {
  final String code;
  final String? po;
  final String? so;

  StockItem({required this.code, this.po, this.so});

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      code: json['code'] ?? '',
      po: json['po'],
      so: json['so'],
    );
  }
}
