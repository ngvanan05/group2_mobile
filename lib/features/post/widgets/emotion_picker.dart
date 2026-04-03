import 'package:flutter/material.dart';

class EmotionOption {
  final String label;
  final String emoji;
  const EmotionOption(this.label, this.emoji);
}

const List<EmotionOption> kEmotions = [
  EmotionOption('Vui vẻ', '😄'),
  EmotionOption('Hạnh phúc', '😊'),
  EmotionOption('Tuyệt vời', '🤩'),
  EmotionOption('Biết ơn', '🙏'),
  EmotionOption('Tự hào', '😎'),
  EmotionOption('Bực mình', '😤'),
  EmotionOption('Mệt mỏi', '😩'),
  EmotionOption('Lo lắng', '😟'),
  EmotionOption('Buồn', '😢'),
  EmotionOption('Tức giận', '😡'),
];

Future<EmotionOption?> showEmotionPicker(BuildContext context) {
  return showModalBottomSheet<EmotionOption>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cảm xúc / Hoạt động',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kEmotions.map((e) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, e),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(e.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(e.label,
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
