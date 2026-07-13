class Market {
  Market(this.id, this.name);

  final int id;
  final String name;

  Market copyWith({int? id, String? name}) =>
      Market(id ?? this.id, name ?? this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Market &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => Object.hash(id, name);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory Market.fromJson(Map<String, dynamic> json) =>
      Market(json['id'] as int, json['name'] as String);
}
