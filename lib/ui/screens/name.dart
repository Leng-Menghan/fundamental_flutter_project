import 'package:flutter/material.dart';
import 'package:fundamental_flutter_project/utils/animations_util.dart';
import '../../data/share_reference.dart';
import '../../data/sqlite.dart';
import '../../l10n/app_localization.dart';
import '../../main.dart';
import '../widgets/cus_textfield.dart';
import '../../models/user.dart';
import '../widgets/input_decoration.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  AmountType? amountType;
  void onPress() async{
    if (_formKey.currentState!.validate()) {
      String name = "${firstNameController.text.trim()} ${lastNameController.text.trim()}".trim();
      await ShareReference.setName(name);
      await ShareReference.setAmountType(amountType!);
      Map<String, dynamic> userInfo = await ShareReference.readUserInfo();
      await Sqlite.initDatabase();
      
      User user = User(
        name: name,
        profileImage: "",
        preferredLanguage: userInfo['language'],
        preferredAmountType: amountType!,
        transactions: [],
        budgetGoals: [],
      );

      Navigator.pushReplacement(
        context,
        AnimationUtils.scaleWithFade(AppRoot(user: user))
      );
    }
  } 

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }
    if (value.length > 20) {
      return "Can not more than 20 characters";
    }
    if (value.contains(' ')) {
      return "Name cannot contain spaces";
    }
    return null;
  }
  
  String? validateAmountType(AmountType? amountType) {
    if (amountType == null) {
      return "Please select amount type";
    }
    return null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Column(
          children: [
            Center(child: Text("Smart Financial", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF2F7E79), fontSize: 30, fontWeight: FontWeight.w900),)),
            SizedBox(height: 25),
            Center(child: Image.asset("assets/onBoarding.png", height: 150,)),
            SizedBox(height: 30),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(label: "FIRST NAME", hintText: "Enter your first name", text: firstNameController, validator: validateName,),
                    const SizedBox(height: 20),
                    CustomTextField(label: "LAST NAME", hintText: "Enter your last name", text: lastNameController, validator: validateName,),
                    const SizedBox(height: 20),
                    Text("AMOUNT TYPE", style:TextStyle(color: colorTheme.onSurface),),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<AmountType>(
                      initialValue: amountType,
                      validator: validateAmountType,
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                      decoration: customInputDecoration(),
                      hint: Text("Select Amount Type", style:const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 14),),
                      items: AmountType.values.map((at) {
                        return DropdownMenuItem<AmountType>(
                          value: at,
                          child: Row(
                            children: [
                              Image.asset(at.imageAsset, height: 20,),
                              const SizedBox(width: 10),
                              Text(at.name, style: textTheme.titleMedium),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            amountType = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),          
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
                onPressed: onPress, 
                child: Text("Get Started", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
              ),
            ),
          ],
        ),
      ),
    );
  }
}