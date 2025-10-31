import 'package:flutter/material.dart';
import 'postcard_selection.dart';
import 'postcard_editor.dart';
import 'postcard_preview.dart';
import '../models/postcard_template.dart';

class PostcardApp extends StatefulWidget {
  const PostcardApp({super.key});

  @override
  State<PostcardApp> createState() => _PostcardAppState();
}

class _PostcardAppState extends State<PostcardApp> {
  String currentView = "selection"; // selection | editor | preview
  PostcardTemplate? selectedTemplate;
  String message = "";
  String address = "";

  void handleSelectTemplate(PostcardTemplate template) {
    setState(() {
      selectedTemplate = template;
      currentView = "editor";
    });
  }

  void handleBackToSelection() {
    setState(() {
      currentView = "selection";
      selectedTemplate = null;
      message = "";
      address = "";
    });
  }

  void handlePreview(String msg, String addr) {
    setState(() {
      message = msg;
      address = addr;
      currentView = "preview";
    });
  }

  void handleBackToEditor() {
    setState(() {
      currentView = "editor";
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (currentView == "selection") {
      body = PostcardSelection(onSelect: handleSelectTemplate);
    } else if (currentView == "editor" && selectedTemplate != null) {
      body = PostcardEditor(
        template: selectedTemplate!,
        onBack: handleBackToSelection,
        onPreview: handlePreview,
      );
    } else if (currentView == "preview" && selectedTemplate != null) {
      body = PostcardPreview(
        template: selectedTemplate!,
        message: message,
        address: address,
        onBack: handleBackToEditor,
      );
    } else {
      body = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F9),
      body: SafeArea(child: body),
    );
  }
}
