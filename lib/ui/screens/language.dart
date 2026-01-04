import 'package:flutter/material.dart';
import 'package:fundamental_flutter_project/utils/animations_util.dart';
import '../../data/share_reference.dart';
import './name.dart';
import '../../models/user.dart';
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({
    super.key,
  });

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
                  onPressed: () async {
                      await ShareReference.setLanguage(l);
                      Navigator.pushReplacement(
                        context,
                        AnimationUtils.slideTBWithFade(NameScreen())
                      );
                  }, 
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

