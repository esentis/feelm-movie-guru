class Cast {
  Cast({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    this.creditId,
    this.order,
    this.department,
    this.job,
  });

  bool? adult;
  int? gender;
  int? id;
  Department? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;
  int? castId;
  String? character;
  String? creditId;
  int? order;
  Department? department;
  String? job;

  factory Cast.fromMap(Map<String, dynamic> json) => Cast(
        adult: json['adult'],
        gender: json['gender'],
        id: json['id'],
        knownForDepartment: departmentValues.map[json['known_for_department']],
        name: json['name'],
        originalName: json['original_name'],
        popularity: json['popularity'].toDouble(),
        profilePath: json['profile_path'] ?? '',
        castId: json['cast_id'] ?? json['cast_id'],
        character: json['character'] ?? '',
        creditId: json['credit_id'],
        order: json['order'] ?? json['order'],
        department: json['department'] == null
            ? null
            : departmentValues.map[json['department']],
        job: json['job'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'adult': adult,
        'gender': gender,
        'id': id,
        'known_for_department': departmentValues.reverse![knownForDepartment!],
        'name': name,
        'original_name': originalName,
        'popularity': popularity,
        'profile_path': profilePath ?? '',
        'cast_id': castId ?? castId,
        'character': character ?? '',
        'credit_id': creditId,
        'order': order ?? order,
        'department':
            department == null ? null : departmentValues.reverse![department!],
        'job': job ?? '',
      };
}

enum Department {
  acting,
  writing,
  crew,
  visualEffects,
  directing,
  production,
  customeMakeUp,
  art,
  sound,
  camera,
  editing,
  lighting
}

final departmentValues = EnumValues({
  'Acting': Department.acting,
  'Art': Department.art,
  'Camera': Department.camera,
  'Costume & Make-Up': Department.customeMakeUp,
  'Crew': Department.crew,
  'Directing': Department.directing,
  'Editing': Department.editing,
  'Lighting': Department.lighting,
  'Production': Department.production,
  'Sound': Department.sound,
  'Visual Effects': Department.visualEffects,
  'Writing': Department.writing
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    return reverseMap ??= map.map((k, v) => MapEntry(v, k));
  }
}
