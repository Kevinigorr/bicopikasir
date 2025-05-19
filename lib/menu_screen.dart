//
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'YOUR_SUPABASE_URL',
//     anonKey: 'YOUR_SUPABASE_ANON_KEY',
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Menu App',
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: const MainScreen(),
//     );
//   }
// }
//
// /* --------------------------  MAIN  &  NAVIGATION  ------------------------- */
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _idx = 0;
//
//   final pages = const [
//     Center(child: Text('Home')),
//     MenuScreen(),
//     Center(child: Text('Cart')),   // ganti dgn CartScreen kalau sudah ada
//     Center(child: Text('Profile')),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Menu'), centerTitle: true,
//       ),
//       body: pages[_idx],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.green,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white70,
//         currentIndex: _idx,
//         type: BottomNavigationBarType.fixed,
//         onTap: (i) => setState(() => _idx = i),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }
//
// /* ------------------------------  MENU  ------------------------------------ */
//
// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});
//   @override State<MenuScreen> createState() => _MenuScreenState();
// }
//
// class _MenuScreenState extends State<MenuScreen> {
//   final supa = Supabase.instance.client;
//
//   final tabs = ['Minuman', 'Snack', 'Makanan'];
//   final Map<String, List<Map<String, dynamic>>> menu = {
//     'Minuman': [], 'Snack': [], 'Makanan': []
//   };
//
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMenu();
//   }
//
//   Future<void> _loadMenu() async {
//     try {
//       final data = await supa
//           .from('menu')
//           .select('id_menu, nama_menu, harga_menu, foto_menu, kategori');
//
//       for (final row in data as List<dynamic>) {
//         final m = row as Map<String, dynamic>;
//         switch (m['kategori']) {
//           case 'Drink': menu['Minuman']!.add(m); break;
//           case 'Snack': menu['Snack']!.add(m); break;
//           case 'Food' : menu['Makanan']!.add(m); break;
//           default     : menu['Snack']!.add(m);
//         }
//       }
//     } catch (e) {
//       debugPrint('FETCH ERR: $e');
//       if (mounted) ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Gagal memuat menu')));
//     } finally {
//       if (mounted) setState(() => loading = false);
//     }
//   }
//
//   /* ------------------  SIMPAN KE TABEL `cartt`  ------------------- */
//   Future<void> _addToCart(Map<String, dynamic> m) async {
//     try {
//       // cek apakah sudah ada
//       final exist = await supa
//           .from('cartt')
//           .select('id, qtt')
//           .eq('menu_id', m['id_menu'])
//           .maybeSingle();
//
//       if (exist != null) {
//         // sudah ada → tambahkan qtt
//         final newQty = (exist['qtt'] as int) + 1;
//         await supa.from('cartt')
//             .update({'qtt': newQty})
//             .eq('id', exist['id']);
//       } else {
//         // belum ada → insert baru
//         await supa.from('cartt').insert({
//           'menu_id'  : m['id_menu'],
//           'menu_name': m['nama_menu'],
//           'price'    : m['harga_menu'],
//           'qtt'      : 1,
//         });
//       }
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${m['nama_menu']} ditambahkan ke keranjang')),
//         );
//       }
//     } catch (e) {
//       debugPrint('ADD CART ERR: $e');
//       if (mounted) ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Gagal menambah ke keranjang')));
//     }
//   }
//
//   /* ------------------------------  UI  ----------------------------- */
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) return const Center(child: CircularProgressIndicator());
//
//     return DefaultTabController(
//       length: tabs.length,
//       child: Column(
//         children: [
//           const TabBar(
//             labelColor: Colors.green,
//             unselectedLabelColor: Colors.black54,
//             tabs: [
//               Tab(text: 'Minuman'), Tab(text: 'Snack'), Tab(text: 'Makanan'),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               children: tabs.map((t) => _grid(menu[t]!)).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _grid(List<Map<String, dynamic>> items) {
//     if (items.isEmpty) return const Center(child: Text('Kosong'));
//
//     return GridView.builder(
//       padding: const EdgeInsets.all(10),
//       itemCount: items.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .75),
//       itemBuilder: (_, i) => _card(items[i]),
//     );
//   }
//
//   Widget _card(Map<String, dynamic> m) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   m['foto_menu'] ?? '',
//                   height: 110,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) =>
//                   const SizedBox(height: 110, child: Icon(Icons.image)),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Text(m['nama_menu'] ?? '',
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Text('Rp ${m['harga_menu']}'),
//               ),
//             ],
//           ),
//           // ─── FAB keranjang ───
//           Positioned(
//             right: 6,
//             bottom: 6,
//             child: FloatingActionButton.small(
//               backgroundColor: Colors.green,
//               child: const Icon(Icons.add_shopping_cart),
//               onPressed: () => _addToCart(m),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final supa = Supabase.instance.client;

  final tabs = ['Minuman', 'Snack', 'Makanan'];
  final Map<String, List<Map<String, dynamic>>> menu = {
    'Minuman': [], 'Snack': [], 'Makanan': []
  };

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    try {
      final data = await supa
          .from('menu')
          .select('id_menu, nama_menu, harga_menu, foto_menu, kategori');

      for (final row in data as List<dynamic>) {
        final m = row as Map<String, dynamic>;
        switch (m['kategori']) {
          case 'Drink': menu['Minuman']!.add(m); break;
          case 'Snack': menu['Snack']!.add(m); break;
          case 'Food' : menu['Makanan']!.add(m); break;
          default     : menu['Snack']!.add(m);
        }
      }
    } catch (e) {
      debugPrint('FETCH ERR: $e');
      if (mounted) ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Gagal memuat menu')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _addToCart(Map<String, dynamic> m) async {
    try {
      final exist = await supa
          .from('cartt')
          .select('id, qtt')
          .eq('menu_id', m['id_menu'])
          .maybeSingle();

      if (exist != null) {
        final newQty = (exist['qtt'] as int) + 1;
        await supa.from('cartt').update({'qtt': newQty}).eq('id', exist['id']);
      } else {
        await supa.from('cartt').insert({
          'menu_id': m['id_menu'],
          'menu_name': m['nama_menu'],
          'price': m['harga_menu'],
          'qtt': 1,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${m['nama_menu']} ditambahkan ke keranjang')),
        );
      }
    } catch (e) {
      debugPrint('ADD CART ERR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Gagal menambah ke keranjang')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: 'Minuman'), Tab(text: 'Snack'), Tab(text: 'Makanan'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: tabs.map((t) => _grid(menu[t]!)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _grid(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return const Center(child: Text('Kosong'));

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .75,
      ),
      itemBuilder: (_, i) => _card(items[i]),
    );
  }

  Widget _card(Map<String, dynamic> m) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  m['foto_menu'] ?? '',
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const SizedBox(height: 110, child: Icon(Icons.image)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(m['nama_menu'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Rp ${m['harga_menu']}'),
              ),
            ],
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: FloatingActionButton.small(
              backgroundColor: Colors.green,
              child: const Icon(Icons.add_shopping_cart),
              onPressed: () => _addToCart(m),
            ),
          ),
        ],
      ),
    );
  }
}
