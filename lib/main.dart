import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const ShopPage(),
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  ShopPageState createState() => ShopPageState();
}

class ShopPageState extends State<ShopPage> {
  final List<Map<String, dynamic>> _cartItems = [];

  void _addToCart(String title, String price, String imagePath) {
    setState(() {
      int index = _cartItems.indexWhere((item) => item['title'] == title);
      if (index != -1) {
        _cartItems[index]['quantity']++;
      } else {
        _cartItems.add({
          'title': title,
          'price': price,
          'quantity': 1,
          'image': imagePath
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title이(가) 장바구니에 담겼습니다.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'SHOP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '300 Points',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: [
          _buildProductItem(
            context,
            '식물 키트',
            'assets/식물키트.jpg',
            '₩33,000',
          ),
          _buildProductItem(
            context,
            '식물 영양제',
            'assets/식물영양제.jpg',
            '₩5,000',
          ),
          _buildProductItem(
            context,
            '식물 비료',
            'assets/식물비료.jpg',
            '₩10,000',
          ),
          _buildProductItem(
            context,
            '원예 도구',
            'assets/원예도구.jpg',
            '₩30,000',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: '상품',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '장바구니',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(
                  cartItems: _cartItems,
                  availablePoints: 300,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductItem(
      BuildContext context, String title, String imagePath, String price) {
    return GestureDetector(
      onTap: () {
        _addToCart(title, price, imagePath);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(imagePath,
                  fit: BoxFit.cover, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16)),
                  Text(price, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final int availablePoints;

  const CartPage(
      {super.key, required this.cartItems, required this.availablePoints});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'ko_KR',
    symbol: '₩',
    decimalDigits: 0,
  );

  int _usedPoints = 0;

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
            _buildSummaryRow('합계', _currencyFormat.format(_calculateTotal())),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
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
            imagePath,
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
                Text('합계: ${_currencyFormat.format(itemTotal)}'),
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
              width: 100,
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
