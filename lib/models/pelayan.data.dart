
class Pelayan{
  // properti
  late String? nama;
  late String? lokasi;

  // konstruktor
  Pelayan({
    this.nama,
    this.lokasi
  });

  // method
  factory Pelayan.fromJson(Map<String, dynamic> json) {
    return Pelayan(
      nama: json["nama"],
      lokasi: json["lokasi"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "lokasi": lokasi
    };
  }
}