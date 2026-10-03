import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersistencePage(),
    );
  }
}

class PersistencePage extends StatefulWidget {
  const PersistencePage({super.key});

  @override
  State<PersistencePage> createState() => _PersistencePageState();
}

class _PersistencePageState extends State<PersistencePage> {
  final TextEditingController _nameController = TextEditingController();

  String _loadedName = '';

  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }

  Future<String> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistence Practice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await saveName(_nameController.text);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saved!'),
                  ),
                );
              },
              child: const Text('Save'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                final name = await loadName();

                if (!mounted) return;

                setState(() {
                  _loadedName = name;
                });
              },
              child: const Text('Load'),
            ),

            const SizedBox(height: 20),

            Text(
              'Loaded: $_loadedName',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}