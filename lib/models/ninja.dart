
class Ninja {
  // properti
  String? id;
  String? name;
  String? rank;
  bool? isAvailable = false;
  int? version;

  // konstruktor
  Ninja({
    this.id,
    this.name,
    this.rank,
    this.isAvailable,
    this.version
  });

  // dari string into object
  factory Ninja.fromJson(Map<String, dynamic> json) {
    return Ninja(
      id: json['_id'],
      name: json['name'],
      rank: json['rank'],
      isAvailable: json['available'],
      version: json['__v']
    );
  }

  // dari object into string (stringify)
  Map<String, dynamic> toMap() {
    return {
      "__id": id,
      "name": name,
      "rank": rank,
      "available": isAvailable,
      "v": version
    };
  }

}