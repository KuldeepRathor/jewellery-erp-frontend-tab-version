import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';

class BannerSlideItem {
  final String id;
  final String position;
  final String imageUrl;
  final ActionType actionType;
  final String? target;

  BannerSlideItem({
    required this.id,
    required this.position,
    required this.imageUrl,
    required this.actionType,
    this.target,
  });

  BannerSlideItem copyWith({
    String? id,
    String? position,
    String? imageUrl,
    ActionType? actionType,
    String? target,
  }) {
    return BannerSlideItem(
      id: id ?? this.id,
      position: position ?? this.position,
      imageUrl: imageUrl ?? this.imageUrl,
      actionType: actionType ?? this.actionType,
      target: target ?? this.target,
    );
  }
}
