import 'dart:math';
import 'package:flutter/material.dart';
import '../models/postcard_template.dart';

class PostcardPreview extends StatefulWidget {
  final PostcardTemplate template;
  final String message;
  final String address;
  final VoidCallback onBack;

  const PostcardPreview({
    super.key,
    required this.template,
    required this.message,
    required this.address,
    required this.onBack,
  });

  @override
  State<PostcardPreview> createState() => _PostcardPreviewState();
}

class _PostcardPreviewState extends State<PostcardPreview> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
  }

  void _flip() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _isFront = !_isFront);
  }

  void _showComingSoon(String action) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$action feature coming soon!"),
      backgroundColor: Colors.green.shade600,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final template = widget.template;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    label: const Text('Edit', style: TextStyle(color: Colors.white)),
                  ),
                  const Text('Preview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 50),
                ],
              ),

              const SizedBox(height: 8),
              const Text('This is how your postcard will look', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final angle = _controller.value * pi;
                      final isFrontVisible = angle <= pi / 2;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle),
                        child: isFrontVisible ? _front(template) : Transform(alignment: Alignment.center, transform: Matrix4.rotationY(pi), child: _back(template)),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _flip,
                icon: const Icon(Icons.flip),
                label: Text(_isFront ? 'Flip to see back' : 'Flip to see front'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white12, foregroundColor: Colors.white),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showComingSoon('Download'),
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text('Download', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showComingSoon('Share'),
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text('Share', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _front(PostcardTemplate template) {
    return Container(
      width: 360,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 4),
        image: template.style == 'image'
            ? DecorationImage(image: NetworkImage(template.frontBg), fit: BoxFit.cover)
            : null,
        color: template.style != 'image' ? Color(int.parse(template.frontBg.replaceFirst('#', '0xff'))) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black45, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter))),
          if (widget.message.isNotEmpty)
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.92), borderRadius: BorderRadius.circular(10)),
                child: Text(widget.message, style: const TextStyle(fontFamily: 'Cursive', fontSize: 14, color: Colors.black87)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _back(PostcardTemplate template) {
    return Container(
      width: 360,
      height: 240,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black26, width: 1.5))),
                    child: Text(widget.message, style: const TextStyle(fontFamily: 'Cursive', fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 56,
                          height: 36,
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black45), borderRadius: BorderRadius.circular(6)),
                          child: const Center(child: Text('STAMP', style: TextStyle(fontSize: 10, color: Colors.black54))),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.address, style: const TextStyle(fontFamily: 'Cursive', fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(24, (i) => Container(width: 2, height: Random().nextDouble() * 16 + 8, color: Colors.black87, margin: const EdgeInsets.symmetric(horizontal: 1)))),
        ],
      ),
    );
  }
}
