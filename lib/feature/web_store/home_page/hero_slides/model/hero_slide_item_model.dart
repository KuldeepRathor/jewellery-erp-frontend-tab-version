import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';

class HeroSlideItem {
  final String id;
  final String position;
  final String imageUrl;
  final ActionType actionType;
  final String? target;

  HeroSlideItem({
    required this.id,
    required this.position,
    required this.imageUrl,
    required this.actionType,
    this.target,
  });

  HeroSlideItem copyWith({
    String? id,
    String? position,
    String? imageUrl,
    ActionType? actionType,
    String? target,
  }) {
    return HeroSlideItem(
      id: id ?? this.id,
      position: position ?? this.position,
      imageUrl: imageUrl ?? this.imageUrl,
      actionType: actionType ?? this.actionType,
      target: target ?? this.target,
    );
  }
}
