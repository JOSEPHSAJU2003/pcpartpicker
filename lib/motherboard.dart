import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'pc_provider.dart'; // Import your provider file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mvqkpqeydbunjhzdjmfb.supabase.co',
    anonKey: 'your_anon_key_here', // Replace with environment-secured key
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
      home: MotherboardListScreen(),
    );
  }
}

class MotherboardListScreen extends StatefulWidget {
  @override
  _MotherboardListScreenState createState() => _MotherboardListScreenState();
}

class _MotherboardListScreenState extends State<MotherboardListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchMotherboards() async {

    // given below is the compatibily checking part

    final String? socketType = Provider.of<PCProvider>(context, listen: false).socketType;

final response = socketType != null && socketType.isNotEmpty
    ? await supabase.from('motherboard').select().eq('socket_type', socketType as Object) // Ensure it's not null
    : await supabase.from('motherboard').select(); // Fetch all if null or empty

    return response;
  }

  void _onMotherboardSelected(BuildContext context, Map<String, dynamic> motherboard) {
    context.read<PCProvider>().updateMotherboard(
      motherboard['name'],
      motherboard['image_url'] ?? 'https://via.placeholder.com/150',
      motherboard['ram_type'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Motherboards')),
      body: FutureBuilder(
        future: fetchMotherboards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No motherboards found'));
          }

          final motherboards = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: motherboards.length,
            itemBuilder: (context, index) {
              final motherboard = motherboards[index];
              return Card(
                child: ListTile(
                  leading: motherboard['image_url'] != null && motherboard['image_url'].isNotEmpty
                      ? Image.network(
                          motherboard['image_url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.memory),
                        )
                      : Icon(Icons.memory),
                  title: Text(motherboard['name'] ?? 'Unknown'),
                  subtitle: Text(
                    'Socket Type: ${motherboard['socket_type'] ?? 'N/A'}\n'
                    'Form Factor: ${motherboard['form_factor'] ?? 'N/A'}\n'
                    'Ram Type: ${motherboard['ram_type'] ?? 'N/A'}\n'
                    'Max Memory: ${motherboard['max_memory'] ?? 'N/A'} GB\n'
                    'Memory Slots: ${motherboard['memory_slots'] ?? 'N/A'}\n'
                    'Color: ${motherboard['color'] ?? 'N/A'}\n'
                    'Price: \$${motherboard['price'] ?? 'N/A'}',
                  ),
                  isThreeLine: true,
                  onTap: () => _onMotherboardSelected(context, motherboard),
                ),
              );
            },
          );
        },
      ),
    );
  }
}