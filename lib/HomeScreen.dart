// import 'package:flutter/material.dart';
// import 'menu_screen.dart';  // pastikan path ini sesuai dengan file MenuScreen kamu
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   // List halaman yang akan ditampilkan di tiap tab
//   final List<Widget> _pages = [
//     const MenuScreen(),
//     const Center(child: Text('Favorit', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Profil', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Pengaturan', style: TextStyle(fontSize: 24))),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Tampilkan halaman sesuai tab yang dipilih
//       body: _pages[_selectedIndex],
//
//       // Bottom Navigation Bar dengan background hijau dan icon putih
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.green,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white70,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.menu),
//             label: 'Menu',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorit',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Pengaturan',
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'menu_screen.dart'; // pastikan path ini benar
import 'keranjang.dart';
import 'ConfirmationScreen.dart';

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
    const CartScreen(),
    const ConfirmationScreen(),
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
        ],
      ),
    );
  }
}
