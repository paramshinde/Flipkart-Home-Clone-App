import 'package:flutter/material.dart';

import '../../../data/models/home_models.dart';
import '../../../widgets/network_image_view.dart';

class LiveStreamRow extends StatelessWidget {
  const LiveStreamRow({required this.streams, super.key});

  final List<HomeLiveStream> streams;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = screenWidth > 720 ? screenWidth * 0.34 : screenWidth * 0.68;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Text(
            'Live Shopping',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 154,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            scrollDirection: Axis.horizontal,
            itemCount: streams.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final stream = streams[index];
              return SizedBox(
                width: cardWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      NetworkImageView(
                        imageUrl: stream.thumbnailUrl,
                        fallbackIcon: Icons.play_circle_outline,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xB9000000)],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 9,
                        left: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: stream.isLive ? const Color(0xFFE53935) : Colors.black54,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            stream.badgeText.isEmpty
                                ? (stream.isLive ? 'LIVE' : 'STREAM')
                                : stream.badgeText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 11,
                        right: 11,
                        bottom: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stream.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (stream.offerText.isNotEmpty)
                              Text(
                                stream.offerText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                          ],
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
    );
  }
}
