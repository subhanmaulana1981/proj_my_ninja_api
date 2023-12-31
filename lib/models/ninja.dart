
class Ninja {
  // properti
  String? id;
  String? name;
  String? rank;
  bool? isAvailable = false;
  late int? version;
  late String? operationMode;

  // konstruktor
  Ninja({
    this.id,
    this.name,
    this.rank,
    this.isAvailable,
    this.version,
    this.operationMode,
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
      "_id": id,
      "name": name,
      "rank": rank,
      "available": isAvailable,
      "__v": version
    };
  }

}