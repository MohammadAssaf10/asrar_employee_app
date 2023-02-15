import 'dart:convert';

/// steps to add new filed to this class
/// * regenerate data class
/// all done no need to edit any thing else
class Permissions {
  bool isRejected;
  bool canWork;

  Permissions({
    required this.isRejected,
    required this.canWork,
  });

  Permissions copyWith({
    bool? isRejected,
    bool? canWork,
  }) {
    return Permissions(
      isRejected: isRejected ?? this.isRejected,
      canWork: canWork ?? this.canWork,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'isRejected': isRejected});
    result.addAll({'canWork': canWork});

    return result;
  }

  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      isRejected: map['isRejected'] ?? false,
      canWork: map['canWork'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Permissions.fromJson(String source) => Permissions.fromMap(json.decode(source));

  @override
  String toString() => 'Permissions(isRejected: $isRejected, canWork: $canWork)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Permissions && other.isRejected == isRejected && other.canWork == canWork;
  }

  @override
  int get hashCode => isRejected.hashCode ^ canWork.hashCode;
}
