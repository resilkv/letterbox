import 'package:flutter/material.dart';
import '../models/postcard_template.dart';

class PostcardSelection extends StatelessWidget {
  final Function(PostcardTemplate) onSelect;
  const PostcardSelection({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF3F6), Color(0xFFF7F3FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                "Create Your Postcard",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select a postcard design to get started",
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 6),
                  itemCount: postcardTemplates.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 3 / 2.2,
                  ),
                  itemBuilder: (context, index) {
                    final template = postcardTemplates[index];
                    return GestureDetector(
                      onTap: () => onSelect(template),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: template.style == 'image'
                                    ? BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(template.frontBg),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : BoxDecoration(
                                        color: Color(int.parse(template.frontBg.replaceFirst('#', '0xff'))),
                                      ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.white,
                              child: Text(
                                template.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Color(0xFF111827)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
