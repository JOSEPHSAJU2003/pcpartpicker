import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'pc_provider.dart'; // Import your provider file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mvqkpqeydbunjhzdjmfb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12cWtwcWV5ZGJ1bmpoemRqbWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkyNzExNTQsImV4cCI6MjA1NDg0NzE1NH0.ezKO9vkplX6kgDhq2aSbderrcuDcfakmI5vBrsUT3JU', // Replace with environment-secured key
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
      home: RAMListScreen(),
    );
  }
}

class RAMListScreen extends StatefulWidget {
  @override
  _RAMListScreenState createState() => _RAMListScreenState();
}

class _RAMListScreenState extends State<RAMListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchRAMs() async {
    final String? ramType = Provider.of<PCProvider>(context, listen: false).ramType;
    final response = ramType != null && ramType.isNotEmpty
    ? await supabase.from('ram').select().like('speed', '$ramType%')
    : await supabase.from('ram').select();
return response; 
  }

  void _onRAMSelected(BuildContext context, Map<String, dynamic> ram) {
    context.read<PCProvider>().updateRAM(
      ram['name'],
      ram['image_url'] ?? 'https://via.placeholder.com/150', // Default image if null
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RAM Modules')),
      body: FutureBuilder(
        future: fetchRAMs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No RAM modules found'));
          }

          final rams = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: rams.length,
            itemBuilder: (context, index) {
              final ram = rams[index];
              return Card(
                child: ListTile(
                  leading: ram['image_url'] != null
                      ? Image.network(
                          ram['image_url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.memory),
                        )
                      : Icon(Icons.memory),
                  title: Text(ram['name']),
                  subtitle: Text(
                    'Speed: ${ram['speed']}\n'
                    'Modules: ${ram['modules']}\n'
                    'Price per GB: \$${ram['price_per_gb'] ?? 'N/A'}\n'
                    'Color: ${ram['color'] ?? 'N/A'}\n'
                    'First Word Latency: ${ram['first_word_latency'] ?? 'N/A'} ns\n'
                    'CAS Latency: ${ram['cas_latency'] ?? 'N/A'}\n'
                    'Total Price: \$${ram['price']}'
                  ),
                  isThreeLine: true,
                  onTap: () => _onRAMSelected(context, ram),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
