import 'package:meta/meta.dart';

/// A family member the parent can call by voice or by tapping their photo.
@immutable
class Contact {
  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.photoPath,
    this.nicknames = const [],
    this.forHelp = false,
  });

  factory Contact.fromJson(Map<String, Object?> json) => Contact(
    id: json['id']! as String,
    name: json['name']! as String,
    phone: json['phone']! as String,
    photoPath: json['photoPath'] as String?,
    nicknames: [
      for (final nickname in (json['nicknames'] as List<Object?>?) ?? const [])
        nickname! as String,
    ],
    forHelp: json['forHelp'] as bool? ?? false,
  );

  final String id;

  /// The name shown under the photo, for example "Ravi".
  final String name;

  final String phone;

  /// A private copy of the photo inside the app's folder.
  final String? photoPath;

  /// Other words the parent uses for this person, for example
  /// "pedda abbayi" or "రవి". They are matched against what was heard.
  final List<String> nicknames;

  /// Whether "Help" calls this person. Help calls them in list order.
  final bool forHelp;

  /// The name and every nickname, without blanks or repeats.
  List<String> get spokenNames {
    final seen = <String>{};
    return [
      for (final word in [name, ...nicknames])
        if (word.trim().isNotEmpty && seen.add(word.trim().toLowerCase()))
          word.trim(),
    ];
  }

  Contact copyWith({
    String? name,
    String? phone,
    String? Function()? photoPath,
    List<String>? nicknames,
    bool? forHelp,
  }) => Contact(
    id: id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    photoPath: photoPath != null ? photoPath() : this.photoPath,
    nicknames: nicknames ?? this.nicknames,
    forHelp: forHelp ?? this.forHelp,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'photoPath': photoPath,
    'nicknames': nicknames,
    'forHelp': forHelp,
  };

  @override
  bool operator ==(Object other) =>
      other is Contact &&
      other.id == id &&
      other.name == name &&
      other.phone == phone &&
      other.photoPath == photoPath &&
      _sameList(other.nicknames, nicknames) &&
      other.forHelp == forHelp;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    photoPath,
    Object.hashAll(nicknames),
    forHelp,
  );
}

bool _sameList(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Keeps the family list, in the order the family chose.
abstract interface class ContactRepository {
  Future<List<Contact>> loadAll();

  /// Replaces the whole list; the order is kept.
  Future<void> saveAll(List<Contact> contacts);
}
