import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Konfirmasi'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bigIconButton(
              icon: Icons.shopping_cart_checkout,
              label: 'Konfirmasi Pesanan',
              color: Colors.green,
              onPressed: () {
                // TODO: Logika konfirmasi pesanan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Konfirmasi Pesanan ditekan')),
                );
              },
            ),
            const SizedBox(height: 40),
            _bigIconButton(
              icon: Icons.card_giftcard,
              label: 'Konfirmasi Penukaran Point',
              color: Colors.orange,
              onPressed: () {
                // TODO: Logika konfirmasi penukaran point
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Konfirmasi Penukaran Point ditekan')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 48),
        label: Text(label, style: const TextStyle(fontSize: 24)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

