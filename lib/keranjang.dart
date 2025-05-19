// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// /* ---------------------------  MODEL  --------------------------- */
// class CartItem {
//   final String namaMenu;   // primary‑key logika (bukan id DB)
//   final double price;
//   int qtt;
//
//   CartItem({required this.namaMenu, required this.price, required this.qtt});
//
//   factory CartItem.fromMap(Map<String, dynamic> m) => CartItem(
//     namaMenu: m['menu_name'] as String,
//     price: (m['price'] as num).toDouble(),
//     qtt: m['qtt'] as int,
//   );
// }
//
// /* --------------------------  SCREEN  --------------------------- */
// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   final supabase = Supabase.instance.client;
//
//   final mejaC = TextEditingController();
//   final namaC = TextEditingController();
//   final catatC = TextEditingController();
//
//   List<CartItem> cart = [];
//   bool loading = false;
//
//   /* ====================  DB OPERATIONS  ==================== */
//   @override
//   void initState() {
//     super.initState();
//     _fetch();
//   }
//
//   Future<void> _fetch() async {
//     setState(() => loading = true);
//     try {
//       final List<dynamic> res =
//       await supabase.from('cartt').select('menu_name, price, qtt');
//       cart = res.map((e) => CartItem.fromMap(e)).toList();
//     } catch (e) {
//       _snack('Gagal ambil data: $e');
//     } finally {
//       setState(() => loading = false);
//     }
//   }
//
//   Future<void> _setQtt(String nama, int newQtt) async {
//     try {
//       await supabase.from('cartt').update({'qtt': newQtt}).eq('menu_name', nama);
//       final i = cart.indexWhere((e) => e.namaMenu == nama);
//       if (i != -1) setState(() => cart[i].qtt = newQtt);
//     } catch (e) {
//       _snack('Gagal update: $e');
//     }
//   }
//
//   Future<void> _del(String nama) async {
//     try {
//       await supabase.from('cartt').delete().eq('menu_name', nama);
//       setState(() => cart.removeWhere((e) => e.namaMenu == nama));
//     } catch (e) {
//       _snack('Gagal hapus: $e');
//     }
//   }
//
//   /* ====================  STRUK PDF  ==================== */
//   Future<void> _printStruk() async {
//     if (mejaC.text.trim().isEmpty || namaC.text.trim().isEmpty) {
//       _snack('Nomor meja & nama pelanggan wajib diisi');
//       return;
//     }
//
//     final doc = pw.Document();
//     final fmtRp = (num n) => 'Rp ${n.toStringAsFixed(0)}';
//
//     doc.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a5,
//         build: (_) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text('STRUK PEMESANAN',
//                 style: pw.TextStyle(
//                     fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 4),
//             pw.Text('Meja   : ${mejaC.text}'),
//             pw.Text('Nama   : ${namaC.text}'),
//             if (catatC.text.trim().isNotEmpty)
//               pw.Text('Catatan: ${catatC.text}'),
//             pw.SizedBox(height: 8),
//             pw.Table.fromTextArray(
//               headers: ['Menu', 'Qty', 'Harga', 'Subtotal'],
//               data: cart
//                   .map((e) => [
//                 e.namaMenu,
//                 e.qtt.toString(),
//                 fmtRp(e.price),
//                 fmtRp(e.price * e.qtt)
//               ])
//                   .toList(),
//               border: null,
//               cellAlignment: pw.Alignment.centerLeft,
//               headerStyle:
//               pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
//               cellStyle: const pw.TextStyle(fontSize: 9),
//             ),
//             pw.Divider(),
//             pw.Align(
//               alignment: pw.Alignment.centerRight,
//               child: pw.Text('Total Item : $totalItem',
//                   style:
//                   pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
//             ),
//             pw.Align(
//               alignment: pw.Alignment.centerRight,
//               child: pw.Text('Total Harga : ${fmtRp(totalRp)}',
//                   style:
//                   pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat _) async => doc.save(),
//     );
//   }
//
//   /* ====================  HELPERS  ==================== */
//   int get totalItem => cart.fold(0, (s, e) => s + e.qtt);
//   double get totalRp => cart.fold(0, (s, e) => s + e.qtt * e.price);
//
//   void _snack(String m) =>
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
//
//   TextStyle get bold =>
//       const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
//
//   /* ====================  UI  ==================== */
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         children: [
//           _field(mejaC, 'Nomor Meja', TextInputType.number),
//           const SizedBox(height: 8),
//           _field(namaC, 'Nama Pelanggan'),
//           const SizedBox(height: 8),
//           _field(catatC, 'Catatan'),
//           const SizedBox(height: 12),
//           Expanded(
//             child: loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : cart.isEmpty
//                 ? const Center(child: Text('Keranjang kosong'))
//                 : _list(),
//           ),
//           Container(
//             margin: const EdgeInsets.only(top: 12),
//             padding:
//             const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Item: $totalItem', style: bold),
//                 Text('Total: Rp ${totalRp.toStringAsFixed(0)}', style: bold),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.print),
//               style:
//               ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               label: const Text('Konfirmasi & Cetak Struk'),
//               onPressed: cart.isEmpty ? null : _printStruk,
//             ),
//           ),
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
//
//   Widget _list() => ListView.builder(
//     itemCount: cart.length,
//     itemBuilder: (_, i) {
//       final it = cart[i];
//       return Card(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(it.namaMenu, style: bold),
//                     const SizedBox(height: 4),
//                     Text('Rp ${it.price.toStringAsFixed(0)}'),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.remove_circle,
//                         color: Colors.red),
//                     onPressed: it.qtt > 1
//                         ? () => _setQtt(it.namaMenu, it.qtt - 1)
//                         : null,
//                   ),
//                   Text(it.qtt.toString(),
//                       style: const TextStyle(fontSize: 16)),
//                   IconButton(
//                     icon: const Icon(Icons.add_circle,
//                         color: Colors.green),
//                     onPressed: () => _setQtt(it.namaMenu, it.qtt + 1),
//                   ),
//                 ],
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () => _del(it.namaMenu),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
//
//   Widget _field(TextEditingController c, String label,
//       [TextInputType? t, int maxLines = 1]) =>
//       TextField(
//         controller: c,
//         keyboardType: t,
//         maxLines: maxLines,
//         decoration:
//         InputDecoration(labelText: label, border: const OutlineInputBorder()),
//       );
//
//   @override
//   void dispose() {
//     mejaC.dispose();
//     namaC.dispose();
//     catatC.dispose();
//     super.dispose();
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// /* -------------------------------------------------------------------------- */
// /*                               MODEL 1 item                                 */
// /* -------------------------------------------------------------------------- */
// class CartItem {
//   final String namaMenu;
//   final double price;
//   int qtt;
//
//   CartItem({required this.namaMenu, required this.price, required this.qtt});
//
//   factory CartItem.fromMap(Map<String, dynamic> m) => CartItem(
//     namaMenu: m['menu_name'] as String,
//     price: (m['price'] as num).toDouble(),
//     qtt: m['qtt'] as int,
//   );
//
//   Map<String, dynamic> toJson() =>
//       {'menu': namaMenu, 'qty': qtt, 'price': price};
// }
//
// /* -------------------------------------------------------------------------- */
// /*                                 UI  ‑  PAGE                                */
// /* -------------------------------------------------------------------------- */
// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   final supa = Supabase.instance.client;
//
//   final mejaC = TextEditingController();
//   final namaC = TextEditingController();
//   final catatC = TextEditingController();
//
//   List<CartItem> cart = [];
//   bool loading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCart();
//   }
//
//   /* ---------------------------  LOAD KERANJANG  -------------------------- */
//   Future<void> _fetchCart() async {
//     setState(() => loading = true);
//     try {
//       final List<dynamic> res =
//       await supa.from('cartt').select('menu_name, price, qtt');
//       cart = res.map((e) => CartItem.fromMap(e)).toList();
//     } catch (e) {
//       _snack('Gagal ambil data: $e');
//     } finally {
//       setState(() => loading = false);
//     }
//   }
//
//   /* -------------------------  UPDATE / DELETE QTY  ----------------------- */
//   Future<void> _setQtt(String nama, int newQtt) async {
//     try {
//       await supa.from('cartt').update({'qtt': newQtt}).eq('menu_name', nama);
//       final i = cart.indexWhere((e) => e.namaMenu == nama);
//       if (i != -1) setState(() => cart[i].qtt = newQtt);
//     } catch (e) {
//       _snack('Gagal update: $e');
//     }
//   }
//
//   Future<void> _del(String nama) async {
//     try {
//       await supa.from('cartt').delete().eq('menu_name', nama);
//       setState(() => cart.removeWhere((e) => e.namaMenu == nama));
//     } catch (e) {
//       _snack('Gagal hapus: $e');
//     }
//   }
//
//   /* -----------------------------  CETAK & SAVE  --------------------------- */
//   String _genOrderNo() {
//     final now = DateTime.now();
//     return 'ORD-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-'
//         '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
//   }
//
//   Future<void> _printAndSave() async {
//     if (mejaC.text.trim().isEmpty || namaC.text.trim().isEmpty) {
//       _snack('Nomor meja & nama pelanggan wajib diisi');
//       return;
//     }
//     if (cart.isEmpty) {
//       _snack('Keranjang masih kosong');
//       return;
//     }
//
//     final orderNo = _genOrderNo();
//
//     /* ---------- 1.  BUILD PDF ---------- */
//     final doc = pw.Document();
//     doc.addPage(
//       pw.Page(
//         build: (ctx) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text('NO. ORDER : $orderNo',
//                 style:
//                 pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 6),
//             pw.Text('Meja   : ${mejaC.text}'),
//             pw.Text('Nama   : ${namaC.text}'),
//             if (catatC.text.isNotEmpty) pw.Text('Catatan: ${catatC.text}'),
//             pw.Divider(),
//             pw.Table(
//               border: pw.TableBorder.all(),
//               children: [
//                 pw.TableRow(children: [
//                   _cell('Menu', bold: true),
//                   _cell('Qty', bold: true),
//                   _cell('Harga', bold: true),
//                 ]),
//                 ...cart.map((e) => pw.TableRow(children: [
//                   _cell(e.namaMenu),
//                   _cell(e.qtt.toString()),
//                   _cell('Rp ${e.price.toStringAsFixed(0)}'),
//                 ])),
//               ],
//             ),
//             pw.Divider(),
//             pw.Align(
//               alignment: pw.Alignment.centerRight,
//               child: pw.Text(
//                   'Total Item: $totalItem   Total: Rp ${totalRp.toStringAsFixed(0)}',
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     await Printing.layoutPdf(onLayout: (_) async => doc.save());
//
//     /* ---------- 2.  INSERT HISTORY & CLEAR CART ---------- */
//     await _commitOrder(orderNo);
//   }
//
//   pw.Widget _cell(String txt, {bool bold = false}) => pw.Padding(
//       padding: const pw.EdgeInsets.all(4),
//       child: pw.Text(txt,
//           style: bold
//               ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
//               : const pw.TextStyle()));
//
//   Future<void> _commitOrder(String orderNo) async {
//     try {
//       final payload = {
//         'order_no': orderNo,
//         'nomor_meja': mejaC.text.trim(),
//         'nama_pelanggan': namaC.text.trim(),
//         'catatan': catatC.text.trim(),
//         'items': cart.map((e) => e.toJson()).toList(),
//         'total_item': totalItem,
//         'total_harga': totalRp,
//       };
//       await supa.from('orderkasir_history').insert(payload);
//       await supa.from('cartt').delete();
//
//       setState(() => cart.clear());
//       mejaC.clear();
//       namaC.clear();
//       catatC.clear();
//
//       _snack('Order $orderNo tersimpan');
//     } catch (e) {
//       _snack('Gagal simpan histori: $e');
//     }
//   }
//
//   /* ---------------------------  UTIL & BUILD  ---------------------------- */
//   int get totalItem => cart.fold(0, (s, e) => s + e.qtt);
//   double get totalRp => cart.fold(0, (s, e) => s + e.qtt * e.price);
//
//   void _snack(String m) =>
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
//
//   TextStyle get bold =>
//       const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             _field(mejaC, 'Nomor Meja', TextInputType.number),
//             const SizedBox(height: 8),
//             _field(namaC, 'Nama Pelanggan'),
//             const SizedBox(height: 8),
//             _field(catatC, 'Catatan'),
//             const SizedBox(height: 12),
//             loading
//                 ? const Expanded(
//                 child: Center(child: CircularProgressIndicator()))
//                 : cart.isEmpty
//                 ? const Expanded(
//                 child: Center(child: Text('Keranjang kosong')))
//                 : Expanded(child: _list()),
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               padding:
//               const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.green[50],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Item: $totalItem', style: bold),
//                   Text('Total: Rp ${totalRp.toStringAsFixed(0)}',
//                       style: bold),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: _printAndSave,
//               icon: const Icon(Icons.print),
//               label: const Text('Konfirmasi & Cetak'),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _list() => ListView.builder(
//     itemCount: cart.length,
//     itemBuilder: (_, i) {
//       final it = cart[i];
//       return Card(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(it.namaMenu, style: bold),
//                   const SizedBox(height: 4),
//                   Text('Rp ${it.price.toStringAsFixed(0)}'),
//                 ],
//               ),
//             ),
//             Row(children: [
//               IconButton(
//                 icon:
//                 const Icon(Icons.remove_circle, color: Colors.redAccent),
//                 onPressed: it.qtt > 1
//                     ? () => _setQtt(it.namaMenu, it.qtt - 1)
//                     : null,
//               ),
//               Text(it.qtt.toString(),
//                   style: const TextStyle(fontSize: 16)),
//               IconButton(
//                 icon: const Icon(Icons.add_circle, color: Colors.green),
//                 onPressed: () => _setQtt(it.namaMenu, it.qtt + 1),
//               ),
//             ]),
//             IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () => _del(it.namaMenu)),
//           ]),
//         ),
//       );
//     },
//   );
//
//   Widget _field(TextEditingController c, String label,
//       [TextInputType? t, int maxLines = 1]) =>
//       TextField(
//         controller: c,
//         keyboardType: t,
//         maxLines: maxLines,
//         decoration:
//         InputDecoration(labelText: label, border: const OutlineInputBorder()),
//       );
//
//   @override
//   void dispose() {
//     mejaC.dispose();
//     namaC.dispose();
//     catatC.dispose();
//     super.dispose();
//   }
// }
//


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartItem {
  final String namaMenu;
  final double price;
  int qtt;

  CartItem({required this.namaMenu, required this.price, required this.qtt});

  factory CartItem.fromMap(Map<String, dynamic> m) => CartItem(
    namaMenu: m['menu_name'] as String,
    price: (m['price'] as num).toDouble(),
    qtt: m['qtt'] as int,
  );
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final supabase = Supabase.instance.client;

  final mejaC = TextEditingController();
  final namaC = TextEditingController();
  final catatC = TextEditingController();

  List<CartItem> cart = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => loading = true);
    try {
      final List<dynamic> res =
      await supabase.from('cartt').select('menu_name, price, qtt');
      cart = res.map((e) => CartItem.fromMap(e)).toList();
    } catch (e) {
      _snack('Gagal ambil data: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _setQtt(String nama, int newQtt) async {
    try {
      await supabase.from('cartt').update({'qtt': newQtt}).eq('menu_name', nama);
      final i = cart.indexWhere((e) => e.namaMenu == nama);
      if (i != -1) setState(() => cart[i].qtt = newQtt);
    } catch (e) {
      _snack('Gagal update: $e');
    }
  }

  Future<void> _del(String nama) async {
    try {
      await supabase.from('cartt').delete().eq('menu_name', nama);
      setState(() => cart.removeWhere((e) => e.namaMenu == nama));
    } catch (e) {
      _snack('Gagal hapus: $e');
    }
  }

  int get totalItem => cart.fold(0, (s, e) => s + e.qtt);
  double get totalRp => cart.fold(0, (s, e) => s + e.qtt * e.price);

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  TextStyle get bold => const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  Future<void> _confirmDialog() async {
    if (mejaC.text.isEmpty || namaC.text.isEmpty) {
      _snack('Nomor meja dan nama pelanggan harus diisi');
      return;
    }
    if (cart.isEmpty) {
      _snack('Keranjang kosong, tidak dapat konfirmasi');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        content: const Text('Apakah pesanan sudah sesuai?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Tidak')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ya')),
        ],
      ),
    );

    if (confirm == true) {
      await _processOrder();
    }
  }

  Future<void> _processOrder() async {
    final orderNo = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final pdf = await _generatePdf(orderNo);

      // Simpan histori order ke supabase
      await supabase.from('orderkasir_history').insert({
        'order_no': orderNo,
        'nomor_meja': mejaC.text,
        'nama_pelanggan': namaC.text,
        'catatan': catatC.text,
        'items': cart
            .map((e) => {
          'menu_name': e.namaMenu,
          'price': e.price,
          'qtt': e.qtt,
        })
            .toList(),
        'total_item': totalItem,
        'total_harga': totalRp,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Hapus data keranjang setelah simpan histori
      // await supabase.from('cartt').delete().eq('menu_name', namaMenu);

      await supabase.from('cartt').delete().neq('menu_name', '');

      // Reset state lokal
      setState(() {
        cart.clear();
        mejaC.clear();
        namaC.clear();
        catatC.clear();
      });

      // Bagikan PDF (share)
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/struk_$orderNo.pdf');
      await file.writeAsBytes(await pdf.save());
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'struk_$orderNo.pdf');

      _snack('Order berhasil diproses');

      // Kembali ke menu screen (asumsikan pake Navigator.pop)
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _snack('Gagal memproses order: $e');
    }
  }

  Future<pw.Document> _generatePdf(String orderNo) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Struk Pesanan', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('No Order: $orderNo'),
          pw.Text('Nomor Meja: ${mejaC.text}'),
          pw.Text('Nama Pelanggan: ${namaC.text}'),
          pw.Text('Catatan: ${catatC.text.isEmpty ? '-' : catatC.text}'),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: ['Menu', 'Qty', 'Harga', 'Subtotal'],
            data: cart
                .map((e) => [
              e.namaMenu,
              e.qtt.toString(),
              'Rp ${e.price.toStringAsFixed(0)}',
              'Rp ${(e.price * e.qtt).toStringAsFixed(0)}',
            ])
                .toList(),
          ),
          pw.Divider(),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Total Item:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('$totalItem'),
          ]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Total Harga:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Rp ${totalRp.toStringAsFixed(0)}'),
          ]),
        ],
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Keranjang'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _field(mejaC, 'Nomor Meja', TextInputType.number),
            const SizedBox(height: 8),
            _field(namaC, 'Nama Pelanggan'),
            const SizedBox(height: 8),
            _field(catatC, 'Catatan'),
            const SizedBox(height: 12),
            loading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : cart.isEmpty
                ? const Expanded(child: Center(child: Text('Kosong')))
                : Expanded(child: _list()),
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Item: $totalItem', style: bold),
                  Text('Total: Rp ${totalRp.toStringAsFixed(0)}', style: bold),
                ],
              ),
            ),

            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _confirmDialog,
              icon: const Icon(Icons.print),
              label: const Text('Konfirmasi & Cetak'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            ),
            ],
        ),
      ),
    );
  }

  Widget _list() => ListView.builder(
  itemCount: cart.length,
  itemBuilder: (_, i) {
  final it = cart[i];
  return Card(
  margin: const EdgeInsets.symmetric(vertical: 6),
  child: Padding(
  padding: const EdgeInsets.all(12),
  child: Row(children: [
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(it.namaMenu, style: bold),
  const SizedBox(height: 4),
    Text('Harga: Rp ${it.price.toStringAsFixed(0)}'),
  ],
  ),
  ),
    Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
          onPressed: it.qtt > 1 ? () => _setQtt(it.namaMenu, it.qtt - 1) : null,
        ),
        Text(it.qtt.toString(), style: const TextStyle(fontSize: 16)),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.green),
          onPressed: () => _setQtt(it.namaMenu, it.qtt + 1),
        ),
      ],
    ),
    IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => _del(it.namaMenu),
    ),
  ]),
  ),
  );
  },
  );

  Widget _field(TextEditingController ctl, String label, [TextInputType? type]) {
    return TextField(
      controller: ctl,
      keyboardType: type,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
