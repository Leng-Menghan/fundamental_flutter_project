import 'package:fundamental_flutter_project/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ShareReference {
  static Future<void> remove() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('image');
    await prefs.remove('language');
  }
  static Future<void> setName(String name) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }
  static Future<void> setImage(String image) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('image', image);
  }
  static Future<void> setLanguage(Language l) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', l == Language.english ? "en" : "km");
  }
  static Future<void> setAmountType(AmountType type) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('amountType', type == AmountType.dollar ? "dollar" : "riel");
  }
  static Future<bool> isCreated() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') != null ? true : false;
  }

  static Future<Map<String, dynamic>> readUserInfo() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('name');
    final String? image = prefs.getString('image');
    final String? at = prefs.getString('amountType');
    final AmountType amountType = at == "dollar" ? AmountType.dollar : AmountType.riel;
    final String? lang = prefs.getString('language');
    final Language language = lang == "en" ? Language.english : Language.khmer;
    return {
      'name' : name,
      'image': image,
      'amountType' : amountType,
      'language' : language
    };
  }
}