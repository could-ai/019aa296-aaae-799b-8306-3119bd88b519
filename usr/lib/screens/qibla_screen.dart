import 'package:flutter/material.dart';
import 'dart:math' as math;

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  // In a real app, we would use flutter_compass stream
  double _direction = 0;
  
  @override
  void initState() {
    super.initState();
    // Simulating compass movement for demo purposes
    // In production: StreamSubscription to FlutterCompass.events
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'تأكد من تفعيل الموقع الجغرافي للحصول على دقة عالية',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                // Compass Background
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
                  ),
                  child: Stack(
                    children: [
                      // Cardinal Directions
                      const Align(alignment: Alignment.topCenter, child: Padding(padding: EdgeInsets.all(8.0), child: Text('N', style: TextStyle(fontWeight: FontWeight.bold)))),
                      const Align(alignment: Alignment.bottomCenter, child: Padding(padding: EdgeInsets.all(8.0), child: Text('S', style: TextStyle(fontWeight: FontWeight.bold)))),
                      const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.all(8.0), child: Text('E', style: TextStyle(fontWeight: FontWeight.bold)))),
                      const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(8.0), child: Text('W', style: TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ),
                
                // Qibla Needle (Simulated Rotation)
                Transform.rotate(
                  angle: (math.pi / 180) * -45, // Pointing towards Mecca (Mock)
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.navigation, 
                        size: 100, 
                        color: Theme.of(context).colorScheme.secondary
                      ),
                      const SizedBox(height: 40), // Offset center
                    ],
                  ),
                ),
                
                // Kaaba Icon
                Transform.translate(
                  offset: const Offset(0, -80), // Position roughly where the needle points
                  child: const Icon(Icons.mosque, size: 30, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'القبلة',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            const Text('214° جنوب شرق'),
          ],
        ),
      ),
    );
  }
}
