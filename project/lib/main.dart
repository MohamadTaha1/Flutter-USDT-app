import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:test1/login.dart';
import 'package:test1/intromessage.dart';
import 'package:url_launcher/url_launcher.dart';



void main() {
  final adListModel = AdListModel();
  adListModel.generateRandomAds();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
  create: (context) => ProfileModel(
    name: 'Mohamad Taha',
    email: 'mhmd.taha@gmail.com',
    location: 'Beirut',
    contactNumber: '81611436',
  ),
),

        ChangeNotifierProvider.value(value: adListModel),
      ],
      child: LoginApp(),
    ),
  );
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lebanese USDT Marketplace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}


class MyApp extends StatelessWidget {
  final String name;
  final String email;
  final String location;
  final String contactNumber;

  MyApp({
    required this.name,
    required this.email,
    required this.location,
    required this.contactNumber,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileModel(
            name: name,
            email: email,
            location: location,
            contactNumber: contactNumber,
          ),
        ),
        ChangeNotifierProvider.value(
          value: AdListModel()..generateRandomAds(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lebanese USDT Marketplace',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MyAdsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Usdtlogo.png',
              height: 36,
            ),
            SizedBox(width: 8),
            Text(
              'Lebanese USDT Marketplace',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'My Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}




class HomeScreen extends StatelessWidget {
/*  void _launchWhatsApp({required String phoneNumber, required String message}) async {
  String url() {
    return "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";
  }

  if (await canLaunchUrl(Uri.parse(url()))) {
    await launchUrl(Uri.parse(url()));
  } else {
    throw 'Could not launch $url()';
  }
} */

void _launchURL(BuildContext context, String phoneNumber, String message) async {
  final encodedMessage = Uri.encodeComponent(message);
  final urlAndroid = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');
  final urlIOS = Uri.parse('whatsapp://send?phone=$phoneNumber&text=$encodedMessage');
  final urlAlternative = Uri.parse('whatsapp://wa.me/$phoneNumber?text=$encodedMessage');

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    if (await canLaunchUrl(urlIOS)) {
      await launchUrl(urlIOS);
    } else if (await canLaunchUrl(urlAlternative)) {
      await launchUrl(urlAlternative);
    } else {
      throw 'Could not launch WhatsApp';
    }
  } else {
    if (await canLaunchUrl(urlAndroid)) {
      await launchUrl(urlAndroid);
    } else if (await canLaunchUrl(urlAlternative)) {
      await launchUrl(urlAlternative);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }
}





  @override
  Widget build(BuildContext context) {
    return Consumer<AdListModel>(
      builder: (context, adListModel, _) {
        return ListView.builder(
          itemCount: adListModel.ads.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return IntroMessage();
            }

            final ad = adListModel.ads[index - 1];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ad.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Posted by ${ad.name} in ${ad.location}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Contact: ${ad.contactNumber}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Posted at: ${DateFormat('yyyy-MM-dd – kk:mm').format(ad.createdAt)}',
                                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchURL(context, ad.contactNumber, 'Hello, I am interested in your ad.');

                        /*    _launchWhatsApp(
                              phoneNumber: ad.contactNumber,
                              message: "Hello, I'm interested in your ad: ${ad.title}",
                            );
                           
*/
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.chat, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}




class MyAdsScreen extends StatelessWidget {
  void _deleteAd(BuildContext context, Ad ad) {
    Provider.of<AdListModel>(context, listen: false).removeAd(ad);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(
      builder: (context, profileModel, _) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Consumer<AdListModel>(
                  builder: (context, adListModel, _) {
                    List<Ad> userAds = adListModel.ads
                        .where((ad) => ad.name == profileModel.name)
                        .toList();
                    return ListView.builder(
                      itemCount: userAds.length,
                      itemBuilder: (context, index) {
                        final ad = userAds[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ad.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Posted by ${ad.name} in ${ad.location}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Contact: ${ad.contactNumber}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Posted at: ${DateFormat('yyyy-MM-dd – kk:mm').format(ad.createdAt)}',
                                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => _deleteAd(context, ad),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateAdScreen(),
                      ),
                    );
                  },
                  child: Text('Create new Ad'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}




class CreateAdScreen extends StatefulWidget {
  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileModel = Provider.of<ProfileModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Create New Ad')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Ad Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title for your ad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newAd = Ad(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      name: profileModel.name,
                      location: profileModel.location,
                      contactNumber: profileModel.contactNumber,
                      createdAt: DateTime.now(),
                    );
                    Provider.of<AdListModel>(context, listen: false).addAd(newAd);
                    Navigator.of(context).pop();
                      }
            },
            child: Text('Create Ad'),
          ),
        ],
      ),
    ),
  ),
); }
}




class Ad {
  final String id;
  final String title;
  final String name;
  final String location;
  final String contactNumber;
  final DateTime createdAt;

  Ad({
    required this.id,
    required this.title,
    required this.name,
    required this.location,
    required this.contactNumber,
    required this.createdAt,
  });
}

class AdListModel extends ChangeNotifier {
  List<Ad> _ads = [];

  List<Ad> get ads => _ads;

  void addAd(Ad ad) {
    _ads.insert(0, ad);
    notifyListeners();
  }

  void generateRandomAds() {
    final random = Random();
    final names = ["taleb","Mohamad Taha","mhmd","taha","omar","jana","hadi","andrew","nader","Mohamad Taha",];
    final locations = ["Beirut","Saida","Hamra","Koraytem","Ras el nabeh","Jbeil","trablos","chiyeh","basta","sour","meis"];
    for (int i = 0; i < 10; i++) {
      final adTitle = random.nextBool() ? 'Buying' : 'Selling';
      final usdtAmount = random.nextInt(100) * 10;
      final name =  names[i];
      final email = '$names[i]@gmail.com';
      final phoneNumber =  random.nextInt(900000) + 100000;
      final location = locations[i];
      print("+96103"+ phoneNumber.toString());

      addAd(
        Ad(
          id: DateTime.now().toString(),
          title: '$adTitle ${usdtAmount.toStringAsFixed(2)} USDT',
          name: name,
          location: location,
          contactNumber:"+96103"+ phoneNumber.toString(),
          createdAt: DateTime.now(),
        ),
      );
      }
    }
      void removeAd(Ad ad) {
    _ads.removeWhere((element) => element.id == ad.id);
    notifyListeners();
  } 
}


class ProfileModel extends ChangeNotifier {
  String name;
  String email;
  String location;
  String contactNumber;
  File? profileImage;

  ProfileModel({
    required this.name,
    required this.email,
    required this.location,
    required this.contactNumber,
    this.profileImage,
  });

  void updateProfile(
    String name,
    String email,
    String location,
    String contactNumber,
    [File? newProfileImage]
  ) {
    this.name = name;
    this.email = email;
    this.location = location;
    this.contactNumber = contactNumber;
    if (newProfileImage != null) {
      this.profileImage = newProfileImage;
    }
    notifyListeners();
  }
}



class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final profileModel = Provider.of<ProfileModel>(context, listen: false);
    _nameController.text = profileModel.name;
    _emailController.text = profileModel.email;
    _locationController.text = profileModel.location;
    _contactNumberController.text = profileModel.contactNumber;
  }

  Future<void> _getImage() async {
  final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    Provider.of<ProfileModel>(context, listen: false).updateProfile(
      _nameController.text,
      _emailController.text,
      _locationController.text,
      _contactNumberController.text,
      _pickedImage,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No image selected.'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final profileImage = Provider.of<ProfileModel>(context).profileImage;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(height: 20),
            Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    GestureDetector(
      onTap: _getImage,
      child: CircleAvatar(
        backgroundImage: _pickedImage != null
            ? FileImage(_pickedImage!) as ImageProvider<Object>?
            : (Provider.of<ProfileModel>(context).profileImage != null
                ? FileImage(Provider.of<ProfileModel>(context).profileImage!) as ImageProvider<Object>?
                : const AssetImage('assets/images/default_profile_image.png')),
        radius: 50,
      ),
    ),
    SizedBox(height: 5), // Add this line to create some space between the image and the message
    Text( // Add this line to show the message
      'Tap the image to change your profile picture',
      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
    ), // Add this line to show the message
    SizedBox(height: 10),
    Text(
      'Profile',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  ],
),

            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your location';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _contactNumberController,
              decoration: InputDecoration(labelText: 'Contact Number'),
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contact number';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
ElevatedButton(
onPressed: () {
if (_isEditing) {
if (_formKey.currentState!.validate()) {
final profileModel = Provider.of<ProfileModel>(context, listen: false);
profileModel.updateProfile(
  _nameController.text,
  _emailController.text,
  _locationController.text,
  _contactNumberController.text,
  _pickedImage,
);

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Profile updated successfully.'),
),
);
}
}
setState(() {
_isEditing = !_isEditing;
});
},
child: Text(_isEditing ? 'Save' : 'Edit'),
),
if (_isEditing)
ElevatedButton(
onPressed: () {
setState(() {
_isEditing = false;
});
},
child: Text('Cancel'),
),
],
),
],
),
),
);
}
}

