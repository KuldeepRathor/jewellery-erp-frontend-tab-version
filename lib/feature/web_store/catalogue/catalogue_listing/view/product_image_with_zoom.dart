import 'package:flutter/material.dart';

// Reusable product image widget with hover zoom effect
class ProductImageWithZoom extends StatefulWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double zoomScale;

  const ProductImageWithZoom({
    super.key,
    this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.zoomScale = 1.5,
  });

  @override
  State<ProductImageWithZoom> createState() => _ProductImageWithZoomState();
}

class _ProductImageWithZoomState extends State<ProductImageWithZoom> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: _isHovering ? widget.width * widget.zoomScale : widget.width,
        height: _isHovering ? widget.height * widget.zoomScale : widget.height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2)
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: widget.imageUrl != null
                  ? Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
            ),
            if (_isHovering)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
