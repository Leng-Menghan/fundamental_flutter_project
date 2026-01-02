import 'package:flutter/material.dart';
enum Language{
  khmer(imageAsset: "assets/cambodia_flag.png", name: "ខ្មែរ / Khmer"),
  english(imageAsset: "assets/england_flag.png", name: "អង់គ្លេស / English");

  final String imageAsset;
  final String name;
  const Language({required this.imageAsset, required this.name});
}
class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
  });

  void onPress(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF63B5AF),
              Color(0xFF438883),
            ],),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("Smart Finance", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900),)),
            SizedBox(height: 40),
            Text("ភាសា / LANGUAGE", style: TextStyle(color: Colors.white),),
            SizedBox(height: 10),
            ...Language.values.map((l) => 
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  onPressed: () => onPress(), 
                  child: Row(
                    children: [
                      Image.asset(l.imageAsset, width: 43,),
                      SizedBox(width: 10),
                      Text(l.name, style: TextStyle(color: Colors.white, fontSize: 14))
                    ],
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

