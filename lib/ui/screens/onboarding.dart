import 'package:flutter/material.dart';
import 'package:fundamental_flutter_project/ui/screens/home.dart';
import '../../models/user.dart';
import '../widgets/cus_textfield.dart';
class OnBoardingScreen extends StatefulWidget {
  final User user;
  const OnBoardingScreen({super.key, required this.user});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final nameController = TextEditingController();
  AmountType? amountType;
  void onPress() {
    widget.user.setName(nameController.text);
    widget.user.setAmountType(amountType!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: widget.user),
      ),
    );
  } 

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("Smart Financial", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF2F7E79), fontSize: 30, fontWeight: FontWeight.w900),)),
            SizedBox(height: 40),
            Expanded(child: Center(child: Image.asset("assets/onBoarding.png"))),
            CustomTextField(label: "NAME", hintText: "Enter your name", text: nameController, validator: null,),
            SizedBox(height: 8),
            Text("AMOUNT TYPE", style: TextStyle(color: Colors.black),),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:amountType == AmountType.riel ? Color(0xFF63B5AF) : Colors.white,
                      padding: EdgeInsets.all(20),
                      side: BorderSide(color: Colors.grey, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                    onPressed: (){
                      setState(() {
                        amountType = AmountType.riel;
                      });
                    }, 
                    child: Row(
                      children: [
                        Image.asset("assets/riel.png", height: 19,),
                        SizedBox(width: 10),
                        Text("Riels", style: TextStyle(color:amountType == AmountType.riel ? Colors.white : Colors.grey, fontSize: 14))
                      ],
                    )
                  )
                ),
                SizedBox(width: 50),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: amountType == AmountType.dollar? Color(0xFF63B5AF) : Colors.white,
                      padding: EdgeInsets.all(20),
                      side: BorderSide(color: Colors.grey, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                    onPressed: (){
                      setState(() {
                        amountType = AmountType.dollar;
                      });
                    }, 
                    child: Row(
                      children: [
                        Image.asset("assets/dollar.png", height: 19,),
                        SizedBox(width: 10),
                        Text("Dollars", style: TextStyle(color:  amountType == AmountType.dollar? Colors.white : Colors.grey, fontSize: 14))
                      ],
                    )
                  )
                )
              ],
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:  Color(0xFF2F7E79),
                  backgroundColor: Color(0xFF2F7E79),
                  padding: EdgeInsets.all(18),
                  shadowColor: Color(0xFF63B5AF),
                  elevation: 10
                ),
                onPressed: amountType == null ? null : onPress, 
                child: Text("Get Started", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        ),
      ),
    );
  }
}