import 'dart:math';
import 'package:flutter/material.dart';
import '../models/postcard_template.dart';

class PostcardEditor extends StatefulWidget {
  final PostcardTemplate template;
  final VoidCallback onBack;
  final Function(String message, String address) onPreview;

  const PostcardEditor({
    super.key,
    required this.template,
    required this.onBack,
    required this.onPreview,
  });

  @override
  State<PostcardEditor> createState() => _PostcardEditorState();
}

class _PostcardEditorState extends State<PostcardEditor>
    with SingleTickerProviderStateMixin {
  bool isBack = false;
  late AnimationController _controller;
  final TextEditingController frontMessage = TextEditingController();
  final TextEditingController backMessage = TextEditingController();
  final TextEditingController address = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    frontMessage.dispose();
    backMessage.dispose();
    address.dispose();
    super.dispose();
  }

  void _flip() {
    setState(() => isBack = !isBack);
    if (isBack) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _onPreview() {
    // Combine front/back messages into one message for preview
    final combined = (frontMessage.text + (backMessage.text.isNotEmpty ? "\n\n${backMessage.text}" : "")).trim();
    widget.onPreview(combined, address.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colorBg = widget.template.style == 'color'
        ? Color(int.parse(widget.template.frontBg.replaceFirst('#', '0xff')))
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        ),
        centerTitle: true,
        title: const Text('Edit Postcard', style: TextStyle(color: Color(0xFF0F172A))),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final angle = _controller.value * pi;
                  final isShowingBack = angle > pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: isShowingBack
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: _buildBackCard(),
                          )
                        : _buildFrontCard(colorBg),
                  );
                },
              ),
            ),
          ),

          // instruction panel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Text(
                isBack ? "Write additional message on the left, address on the right" : "Write your message on the front of the postcard",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
          ),

          // buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _flip,
                    icon: const Icon(Icons.flip),
                    label: const Text("Flip Card"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _onPreview,
                    icon: const Icon(Icons.remove_red_eye),
                    label: const Text("Preview"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const LinearGradient(
                        colors: [Color(0xFFFB7185), Color(0xFFF97316)],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 50)) != null
                          ? null
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFrontCard(Color? colorBg) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      height: MediaQuery.of(context).size.width * 0.56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorBg ?? Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 14)],
        image: widget.template.style == 'image'
            ? DecorationImage(image: NetworkImage(widget.template.frontBg), fit: BoxFit.cover)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: frontMessage,
              maxLines: 5,
              style: const TextStyle(fontFamily: 'Cursive', fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Write your message here...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      height: MediaQuery.of(context).size.width * 0.56,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 14)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // left: message
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.black26, width: 1.0, style: BorderStyle.solid)),
                      ),
                      child: TextField(
                        controller: backMessage,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Additional message...',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontFamily: 'Cursive', fontSize: 15),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // right: address & stamp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 64,
                            height: 52,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26, width: 1.5),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            child: const Center(child: Text('STAMP', style: TextStyle(fontSize: 11, color: Colors.black54))),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: TextField(
                            controller: address,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              hintText: "Recipient's Address:\nName\nStreet\nCity, State ZIP",
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontFamily: 'Cursive', fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // barcode look
            SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(22, (i) {
                  final height = 8 + (i % 5) * 3;
                  return Container(
                    width: 3,
                    height: height.toDouble(),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: Colors.black87,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
