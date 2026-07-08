class Pairing {
  final String id;
  final DateTime expiresAt;

  const Pairing({
    required this.id,
    required this.expiresAt,
  });

  Duration get timeRemaining {
    return expiresAt.difference(DateTime.now());
  }

  bool get expired {
    return timeRemaining.isNegative;
  }
}