import 'package:flutter/material.dart';
import 'package:flutter_world_countries/countries_detail_page.dart';
import 'package:flutter_world_countries/country_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Bu kısmı ortak yapmamızın amacı ana sayfa ve favoriler sayfasının görünümü aynı olacaktı sadece tek fark favoriler 
//sayfasında favori ülkeler olacaktı bu sebeple ortak widget olarak yazdık.
class CommonList extends StatefulWidget {

  //Veri buradan json listesi olarak geliyor.
  List<Country> _country = [];//Favorilerde sadece favori ülkeler olacağı için allCountry country çevirdik.

  //Favori Listesi
  List<String> _favoriteCountryCodes = [];

  CommonList(this._country, this._favoriteCountryCodes);

  @override
  State<CommonList> createState() => _CommonListState();
}

class _CommonListState extends State<CommonList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemBuilder: _buildListItem,
            itemCount: widget._country.length,
          );
  }

  Widget _buildListItem(BuildContext context, int index) {
    //Listede ekranda ne görünmesini istiyorsak buraya yazıyoruz.
    //Bu şekilde yzarsak alt kısımda indexli şekilde yazmaya gerek yok her seferinde.
    Country country = widget._country[index];
    //Daha düzenli ve güzel durması için card ile sardık.
    return Card(
      child: ListTile(
        //Bunu _allCountry[index].name bu şekilde yazmak yerine returnden önce ülke nesnesini yazarız.
        title: Text(country.name),
        subtitle: Text("Başkent: ${country.capitalCity}"),
        //Baş kısma ülkenin bayrağını yuvarlak şekilde koymak istediğimiz için bu işlemi yapıyoruz.
        leading: CircleAvatar(
          backgroundImage: NetworkImage(country.flag),
        ),
        //Favori iconu
        trailing: IconButton(
          //İçi boş içi dolu icon kısmını yaptığımız yer.
          //Ülke eğer favoriler kısmına ekliyse içi dolu göster değilse içi boş göster.
          icon: Icon(
              widget._favoriteCountryCodes.contains(country.countryCode)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red),
          onPressed: () {
            _favoriteClicked(country);
          },
        ),
        //Tıklandığında detail sayfasına gidilmesi için tanımlanan fonksiyonun verileceği kısım.
        onTap: () {
          _countryClicked(context, country);
        },
      ),
    );
  }

  //Bu kısmı Listtile içerisinde çağırız çünkü Listtile öğeye tıkladığımızda detail sayfasına gitsin.
  void _countryClicked(BuildContext context, Country country) {
    //Sayfa yönlendirme kodu
    MaterialPageRoute pagePath = MaterialPageRoute(
      builder: (context) {
        //builder parametresi fonksiyon alır.
        return CountriesDetailPage(country);
      },
    );
    Navigator.push(context, pagePath);
  }

  //Favori butonun tıklandığında yapılacakların oluşması için oluşturduğumuz fonksiyon;
  void _favoriteClicked(Country country) async {
    //SharedPreferencesa ulaşma
    //Future döndüreceği için asyn await olacak
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Üst kısımda oluşturduğumuz favori listesine ekli mi değilmi bunun kontrolünü yapmak için kontrol sağlıyoruz.
    //Contains içerisine eklediğimiz değeri içerip içermediğine bakar.(Ülkenin ülke kodunu içerip içermediğine bakacağız bu sebeple fonksiyonda
    //Bunu parametre olarak alıyoruz.)
    if (widget._favoriteCountryCodes.contains(country.countryCode)) {
      //Eğer içeriyorsa bunu listeden sileceğim.
      widget._favoriteCountryCodes.remove(country.countryCode);
    } else {
      //Eğer içermiyorsa favorilere ekle;
      widget._favoriteCountryCodes.add(country.countryCode);
    }
    //Listem hazor artık cihazımın hafızasına kayıt ettireceğim.Future döndürdüğü için awaitdir.
    await prefs.setStringList("Favoriler", widget._favoriteCountryCodes);
    //Kayıt işlemi bitene kadar bekle ve sonrasında sayfayı güncelle.
    setState(() {
      //Butonun güncellenmesini istediğim için üst kısımdaki iconu koşula sokuyorum.
    });
  }
}