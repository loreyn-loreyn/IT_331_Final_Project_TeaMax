import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tea_max/colors.dart';

// === Wifi Access Tab ===
class WifiTimerService {
  static final WifiTimerService instance = WifiTimerService.internal();

  factory WifiTimerService() => instance;

  WifiTimerService.internal();

  DateTime? startTime;
  Duration totalDuration = const Duration(minutes: 1);
  Timer? timer;
  Function(Duration remaining)? onTick;
  Function()? onExpire;

  void startTimer() {
    startTime = DateTime.now();
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void tick() {
    if (startTime == null) return;

    final elapsed = DateTime.now().difference(startTime!);
    final remaining = totalDuration - elapsed;

    if (remaining.inSeconds <= 0) {
      timer?.cancel();
      startTime = null;
      onExpire?.call();
    } else {
      onTick?.call(remaining);
    }
  }

  bool get isActive => startTime != null;

  Duration getRemainingTime() {
    if (startTime == null) return Duration.zero;
    final elapsed = DateTime.now().difference(startTime!);
    return totalDuration - elapsed;
  }

  void reset() {
    timer?.cancel();
    startTime = null;
  }
}

class WifiAccess extends StatefulWidget {
  const WifiAccess({super.key});

  @override
  State<WifiAccess> createState() => WifiAccessState();
}

class WifiAccessState extends State<WifiAccess> {
  final TextEditingController codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RegExp pattern = RegExp(r'^[A-Z0-9]{3}_[A-Za-z0-9]{4}$');
  Set<String> usedCodes = {};
  String? errorText;

  Timer? timer;
  int secondsRemaining = 0;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    loadUsedCodes();
    resumeTimerIfNeeded();
  }

  Future<void> loadUsedCodes() async {
    final prefs = await SharedPreferences.getInstance();
    usedCodes = prefs.getStringList('usedCodes')?.toSet() ?? {};
  }

  Future<void> saveUsedCode(String code) async {
    usedCodes.add(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('usedCodes', usedCodes.toList());
  }

  Future<void> resumeTimerIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final startTime = prefs.getInt('startTime');
    if (startTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = ((now - startTime) / 1000).floor();
      if (elapsed < 60) {
        setState(() {
          secondsRemaining = 10 - elapsed;
          connected = true;
        });
        startTimer();
      } else {
        await prefs.remove('startTime');
      }
    }
  }

  Future<void> startTimer() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Connected successfully! Enjoy your free WiFi connection!'),
        duration: Duration(seconds: 4),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('startTime')) {
      await prefs.setInt('startTime', DateTime.now().millisecondsSinceEpoch);
    }

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
        if (secondsRemaining == 5 && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your WiFi connection is ending in 5 seconds.'),
              backgroundColor: teaMaxBrown,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        timer.cancel();
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('startTime');
        setState(() {
          connected = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'You free WiFi connection has ended, hope you enjoy your connection!'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    });
  }

  void handleConnect() async {
    if (!formKey.currentState!.validate()) return;

    final code = codeController.text.trim();
    final isValid = pattern.hasMatch(code);

    if (!isValid) {
      setState(() => errorText = 'QR code not valid.');
      return;
    }

    if (usedCodes.contains(code)) {
      setState(() => errorText = 'This QR code has already been used.');
      return;
    }

    await saveUsedCode(code);
    setState(() {
      connected = true;
      errorText = null;
      secondsRemaining = 10;
    });
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDEB), // very light beige
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEA),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'WiFi Access',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'EBGaramond-Medium',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the code from your notifications to access free WiFi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'EBGaramond-Medium',
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.wifi,
                  size: 40, color: Color.fromARGB(255, 227, 216, 160)),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: codeController,
                      textAlign: TextAlign.center,
                      enabled: !connected,
                      decoration: InputDecoration(
                        hintText: 'e.g. A09_098T',
                        errorText: errorText,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !pattern.hasMatch(value)) {
                          return 'Enter a valid QR code (e.g. A09_098T)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: connected ? null : handleConnect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 227, 207, 160),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Connect'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (connected)
                Text(
                  'Connected! Time remaining: ${formatTime(secondsRemaining)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: tromboneBrass,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
