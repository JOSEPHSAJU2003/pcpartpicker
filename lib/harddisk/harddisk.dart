import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mvqkpqeydbunjhzdjmfb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12cWtwcWV5ZGJ1bmpoemRqbWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkyNzExNTQsImV4cCI6MjA1NDg0NzE1NH0.ezKO9vkplX6kgDhq2aSbderrcuDcfakmI5vBrsUT3JU',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HardDiskListPage(),
    );
  }
}

class HardDiskListPage extends StatefulWidget {
  @override
  _HardDiskListPageState createState() => _HardDiskListPageState();
}

class _HardDiskListPageState extends State<HardDiskListPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchHardDisks() async {
    try {
      final response = await supabase.from('harddisks').select();
      print("Supabase Response: $response"); // Debugging log
      return response;
    } catch (error) {
      print("Error fetching hard disks: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hard Disks")),
      body: FutureBuilder<List<dynamic>>(
        future: fetchHardDisks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hard disks available"));
          }

          final hardDisks = snapshot.data!;
          return ListView.builder(
            itemCount: hardDisks.length,
            itemBuilder: (context, index) {
              final hardDisk = hardDisks[index];
              return buildHardDiskCard(hardDisk);
            },
          );
        },
      ),
    );
  }

  Widget buildHardDiskCard(dynamic hardDisk) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                hardDisk['Image_URL'] ?? 'https://via.placeholder.com/100',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hardDisk['name'] ?? "Unknown",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text("Capacity: ${hardDisk['capacity'] ?? '-'}"),
                  Text("Type: ${hardDisk['type'] ?? '-'}"),
                  Text("Cache: ${hardDisk['cache'] ?? '-'}"),
                  Text("Form Factor: ${hardDisk['form_factor'] ?? '-'}"),
                  Text("Interface: ${hardDisk['interface'] ?? '-'}"),
                  Text("Price: \$${hardDisk['price'] ?? '-'}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
