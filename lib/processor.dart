import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'pc_provider.dart'; 

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
      home: ProcessorListScreen(),
    );
  }
}

class ProcessorListScreen extends StatefulWidget {
  @override
  _ProcessorListScreenState createState() => _ProcessorListScreenState();
}

class _ProcessorListScreenState extends State<ProcessorListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  
  Future<List<dynamic>> fetchProcessors() async {
    final response = await supabase.from('processor').select();
    return response;
  }

    void _onProcessorSelected(BuildContext context, Map<String, dynamic> processor) {
    context.read<PCProvider>().updateCPU(
      processor['name'],
      processor['image_url'] ?? 'https://via.placeholder.com/150',
      processor['socket_type'],
      
      
    );
    print("Selected CPU: ${processor['name']}, Socket: ${processor['socket_type']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Processors')),
      body: FutureBuilder(
        future: fetchProcessors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No processors found'));
          }

          final processors = snapshot.data as List<dynamic>;
          
          return ListView.builder(
            itemCount: processors.length,
            itemBuilder: (context, index) {
              final processor = processors[index];
              return Card(
                child: ListTile(
                  leading: processor['image_url'] != null
                      ? Image.network(processor['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.memory),
                  title: Text(processor['name']),
                  subtitle: Text(
                    'Cores: ${processor['core_count']}\n'
                    'Clock: ${processor['performance_core_clock']} GHz (Boost: ${processor['performance_core_boost_clock']} GHz)\n'
                    'TDP: ${processor['tdp']}W\n'
                    'Socket: ${processor['socket_type']}\n'
                    'Chipset: ${processor['chipset_type']}\n'
                    'Graphics: ${processor['integrated_graphics']}\n'
                    'Microarchitecture: ${processor['microarchitecture']}\n'
                    'Price: \$${processor['price']}'
                  ),
                  isThreeLine: true,
                  onTap: () => _onProcessorSelected(context, processor),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
