import 'package:flutter/material.dart';
import 'package:flutter_world_countries/country_model.dart';

class CountriesDetailPage extends StatelessWidget {
  //Detayı ülkeye göre çizeceğimiz için ülkeyide almamız gerekiyor.
  final Country _country;
  //Constracter
  CountriesDetailPage(this._country); //Detayı gösterilecek ülke alınır.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  //AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.yellow[200],
      title: Text(
        _country.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      //Başlık ortalama
      centerTitle: true,
    );
  }

  //Body
  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        //Sayfayı ortalama
        SizedBox(
          width: double.infinity,
          //Üst kısımdan boşluk bırakma
          height: 18,
        ),
        _buildFlag(context),
        SizedBox(
          height: 15,
        ),
        _buildCountryNameText(),
        SizedBox(
          height: 28,
        ),
        _buildAllDetail(),
      ],
    );
  }

  //Tüm detay kısımları
  Widget _buildAllDetail() {
    return Padding(
      padding: const EdgeInsets.only(left:32 ),
      child: Column(
        children: [
          _buildDetailRow("Ülke İsmi: ", _country.name),
          _buildDetailRow("Başkent: ", _country.capitalCity),
          _buildDetailRow("Bölge: ", _country.region),
          _buildDetailRow("Nüfus: ", _country.population.toString()),
          _buildDetailRow("Dil: ", _country.language),
        ],
      ),
    );
  }

  //İçerikler
  //Ülke Bayrağı
  Widget _buildFlag(BuildContext context) {
    return Image.network(
      _country.flag,
      //Bayrağın ekranın yarısı kadar olmasını istersek;
      width: MediaQuery.sizeOf(context).width / 2,
      //Ben bir genişlik verdim sen verdiğim resmi genişliğe göre fitle
      fit: BoxFit.fitWidth,
    );
  }

  //Ülke İsmi
  Widget _buildCountryNameText() {
    return Text(
      _country.name,
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    );
  }

  //Ülke Detayları Yanyana
  //Bu kısım diğer detaylar içinde değişeceği için ortak widget oluşturuyoruz ve üst kısımda bunu her çağırdığımızda hangi değer
  //gelmesini istiyorsak parantez içerisinde yazıyoruz.
  Widget _buildDetailRow(String title, String detail) {
    return Row(
      children: [
        //Ben bu detail değerlerinin 10luk kısmın 3 ü başlık diğer 7lik kısımı detay harcasın istiyorsam expandedla
        //sararım ve flex değeri veririr.
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            // textAlign: TextAlign.end,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            detail,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }
}
