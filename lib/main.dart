import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = ui.window.locale.languageCode == 'ru'
      ? Locale('ru')
      : ui.window.locale.languageCode == 'en'
      ? Locale('en')
      : Locale('kk');

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void changeLanguage(String code) {
    setState(() {
      _locale = Locale(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: [
        Locale('en'),
        Locale('ru'),
        Locale('kk'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return Locale('kk');
        for (var supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return Locale('kk');
      },
      home: HomePage(
        onToggleTheme: toggleTheme,
        onChangeLanguage: changeLanguage,
        currentLocale: _locale.languageCode,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final Function(String) onChangeLanguage;
  final String currentLocale;

  const HomePage({
    required this.onToggleTheme,
    required this.onChangeLanguage,
    required this.currentLocale,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> items = [
    "Milk", "Bread", "Eggs", "Cheese", "Butter",
    "Tomatoes", "Apples", "Bananas", "Chicken", "Pasta"
  ];
  List<bool> isChecked = List.generate(10, (index) => false);

  void addItem() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t("addItem")),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: _t("enterItem")),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t("cancel")),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(_t("add")),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        items.add(result);
        isChecked.add(false);
      });
    }
  }

  void editItem(int index) async {
    final controller = TextEditingController(text: items[index]);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t("editItem")),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: _t("enterNewName")),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text(_t("cancel")),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'delete'),
            child: Text(_t("delete"), style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(_t("save")),
          ),
        ],
      ),
    );

    if (result == 'delete') {
      setState(() {
        items.removeAt(index);
        isChecked.removeAt(index);
      });
    } else if (result != null && result != 'cancel' && result.isNotEmpty) {
      setState(() {
        items[index] = result;
      });
    }
  }

  void toggleCheckbox(int index, bool? value) {
    setState(() {
      isChecked[index] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("shoppingList")),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
          PopupMenuButton<String>(
            onSelected: widget.onChangeLanguage,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'en', child: Text("English")),
              PopupMenuItem(value: 'ru', child: Text("Русский")),
              PopupMenuItem(value: 'kk', child: Text("Қазақша")),
            ],
            icon: Icon(Icons.language),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: isLandscape
                      ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 4,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ShoppingItemCard(
                        item: items[index],
                        isChecked: isChecked[index],
                        onCheckChanged: (value) => toggleCheckbox(index, value),
                        onTap: () => editItem(index),
                      );
                    },
                  )
                      : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return ShoppingItemCard(
                        item: items[index],
                        isChecked: isChecked[index],
                        onCheckChanged: (value) => toggleCheckbox(index, value),
                        onTap: () => editItem(index),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: addItem,
                      icon: Icon(Icons.add),
                      label: Text(_t("addItem")),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String _t(String key) {
    Map<String, Map<String, String>> translations = {
      'shoppingList': {
        'en': 'Shopping List',
        'ru': 'Список покупок',
        'kk': 'Сатып алу тізімі'
      },
      'addItem': {
        'en': 'Add Item',
        'ru': 'Добавить',
        'kk': 'Қосу'
      },
      'cancel': {
        'en': 'Cancel',
        'ru': 'Отмена',
        'kk': 'Бас тарту'
      },
      'add': {
        'en': 'Add',
        'ru': 'Добавить',
        'kk': 'Қосу'
      },
      'editItem': {
        'en': 'Edit Item',
        'ru': 'Редактировать',
        'kk': 'Өзгерту'
      },
      'enterItem': {
        'en': 'Enter item name',
        'ru': 'Введите название',
        'kk': 'Атауын енгізіңіз'
      },
      'enterNewName': {
        'en': 'Enter new name',
        'ru': 'Новое название',
        'kk': 'Жаңа атау'
      },
      'delete': {
        'en': 'Delete',
        'ru': 'Удалить',
        'kk': 'Жою'
      },
      'save': {
        'en': 'Save',
        'ru': 'Сохранить',
        'kk': 'Сақтау'
      },
    };

    return translations[key]?[widget.currentLocale] ?? key;
  }
}

class ShoppingItemCard extends StatelessWidget {
  final String item;
  final bool isChecked;
  final ValueChanged<bool?> onCheckChanged;
  final VoidCallback onTap;

  ShoppingItemCard({
    required this.item,
    required this.isChecked,
    required this.onCheckChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => onCheckChanged(!isChecked),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.shade200),
        ),
        child: Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: onCheckChanged,
              activeColor: Colors.teal,
            ),
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 18,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  color: isChecked ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(Icons.edit, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
