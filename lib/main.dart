import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
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
        title: Text("Add Item"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter item name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text("Add"),
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
        title: Text("Edit Item"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter new name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'delete'),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text("Save"),
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
      appBar: AppBar(title: Text('Shopping List')),
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
                      label: Text("Add Item"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/about'),
                      icon: Icon(Icons.info_outline),
                      label: Text("About"),
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
      onTap: onTap, // edit on tap
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

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Shopping List App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Shopping List App helps users easily create, manage, and organize their shopping lists. '
                  'With an intuitive interface, users can add, edit, and check off items, ensuring a smooth shopping experience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Credits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Developed by Maksat, Alan and Kuanysh in the scope of the course “Crossplatform Development” '
                  'at Astana IT University.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Mentor (Teacher): Assistant Professor Abzal Kyzyrkanov',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
