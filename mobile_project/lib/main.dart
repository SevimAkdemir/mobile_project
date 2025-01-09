import 'package:flutter/material.dart';
import 'package:mobile_project/haritada_goster/YerleriHaritadaGoster.dart';
import 'haritada_goster/YemekleriHaritadaGoster.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'bildirimler/notification_service.dart';

void main() {
  runApp(MyApp());
  _requestPermission();
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    'id_unique_task',
    'simpleTask',
    frequency: Duration(minutes: 15), // Set periodicity here
    initialDelay: Duration(seconds: 10), // Delay before the first execution
  );
}

void _requestPermission() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Request permissions for iOS
  if (flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>() !=
      null) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // Here you can send the notification when the background task is executed.
    NotificationService().showNotification();
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Schedule the notification to occur every 15 minutes

    return MaterialApp(
      title: 'Giriş Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEYAHAT LİSTEM'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://bujuyollarda.com/wp-content/uploads/2022/10/en-iyi-seyahat-uygulamalari.jpg",
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Text(
              'Hoş Geldiniz',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IkinciSayfa()),
                );
              },
              child: const Text('Giriş Yapmak için Tıklayın'),
            ),
          ],
        ),
      ),
    );
  }
}

class IkinciSayfa extends StatelessWidget {
  const IkinciSayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Mailinizi Girin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifrenizi Girin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SehirSayfasi()),
                );
              },
              child: const Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}

class SehirSayfasi extends StatelessWidget {
  SehirSayfasi({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> sehirler = [
    {
      "isim": "İZMİR",
      "gorsel":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb08Mpa0uBQmixSp9FNMJrtNNsvJyRhV64UA&s",
      "height": 80.0,
      "width": 80.0,
      "fit": BoxFit.cover,
    },
  ];

  void sehirSayfasinaGit(String sehirIsmi, BuildContext context) {
    if (sehirIsmi == "İZMİR") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const IzmirSayfasi(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şehirler'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 sütunlu grid
          crossAxisSpacing: 8.0, // Sütunlar arasındaki boşluk
          mainAxisSpacing: 8.0, // Satırlar arasındaki boşluk
        ),
        itemCount: sehirler.length,
        itemBuilder: (context, index) {
          final sehir = sehirler[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Şehir görseli
                Container(
                  height: sehir['height'],
                  width: sehir['width'],
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(sehir['gorsel']),
                      fit: sehir['fit'],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                const SizedBox(height: 8),
                // Şehir ismi
                Text(
                  sehir['isim'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                // Keşfet butonu
                ElevatedButton(
                  onPressed: () {
                    sehirSayfasinaGit(sehir['isim'], context);
                  },
                  child: const Text('KEŞFET'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class IzmirSayfasi extends StatefulWidget {
  const IzmirSayfasi({Key? key}) : super(key: key);

  @override
  _IzmirSayfasiState createState() => _IzmirSayfasiState();
}

class _IzmirSayfasiState extends State<IzmirSayfasi> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'İzmir',
          style: TextStyle(
            color: Color(0xFF8B0000),
            fontSize: 27,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF8B0000),
          ),
          onPressed: () {
            Navigator.pop(context); // Bir önceki sayfaya dön
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xFF8B0000),
            ),
            onPressed: () {
              setState(() {
                isFavorited = !isFavorited;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorited
                        ? 'İzmir favorilere eklendi!'
                        : 'İzmir favorilerden çıkarıldı!',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.network(
                    "https://blog.obilet.com/wp-content/uploads/2018/03/izmirgezilecekyerler-min-scaled.jpeg",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    "Ege Bölgesi'nin batısında yer alan İzmir, Türkiye'nin üçüncü en büyük ili ve en önemli liman şehirlerinden biridir. İzmir, hem tarihi hem de modern yapılarıyla dikkat çeker; Agora, Kemeraltı Çarşısı ve Efes Antik Kenti gibi tarihi alanlara sahiptir. İzmir, denizcilik, ticaret ve sanayi açısından büyük bir öneme sahiptir ve Türkiye'nin en önemli limanına ev sahipliği yapar. Ayrıca, şehir, zeytinyağı, üzüm ve incir üretimiyle de ünlüdür. İzmir mutfağı, Ege'nin taze sebzeleri, zeytinyağlı yemekleri ve deniz ürünleriyle zengindir. Bölgede, \"İzmir köfte\", \"boyoz\" ve \"kumru\" gibi meşhur yemekler öne çıkar. İzmir, aynı zamanda sosyal yaşamı, festivalleri ve kültürel etkinlikleri ile de tanınır.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Nereye gitmek istersin butonuna tıklanınca YerSayfasiIzmir sayfasına yönlendirme
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const YerSayfasiIzmir(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.map, color: Colors.greenAccent),
                            SizedBox(width: 6),
                            Text(
                              'Nereye gitmek istersin?',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Ne yemek istersin butonuna tıklanınca YemekSayfasiIzmir sayfasına yönlendirme
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const YemekSayfasiIzmir(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.fastfood, color: Colors.yellowAccent),
                            SizedBox(width: 6),
                            Text(
                              'Ne yemek istersin?',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YerSayfasiIzmir extends StatelessWidget {
  const YerSayfasiIzmir({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> mekanlar = const [
    {
      'isim': 'Efes Antik Kenti',
      'gorsel':
          'https://img-hopi.mncdn.com/03/d7/03d7c69c2a56486fa7eca272d9235e9f.jpeg',
      'bilgi':
          'UNESCO Dünya Mirası Listesi’nde yer alan çukur İçihöyük, Ayasuluk Tepesi, Efes Antik Kenti ve Meryem Ana bölümlerine ev sahipliği yapan antik kent; Türkiye’nin en çok ziyaret edilen tarihi hazinelerinden biri. Antik dönemin en büyük ve en güçlü kentlerinden biri olma özelliği taşıyan kent Herakleitos ve Hermodos gibi pek çok bilim insanına da geçmiş yıllarda ev sahipliği yapmış.',
      'enlem': 37.940979177654675,
      'boylam': 27.341437124206053,
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gezilecek Yerler - İzmir'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2,
        ),
        itemCount: mekanlar.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YerDetaySayfasiIzmir(
                    isim: mekanlar[index]['isim']!,
                    gorsel: mekanlar[index]['gorsel']!,
                    bilgi: mekanlar[index]['bilgi']!,
                    enlem: mekanlar[index]
                        ['enlem'], // Enlem parametresi burada gönderiliyor
                    boylam: mekanlar[index]['boylam'],
                    mekanIsmi: mekanlar[index]
                        ['isim'], // Boylam parametresi burada gönderiliyor
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(mekanlar[index]['gorsel']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                Center(
                  child: Text(
                    mekanlar[index]['isim']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class YerDetaySayfasiIzmir extends StatelessWidget {
  final String isim;
  final String gorsel;
  final String bilgi;
  final double enlem; // Enlem parametresi eklendi
  final double boylam;
  final String mekanIsmi; // Boylam parametresi eklendi

  const YerDetaySayfasiIzmir({
    Key? key,
    required this.isim,
    required this.gorsel,
    required this.bilgi,
    required this.enlem, // Enlem parametresi
    required this.boylam,
    required this.mekanIsmi, // Boylam parametresi
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isim),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  gorsel,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                bilgi,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YerleriHaritadaGoster(
                      enlem: enlem, // Parametreleri burada gönderiyoruz
                      boylam: boylam,
                      mekanIsmi: mekanIsmi, // Parametreleri burada gönderiyoruz
                    ),
                  ),
                );
              },
              child: const Text('Haritada Bul'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class YemekSayfasiIzmir extends StatelessWidget {
  const YemekSayfasiIzmir({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> yemekler = const [
    {
      'isim': 'Boyoz',
      'gorsel':
      'https://cdn.ye-mek.net/App_UI/Img/out/650/2022/09/yufkadan-yalanci-boyoz-resimli-yemek-tarifi(19).jpg',
      'yemekBilgisi':
      'İzmir denildiğinde akla ilk gelen yemeklerden biri olan boyoz temelde bir hamur işi ürünü. Un ve sirke ile hazırlanan ve kendine ait bir hamura sahip olan boyoz, oldukça lezzetli bir alternatif. İzmir’de özellikle sabah kahvaltılarında yaygın olarak tercih edilen boyoz, genellikle yumurta ile satılıyor.',
      'enlem': 38.43922654243253,
      'boylam': 27.143869813594247,
      'restoranIsmi': 'Restoran ismi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İzmir Yemekleri'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2,
        ),
        itemCount: yemekler.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Yeni sayfaya yönlendirme
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YemekDetaySayfasiIzmir(
                    isim: yemekler[index]['isim']!,
                    gorsel: yemekler[index]['gorsel']!,
                    yemekBilgisi: yemekler[index]['yemekBilgisi']!,
                    enlem: yemekler[index]['enlem'], // Enlem parametresi burada gönderiliyor
                    boylam: yemekler[index]['boylam'],
                    restoranIsmi: yemekler[index]['restoranIsmi'],
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(yemekler[index]['gorsel']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                Center(
                  child: Text(
                    yemekler[index]['isim']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class YemekDetaySayfasiIzmir extends StatelessWidget {
  final String isim;
  final String gorsel;
  final String yemekBilgisi;
  final double enlem; // Enlem parametresi eklendi
  final double boylam;
  final String restoranIsmi;

  const YemekDetaySayfasiIzmir(
      {Key? key,
      required this.isim,
      required this.gorsel,
      required this.yemekBilgisi,
      required this.enlem,
      required this.boylam,
      required this.restoranIsmi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isim),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  gorsel,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                yemekBilgisi,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YemekleriHaritadaGoster(
                          enlem: enlem, // Parametreleri burada gönderiyoruz
                          boylam: boylam,
                          restoranIsmi:
                              restoranIsmi, // Parametreleri burada gönderiyoruz
                        ),
                      ),
                    );
                  },
                  child: const Text('Haritada Bul'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
