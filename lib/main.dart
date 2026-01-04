import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/share_reference.dart';
import 'data/sqlite.dart';
import 'l10n/app_localization.dart';
import 'models/user.dart';
import 'ui/screens/budget_goal.dart';
import 'ui/screens/home.dart';
import 'ui/screens/profile.dart';
import 'ui/screens/language.dart';
import 'ui/screens/statistic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Sqlite.dropDatabase();
  // await ShareReference.remove();
  // runApp(
  //   MaterialApp(
  //     home: Scaffold(
  //       body: Center(
  //         child: Text("Hello"),
  //       ),
  //     ),
  //   )
  // );
  bool isCreated = await ShareReference.isCreated();
  User? user;

  if(isCreated) {
    Map<String, dynamic> userInfo = await ShareReference.readUserInfo();
    user = User(
      name: userInfo['name'],
      profileImage: "",
      preferredLanguage: userInfo['language'],
      preferredAmountType: userInfo['amountType'],
      transactions: await Sqlite.getTransactions(),
      budgetGoals: await Sqlite.getBudgetGoals(),
    );
  }
  runApp(MyApp(user: user));

}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? LanguageScreen() : AppRoot(user: user!),
    );
  }
}

class AppRoot extends StatefulWidget {
  final User user;
  const AppRoot({super.key, required this.user});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late Locale _locale;
  int _currentTabIndex = 0;

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
      home:Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          HomeScreen(key: ValueKey(_currentTabIndex) ,user: widget.user),
          StatisticScreen(key: ValueKey(_currentTabIndex), user: widget.user),
          BudgetGoalScreen(user: widget.user),
          ProfileScreen(
            user: widget.user, 
            onSelectLanguage: changeLanguage
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), 
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(20), 
            border: Border.all(color: const Color.fromARGB(255, 239, 238, 238), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4), 
              ),
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), 
            child: BottomNavigationBar(
              elevation: 10,
              type: BottomNavigationBarType.fixed, 
              selectedItemColor: Color(0xFF438883),
              unselectedItemColor: Colors.grey,
              currentIndex: _currentTabIndex,
              onTap: (index) {
                setState(() => _currentTabIndex = index);
              },
              items: const [
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.house_rounded),
                ), label: 'Home'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.bar_chart_rounded),
                ), label: 'Statistic'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.track_changes),
                ), label: 'Budget Goal'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.person),
                ), label: 'Profile'),
              ],
            ),
          )
        )
      )
    ),
    );
  }
}


