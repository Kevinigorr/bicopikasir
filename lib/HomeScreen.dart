import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'konfirmasipesanan.dart';
import 'menu_screen.dart'; // pastikan path ini benar
import 'keranjang.dart';
import 'ConfirmationScreen.dart';
import 'order_history.dart';
import 'order.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List halaman yang akan ditampilkan di tiap tab
  final List<Widget> _pages = [
    const MenuScreen(),
    CartScreen(),
    const KonfirmasiPage(),
    OrderHistoryPage(),
    const OrderPage(),





    // const Center(child: Text('Favorit', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profil', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Pengaturan', style: TextStyle(fontSize: 24))),
  ];
  // Judul app bar sesuai tab aktif
  String get _appBarTitle {
    switch (_selectedIndex) {
      case 0:
        return 'Menu';
      case 1:
        return 'Keranjang';
      case 2:
        return 'Konfirmasi';
      case 3:
        return 'Laporan';
      case 4:
        return 'Order';
      default:
        return '';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),

        centerTitle: true,

        backgroundColor: Colors.green,
      ),
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_2_outlined),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Konfirmasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Order',
          ),
        ],
      ),
    );
  }
}
