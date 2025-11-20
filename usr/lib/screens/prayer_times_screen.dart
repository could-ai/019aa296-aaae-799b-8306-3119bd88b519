import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/prayer_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late PrayerService _prayerService;
  Map<String, DateTime> _prayerTimes = {};
  String _nextPrayerName = '';
  Duration _timeUntilNextPrayer = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _prayerService = PrayerService();
    _loadPrayerTimes();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadPrayerTimes() {
    // In a real app, this would fetch based on location
    setState(() {
      _prayerTimes = _prayerService.getPrayerTimes(DateTime.now());
      _updateNextPrayer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateNextPrayer();
    });
  }

  void _updateNextPrayer() {
    final now = DateTime.now();
    DateTime? nextTime;
    String nextName = '';

    // Find the next prayer
    for (var entry in _prayerTimes.entries) {
      if (entry.value.isAfter(now)) {
        nextTime = entry.value;
        nextName = entry.key;
        break;
      }
    }

    // If no prayer left today, next is Fajr tomorrow
    if (nextTime == null) {
      nextName = 'الفجر';
      // Mocking tomorrow's Fajr for demo logic
      nextTime = _prayerTimes['الفجر']!.add(const Duration(days: 1));
    }

    if (mounted) {
      setState(() {
        _nextPrayerName = nextName;
        _timeUntilNextPrayer = nextTime!.difference(now);
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('أوقات الصلاة', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('مكة المكرمة (تلقائي)', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrayerTimes,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            // Header Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'الصلاة القادمة: $_nextPrayerName',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _formatDuration(_timeUntilNextPrayer),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('EEEE, d MMMM yyyy', 'ar').format(DateTime.now()),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Prayer List
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _prayerTimes.length,
                  separatorBuilder: (ctx, i) => const Divider(),
                  itemBuilder: (context, index) {
                    String key = _prayerTimes.keys.elementAt(index);
                    DateTime time = _prayerTimes.values.elementAt(index);
                    bool isNext = key == _nextPrayerName;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      tileColor: isNext ? theme.colorScheme.primaryContainer.withOpacity(0.3) : null,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      leading: Icon(
                        Icons.access_time,
                        color: isNext ? theme.colorScheme.primary : Colors.grey,
                      ),
                      title: Text(
                        key,
                        style: TextStyle(
                          fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat('hh:mm a', 'ar').format(time),
                            style: TextStyle(
                              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                              fontSize: 18,
                              color: isNext ? theme.colorScheme.primary : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.volume_up,
                            size: 20,
                            color: isNext ? theme.colorScheme.secondary : Colors.grey[400],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
