import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_world_countries/common_list.dart';
import 'package:flutter_world_countries/country_model.dart';
import 'package:flutter_world_countries/favorites_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Api Url
  final String _apiUrl =
      "https://restcountries.com/v3.1/all?fields=name,flags,cca2,capital,region,languages,population";

  //Veri buradan json listesi olarak geliyor.
  List<Country> _allCountry = [];

  //Favori Listesi
  List<String> _favoriteCountryCodes = [];

  //Fonksiyonu çağırma işlemi ekran açılır açılmaz çağırılsın istiyorum bu sebeple initState içerisinde bir kez çağırılsın istediğim için burada
  //Çağırıyorum.
  @override
  void initState() {
    super.initState();
    //Ekranın çizildiğini kontrol etmek için;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Ülkeler ekrana çizdirilirken ülke favorilere eklimi değilmi bilmesi gerektiği için ülkeler ekrana çizilmeden favoriler ekrana
      //çizilmelidir.
      //Favorileri cihaz hafızasından çek
      _retrieveFavoritesFromDeviceMemory().then((value) {
        //İnternetten çekme fonksiyonunu çağırıyoruz.
        _pullCountriesFromInternet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  //AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.yellow[200],
      title: Text("Tüm Ülkeler"),
      centerTitle: true,
      actions: [
        IconButton(icon: Icon(Icons.favorite, color: Colors.red,),onPressed:(){
          //context intiyacımız olduğu için fonksiyonu(){} bu şekilde açtık.
          _openFavoritesPage(context);
        },),
      ],
    );
  }

  //Body
  Widget _buildBody() {
    //Verileri tek tek oluşturmaktansa body test ediyoruz.
    //Burada liste boşsa yüklenme efektini göstersin liste dolu ise Listview.builderla ekrana öğeler gelsin istediğim
    //için burada koşul yapıyorum.
    return _allCountry.isEmpty
        ? Center(child: CircularProgressIndicator())
        : CommonList(_allCountry, _favoriteCountryCodes);
  }

  

  //Ülkerli internetten çekme
  void _pullCountriesFromInternet() async {
    //_apiUrl internetten veri çekeceğimiz yer
    Uri uri = Uri.parse(_apiUrl);
    //http kullanarak verileri çekme
    http.Response response =
        await http.get(uri); //Dönen cevap response nesnesine gelir.

    //Çözümleme
    //Dart bize jsondaki verileri bize dynamic olarak verdiği için list dynamic yapıyoruz.
    List<dynamic> parsedResponse = jsonDecode(response.body);

    //Listeyi sıra ile gezmesi için;
    for (int i = 0; i < parsedResponse.length; i++) {
      Map<String, dynamic> countryMap = parsedResponse[i];
      //Modele gidip bakıyoruz ve nesne oluşturmak için ülke map ihtiyacımız olduğunu görüyoruz.
      Country country = Country.fromMap(countryMap);
      //Ülkeyi oluşturduğumuza göre bunu bütün ülkelere ekleyebiliriz.
      _allCountry.add(country);
    }
    //For işini bitirince setState çağırıyoruz ama bunu yapmadan önce sayfanın stateful widget olması gerekir.
    setState(() {
      //Ekranı güncellemek için kullanılır.
    });
  }

  

  //Üst kısımda oluşturduğumuz favoriler listesi boş olduğu için favori listeyi çağırma işlemi yapmamız gerekiyor bu sebepten dolayı;
  //Favırileri cihaz hafızasından çekme işlemi;
  //Üst kısımda bunu then bloğu ile çağırdığımız için bunu void değil future void yapacağım. olarak yazıyoruz.Bu işlemi yaptıktan sonra then
  //kullanımına izin verir.
  Future<void> _retrieveFavoritesFromDeviceMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Favorileri hafızadan çekme;//Null çünkü favorilenen ülke olmayabilir.
    List<String>? favorites = prefs.getStringList("Favoriler");

    //Favorileri null mı değil mi kontrol işlemi
    if (favorites != null) {
      //Null değilse elemanları tek tek dolaşıyoruz.
      for (String countryCode in favorites) {
        _favoriteCountryCodes.add(countryCode);
      }

      //Null değilse ekranı güncellemek için setstate yapalım.
    }
  }
  
  void _openFavoritesPage(BuildContext context) {
    //Favori sayfasına yönlendirme
     MaterialPageRoute pagePath = MaterialPageRoute(
      builder: (context) {
        //builder parametresi fonksiyon alır.
        return Favorites(_allCountry, _favoriteCountryCodes);
      },
    );
    Navigator.push(context, pagePath);
  }
}
