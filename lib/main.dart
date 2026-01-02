import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/database.dart';
import 'l10n/app_localization.dart';
import 'models/user.dart';
import 'ui/navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDatabase();
  User currentUser = User(
    name: "Leng Menghan",
    profileImage: "",
    preferredLanguage: Language.english,
    preferredAmountType:AmountType.dollar,
    transactions: await DBHelper.getTransactions(),
    budgetGoals: await DBHelper.getBudgetGoals(),
  );
  runApp(AppRoot(user: currentUser));
}

class AppRoot extends StatefulWidget {
  final User user;
  const AppRoot({super.key, required this.user});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = _mapLanguageToLocale(widget.user.preferredLanguage);
  }

  void changeLanguage(Language language) {
    setState(() {
      _locale = _mapLanguageToLocale(language);
    });
  }

  Locale _mapLanguageToLocale(Language language) {
    switch (language) {
      case Language.khmer:
        return const Locale('km');
      case Language.english:
        return const Locale('en');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan).copyWith(
          primary: Color(0xFF438883),
          secondary: Color(0xFF63B5AF),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 16),
          titleMedium: TextStyle(fontSize: 14),
          titleSmall: TextStyle(fontSize: 12)
        )
      ),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'), 
        Locale('km'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Navigation(user: widget.user, onSelectLanguage: changeLanguage),
    );
  }
}


