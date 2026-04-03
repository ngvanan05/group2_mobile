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

  bool _isMuted = false;
  bool _isSpeakerOff = false;

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

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _dots = (_dots + 1) % 4);
    });

    _playRingtone();
  }

  Future<void> _playRingtone() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // Âm thanh tít tít khi gọi
      await _audioPlayer.play(
        UrlSource('https://www.soundjay.com/phone/sounds/phone-calling-1.mp3'),
      );
    } catch (_) {}
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    if (_isMuted) {
      _audioPlayer.setVolume(0);
    } else {
      _audioPlayer.setVolume(1);
    }
  }

  void _toggleSpeaker() {
    setState(() => _isSpeakerOff = !_isSpeakerOff);
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
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withOpacity(0.25),
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: 138,
                      height: 138,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withOpacity(0.45),
                          width: 2,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 54,
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
              Text(
                widget.userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppTextSize.heading2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Đang gọi cho ${widget.userName}$dotsStr',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF00BCD4),
                  fontSize: AppTextSize.body,
                ),
              ),

              const Spacer(flex: 2),

              // Mic + Speaker buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: _isMuted ? 'Bật mic' : 'Tắt mic',
                    active: _isMuted,
                    onTap: _toggleMute,
                  ),
                  const SizedBox(width: 40),
                  _buildToggleButton(
                    icon: _isSpeakerOff
                        ? Icons.volume_off
                        : Icons.volume_up,
                    label: _isSpeakerOff ? 'Bật chuông' : 'Tắt chuông',
                    active: _isSpeakerOff,
                    onTap: _toggleSpeaker,
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // End call button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.call_end, color: Colors.white, size: 30),
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

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF00BCD4)
                  : Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: active ? const Color(0xFF0D1B2A) : Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFF00BCD4) : Colors.white70,
              fontSize: AppTextSize.small,
            ),
          ),
        ],
      ),
    );
  }
}
