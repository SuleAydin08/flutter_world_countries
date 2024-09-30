import 'package:flutter/material.dart';
import 'package:flutter_world_countries/common_list.dart';
import 'package:flutter_world_countries/country_model.dart';

class Favorites extends StatefulWidget {
 //İnternetten tekrar çekmeyelim diye bu şekilde çağırdık.(Tüm ülkeler ve favori ülke kodlarını).
  //Veri buradan json listesi olarak geliyor.
  final List<Country> _allCountry ;

  //Favori Listesi
  final List<String> _favoriteCountryCodes ;

//Ben ana sayfada favoriler widgetında öğe oluşturmak istiyorum.Buradaki Stateden değil.
  Favorites(this._allCountry, this._favoriteCountryCodes);
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  //Favori ülkeler
  List<Country> _favoriteCountries = [];//İnit state kısmında _allCountry ve _favoriteCountryCodes kısımlarına ihtiyacım 
  //var ama bu kısımlar private olduğu için erişimim yok favoriler sınıfının içerisinde kaldı biz FavoritesState sınıfının içindeyiz.
  //Bu durumda üst kısımdan bu kısıma alırız ama constracter ismini sınıf ismiyle aynı yaparız. YAni FavoritesState yapmalıyız.

//  //İnternetten tekrar çekmeyelim diye bu şekilde çağırdık.(Tüm ülkeler ve favori ülke kodlarını).
//   //Veri buradan json listesi olarak geliyor.
//   final List<Country> _allCountry ;

//   //Favori Listesi
//   final List<String> _favoriteCountryCodes ;

// //Ben ana sayfada favoriler widgetında öğe oluşturmak istiyorum.Buradaki Stateden değil.
//   FavoritesState(this._allCountry, this._favoriteCountryCodes);//Bu yöntem sorunumu çözmedi.

  @override
  void initState() {
    super.initState();
    // //State sınıfında fovariler sınıfından bir nesne üretiyorum.//Favorites(_allCountry, _favoriteCountryCodes) bu değerlere ulaşamıyorum.
    // //Buda bir yöntem ama ulaşamadığımız için listelere sorunumu çözmüyor.
    // Favorites favorites = Favorites(_allCountry, _favoriteCountryCodes);

    //Widget sınıfına ulaşma;//widget. diyerek sınıfa ulaştık.
    for(Country country in widget._allCountry){
      //Eğer ülke favorilerin içindeyse favorilere ekleme yapması için koşul oluşturuyoruz.
      if(widget._favoriteCountryCodes.contains(country.countryCode)){
        //Favori ülkeler listesine ülkeyi ekleme işlemi
        _favoriteCountries.add(country);
      }
    }
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //AppBar
  AppBar _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.yellow[200],
      title: Text("Favoriler"),
      centerTitle: true,
    );
  }

  //Body
  Widget _buildBody(){
    return CommonList(_favoriteCountries, widget._favoriteCountryCodes);
  }
}