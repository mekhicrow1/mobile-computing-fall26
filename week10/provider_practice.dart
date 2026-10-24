
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Shared data model.
// The list stays private inside this class.
class ItemListModel extends ChangeNotifier {
  final List<String> _items = [];

  // Read the number of items without exposing the list.
  int get itemCount => _items.length;

  // Read one item at a time.
  String itemAt(int index) => _items[index];

  // Add an item to the shared list.
  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  // Remove an item from the shared list.
  void removeItem(int index) {
    if (index < 0 || index >= _items.length) return;

    _items.removeAt(index);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemListModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Provider Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// SCREEN 1: Displays the shared list.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch listens for changes and rebuilds this screen.
    final itemList = context.watch<ItemListModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Items (${itemList.itemCount})'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: itemList.itemCount == 0
          ? const Center(
              child: Text(
                'No items yet. Tap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: itemList.itemCount,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: Text(itemList.itemAt(index)),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    tooltip: 'Delete item',
                    onPressed: () {
                      // read accesses the model without listening here.
                      context.read<ItemListModel>().removeItem(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddScreen(),
            ),
          );
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// SCREEN 2: Adds an item to the shared list.
class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveItem() {
    final item = _controller.text.trim();

    // Do not add an empty item.
    if (item.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item first.'),
        ),
      );
      return;
    }

    // read calls the model's method to update the shared list.
    context.read<ItemListModel>().addItem(item);

    // Return to HomeScreen. No item is passed back.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Item name',
                hintText: 'Enter an item',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _saveItem(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveItem,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
