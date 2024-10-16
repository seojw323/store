import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl 패키지 임포트

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final int availablePoints; // 사용 가능한 포인트

  const CartPage(
      {super.key, required this.cartItems, required this.availablePoints});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'ko_KR',
    symbol: '₩',
    decimalDigits: 0,
  );

  int _usedPoints = 0; // 사용한 포인트

  void _removeFromCart(int index) {
    setState(() {
      if (widget.cartItems[index]['quantity'] > 1) {
        widget.cartItems[index]['quantity']--;
      } else {
        widget.cartItems.removeAt(index);
      }
    });
  }

  void _addToCart(int index) {
    setState(() {
      widget.cartItems[index]['quantity']++;
    });
  }

  double _calculateProductTotal() {
    double total = 0.0;
    for (var item in widget.cartItems) {
      total += item['quantity'] *
          double.parse(item['price'].replaceAll('₩', '').replaceAll(',', ''));
    }
    return total;
  }

  double _calculateTotal() {
    return _calculateProductTotal() - _usedPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CART',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.cartItems.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              return _buildCartItem(item['title'], item['price'],
                  item['quantity'], item['image'], index);
            }),
            const Divider(),
            _buildPointsSection(),
            const Divider(),
            _buildSummaryRow(
                '상품 총 가격', _currencyFormat.format(_calculateProductTotal())),
            _buildSummaryRow(
                '포인트 할인', '-${_currencyFormat.format(_usedPoints)}'),
            _buildSummaryRow(
                '최종 합계', _currencyFormat.format(_calculateTotal())),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 결제하기 동작 추가
                },
                child: const Text('결제하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(
      String title, String price, int quantity, String imagePath, int index) {
    double itemTotal =
        quantity * double.parse(price.replaceAll('₩', '').replaceAll(',', ''));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            imagePath, // 이미지 경로 사용
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(price),
                Text('합계: ${_currencyFormat.format(itemTotal)}'), // 개별 합계 표시
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => _removeFromCart(index),
              ),
              Text(
                '$quantity',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _addToCart(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('사용 가능한 포인트: ${widget.availablePoints}'),
        Row(
          children: [
            SizedBox(
              width: 100, // 너비를 줄여 설정
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '포인트 입력',
                ),
                onChanged: (value) {
                  setState(() {
                    _usedPoints = int.tryParse(value) ?? 0;
                    if (_usedPoints > widget.availablePoints) {
                      _usedPoints = widget.availablePoints;
                    }
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _usedPoints = widget.availablePoints;
                });
              },
              child: const Text('전액 사용'),
            ),
          ],
        ),
        Text('사용할 포인트: $_usedPoints'),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
