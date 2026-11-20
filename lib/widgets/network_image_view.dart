import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';

class NetworkImageView extends StatelessWidget {
  const NetworkImageView({
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image_outlined,
    this.backgroundColor = const Color(0xFFF1F2F4),
    super.key,
  });

  final String imageUrl;
  final BoxFit fit;
  final IconData fallbackIcon;
  final Color backgroundColor;

  String _resolveUrl(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return '';
    final uri = Uri.tryParse(value);
    if (uri != null && (uri.hasScheme || uri.hasAuthority)) {
      if (uri.hasScheme) return value;
      return 'https:$value';
    }
    final apiUri = Uri.parse(AppConstants.homeApiUrl);
    final path = value.startsWith('/') ? value : '/$value';
    return '${apiUri.scheme}://${apiUri.host}$path';
  }

  @override
  Widget build(BuildContext context) {
    final url = _resolveUrl(imageUrl);
    if (url.isEmpty) return _fallback();

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, _) => Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, _, __) => _fallback(),
    );
  }

  Widget _fallback() => Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: Icon(fallbackIcon, color: Colors.black38, size: 30),
      );
}
