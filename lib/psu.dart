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
      home: PSUListScreen(),
    );
  }
}

class PSUListScreen extends StatefulWidget {
  @override
  _PSUListScreenState createState() => _PSUListScreenState();
}

class _PSUListScreenState extends State<PSUListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchPSUs() async {
    final response = await supabase.from('psu').select();
    return response;
  }

  void _onPSUSelected(BuildContext context, Map<String, dynamic> psu) {
    context.read<PCProvider>().updatePowerSupply(
      psu['name'],
      psu['image_url'] ?? 'https://via.placeholder.com/150', // Default image if null
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Power Supplies')),
      body: FutureBuilder(
        future: fetchPSUs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No power supplies found'));
          }

          final psus = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: psus.length,
            itemBuilder: (context, index) {
              final psu = psus[index];
              return Card(
                child: ListTile(
                  leading: psu['image_url'] != null && psu['image_url'].isNotEmpty
                      ? Image.network(
                          psu['image_url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.power),
                        )
                      : Icon(Icons.power),
                  title: Text(psu['name'] ?? 'Unknown'),
                  subtitle: Text(
                    'Form Factor: ${psu['form_factor'] ?? 'N/A'}\n'
                    'Efficiency Rating: ${psu['efficiency_rating'] ?? 'N/A'}\n'
                    'Wattage: ${psu['wattage'] ?? 'N/A'}W\n'
                    'Modular: ${psu['modular'] ?? 'N/A'}\n'
                    'Color: ${psu['color'] ?? 'N/A'}\n'
                    'Price: \$${psu['price'] ?? 'N/A'}',
                  ),
                  isThreeLine: true,
                  onTap: () => _onPSUSelected(context, psu),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
