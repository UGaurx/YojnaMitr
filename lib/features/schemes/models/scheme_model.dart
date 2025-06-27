class Scheme {
  final String id;
  final String name;
  final String description;
  final List<String> eligibility; // e.g. ["Farmer", "SC", "Women"]
  final String state; // e.g. "Uttar Pradesh"
  final String sector; // e.g. "Agriculture", "Education"
  final String applyLink;

  Scheme({
    required this.id,
    required this.name,
    required this.description,
    required this.eligibility,
    required this.state,
    required this.sector,
    required this.applyLink,
  });

  factory Scheme.fromMap(Map<String, dynamic> map, String docId) {
    return Scheme(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      eligibility: List<String>.from(map['eligibility'] ?? []),
      state: map['state'] ?? '',
      sector: map['sector'] ?? '',
      applyLink: map['applyLink'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'eligibility': eligibility,
      'state': state,
      'sector': sector,
      'applyLink': applyLink,
    };
  }
}
