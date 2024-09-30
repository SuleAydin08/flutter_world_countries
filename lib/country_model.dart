class Country {
  String countryCode;
  String name;
  String capitalCity;
  String region;
  int population;
  String flag;
  String language;

//Aşagıdaki kodda belirtilen değerleri alıp teker teker üsteki değişkenlere atayacağız.
  Country.fromMap(Map<String, dynamic> countryMap)
      : countryCode = countryMap["cca2"] ??
            "", //Parantez içerisine aşağıdan hangi kısımından gelmesini istiyorsak onun içerisine yazıyoruz.
        //Yoksa boş atasın diyoruz üst kısımda.
        //Name olmayan ülke olsaydı burada hata alabilirdik.Bu sebeple ? koymamız hatanın önlemini almamızı sağladı.
        name = countryMap["name"]?["common"] ??
            "", //Eğer name nullsa hiç commonı arama ? bu sebeple konulmuştur.super
        //capital boş değilse bunun sıfırıncı elemanını ver eğer boşsa boş string ver diyoruz.
        capitalCity = (countryMap["capital"] as List<dynamic>).isNotEmpty
            ? countryMap["capital"][0]
            : "",
        region = countryMap[
            "region"], //region alttaki kodda doğrudan string verdiği için bu şekilde yazdık.
        population = countryMap["population"],
        flag = countryMap["flags"]?["png"] ?? "",
        //Dil kısmı içinde ayrı bir map verdiği için ;
        //Eğer language boş değilse 0ıncı elemanı döndür eğer boşsa boş döndür diyoruz.
        language = (countryMap["languages"] as Map<String, dynamic>).isNotEmpty
            ? (countryMap["languages"] as Map<String, dynamic>)
                .entries
                .toList()[0] //0 elemanı al ve dil değişkenine ata diyoruz.
                .value
            : "";
  //(countryMap["languages"] ?? {}) burada nullsa boş map al diyorum.
  //((countryMap["languages"] ?? {}) as Map<String, String>)Burada map içerisinde map olduğu için codun anlaması için bu şekilde yazıyoruz.
  //Yani mapin tüm anahtar ve değerlerini bir liste içerisine koyuyoruz.
}


/*Türkiye bilgiler
[
  {
    "flags": {
      "png": "https://flagcdn.com/w320/tr.png",
      "svg": "https://flagcdn.com/tr.svg",
      "alt": "The flag of Turkey has a red field bearing a large fly-side facing white crescent and a smaller five-pointed white star placed just outside the crescent opening. The white crescent and star are offset slightly towards the hoist side of center."
    },
    "name": {
      "common": "Turkey",
      "official": "Republic of Turkey",
      "nativeName": {
        "tur": {
          "official": "Türkiye Cumhuriyeti",
          "common": "Türkiye"
        }
      }
    },
    "cca2": "TR",
    "capital": [
      "Ankara"
    ],
    "region": "Asia",
    "languages": {
      "tur": "Turkish"
    },
    "population": 84339067
  }
]
 */