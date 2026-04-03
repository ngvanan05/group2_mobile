import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/constants/app_constants.dart';

class CallScreen extends StatefulWidget {
  final String userName;
  final String? avatarUrl;

  const CallScreen({super.key, required this.userName, this.avatarUrl});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  int _dots = 0;
  Timer? _dotsTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String get _initials {
    final parts = widget.userName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2][0]}${parts.last[0]}'.toUpperCase();
    }
    return widget.userName.substring(0, 2).toUpperCase();
  }

  @override
  void initState() {
    super.initState();

    // Pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Dots animation
    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _dots = (_dots + 1) % 4);
    });

    // Play ringtone
    _playRingtone();
  }

  Future<void> _playRingtone() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(
      UrlSource('https://www.soundjay.com/phone/sounds/phone-calling-1.mp3'),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dotsTimer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotsStr = '.' * _dots;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Pulsing avatar
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, child) => Transform.scale(
                  scale: _pulseAnim.value,
                  child: child,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xFF00BCD4),
                      backgroundImage: widget.avatarUrl != null
                          ? NetworkImage(widget.avatarUrl!)
                          : null,
                      child: widget.avatarUrl == null
                          ? Text(
                              _initials,
                              style: const TextStyle(
                                color: Color(0xFF0D1B2A),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Center(
                child: Text(
                  widget.userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppTextSize.heading2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Center(
                child: Text(
                  'Đang gọi cho ${widget.userName}$dotsStr',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF00BCD4),
                    fontSize: AppTextSize.body,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // Cancel button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              const Text(
                'HỦY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextSize.caption,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
