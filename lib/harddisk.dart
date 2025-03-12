import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'pc_provider.dart'; // Import your provider file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mvqkpqeydbunjhzdjmfb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12cWtwcWV5ZGJ1bmpoemRqbWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkyNzExNTQsImV4cCI6MjA1NDg0NzE1NH0.ezKO9vkplX6kgDhq2aSbderrcuDcfakmI5vBrsUT3JU',
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => PCProvider(), // Initialize provider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HardDiskListScreen(),
    );
  }
}

class HardDiskListScreen extends StatefulWidget {
  @override
  _HardDiskListScreenState createState() => _HardDiskListScreenState();
}

class _HardDiskListScreenState extends State<HardDiskListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchHardDisks() async {
    final response = await supabase.from('harddisks').select();
    return response;
  }

  void _onHardDiskSelected(BuildContext context, Map<String, dynamic> hardDisk) {
    context.read<PCProvider>().updateStorage(
      hardDisk['name'],
      hardDisk['image_url'] ?? 'https://via.placeholder.com/150', // Default image if null
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hard Disks')),
      body: FutureBuilder(
        future: fetchHardDisks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hard disks found'));
          }

          final hardDisks = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: hardDisks.length,
            itemBuilder: (context, index) {
              final hardDisk = hardDisks[index];
              return Card(
                child: ListTile(
                  leading: hardDisk['image_url'] != null
                      ? Image.network(hardDisk['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.storage),
                  title: Text(hardDisk['name']),
                  subtitle: Text(
                    'Capacity: ${hardDisk['capacity']}\n'
                    'Type: ${hardDisk['type']}\n'
                    'Cache: ${hardDisk['cache']}\n'
                    'Form Factor: ${hardDisk['form_factor']}\n'
                    'Interface: ${hardDisk['interface']}\n'
                    'Price: \$${hardDisk['price']}'
                  ),
                  isThreeLine: true,
                  onTap: () => _onHardDiskSelected(context, hardDisk),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
