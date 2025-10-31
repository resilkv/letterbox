class PostcardTemplate {
  final String id;
  final String name;
  final String frontBg; // url or color string (we treat color templates specially)
  final String style; // 'image' or 'color'

  const PostcardTemplate({
    required this.id,
    required this.name,
    required this.frontBg,
    required this.style,
  });
}

const List<PostcardTemplate> postcardTemplates = [
  PostcardTemplate(
    id: 'vintage',
    name: 'Vintage',
    frontBg:
        'https://images.unsplash.com/photo-1613091867979-6e3e6d3d4a1d?ixlib=rb-4.1.0&q=80&w=1080',
    style: 'image',
  ),
  PostcardTemplate(
    id: 'beach',
    name: 'Beach Sunset',
    frontBg:
        'https://images.unsplash.com/photo-1626483946541-43bbca226e09?ixlib=rb-4.1.0&q=80&w=1080',
    style: 'image',
  ),
  PostcardTemplate(
    id: 'mountain',
    name: 'Mountain View',
    frontBg:
        'https://images.unsplash.com/photo-1596693097925-9d818cc9692d?ixlib=rb-4.1.0&q=80&w=1080',
    style: 'image',
  ),
  PostcardTemplate(
    id: 'city',
    name: 'City Lights',
    frontBg:
        'https://images.unsplash.com/photo-1457282367193-e3b79e38f207?ixlib=rb-4.1.0&q=80&w=1080',
    style: 'image',
  ),
  PostcardTemplate(
    id: 'classic',
    name: 'Classic Beige',
    frontBg: '#f5e6d3', // color hex
    style: 'color',
  ),
  PostcardTemplate(
    id: 'pastel',
    name: 'Pastel Blue',
    frontBg: '#e0f2fe',
    style: 'color',
  ),
];
