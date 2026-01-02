import 'package:flutter/material.dart';
import '../../l10n/app_localization.dart';
import '../../models/user.dart';
import '../widgets/cus_textfield.dart';
import '../widgets/input_decoration.dart';
class ProfileScreen extends StatefulWidget {
  final User user;
  final ValueChanged<Language> onSelectLanguage;
  const ProfileScreen({super.key, required this.onSelectLanguage, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late Language userLanguage;

  @override
  void initState(){
    super.initState();
    name = widget.user.name;
    userLanguage = widget.user.preferredLanguage;
  }

  void onPressEdit(String oldName) async {
    String? newName = await openDialog(oldName);
    if (newName != null) {
      widget.user.name = newName;
      setState(() {
        name = newName;
      });
    }
  }

  void selectLanguage(Language l){
    widget.user.preferredLanguage = l;
    widget.onSelectLanguage(l);
    setState(() {
      userLanguage = l;
    });
  }

  Future<String?> openDialog(String oldName){
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    nameController.text = oldName;

    return showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: Text("Edit Name"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: CustomTextField(
                label: "NAME",
                hintText: "Edit name",
                text: nameController, 
                validator: (value) {
                  if (value == null || value.isEmpty) return "Name cannot be empty";
                  return null;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop<String>(nameController.text); 
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -1800,
            right: -1000,
            left: -1000,
            child: Container(
              height: 2000,
              width: 2000,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF63B5AF)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text(language.profile, style: textTheme.displaySmall?.copyWith(color: colorTheme.onPrimary))),
                SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(width: 3, color: colorTheme.primary)
                    ),
                    child: Image.asset("assets/dollar.png"),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name, style: textTheme.displayMedium?.copyWith(color: colorTheme.onSurface)),
                    IconButton(onPressed: () => onPressEdit(name), icon: Icon(Icons.edit, color: colorTheme.primary,))
                  ],
                ),
                const SizedBox(height: 20),
                Text(language.language.toUpperCase(), style:TextStyle(color: colorTheme.onSurface),),
                const SizedBox(height: 10),
                DropdownButtonFormField<Language>(
                  initialValue: userLanguage,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.keyboard_arrow_down),
                  ),
                  decoration: customInputDecoration(),
                  items: Language.values.map((l) {
                    return DropdownMenuItem<Language>(
                      value: l,
                      child: Row(
                        children: [
                          Image.asset(l.imageAsset, height: 20),
                          const SizedBox(width: 10),
                          Text(l.name, style: textTheme.titleMedium),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (l) {
                    if(l != null){
                      selectLanguage(l);
                    }
                  }
                ),                
                const SizedBox(height: 20),
                Text(language.amountType.toUpperCase(), style:TextStyle(color: colorTheme.onSurface),),
                const SizedBox(height: 10),
                DropdownButtonFormField<AmountType>(
                  initialValue: AmountType.dollar,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.keyboard_arrow_down),
                  ),
                  decoration: customInputDecoration(),
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

                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ));
  }
}