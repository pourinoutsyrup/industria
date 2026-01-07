import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/supplement_provider.dart';
import '../models/models.dart';

class SupplementsScreen extends StatefulWidget {
  const SupplementsScreen({super.key});

  @override
  State<SupplementsScreen> createState() => _SupplementsScreenState();
}

class _SupplementsScreenState extends State<SupplementsScreen> {
  final uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupplementProvider>().loadSupplements();
    });
  }

  void _showAddSupplementDialog() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    String timeCluster = 'morning';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('ADD SUPPLEMENT'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dosageController,
                  decoration: const InputDecoration(labelText: 'Dosage'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: timeCluster,
                  decoration: const InputDecoration(labelText: 'Time'),
                  items: const [
                    DropdownMenuItem(value: 'morning', child: Text('Morning')),
                    DropdownMenuItem(value: 'afternoon', child: Text('Afternoon')),
                    DropdownMenuItem(value: 'evening', child: Text('Evening')),
                    DropdownMenuItem(value: 'night', child: Text('Night')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      timeCluster = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || dosageController.text.isEmpty) {
                  return;
                }

                final supplement = Supplement(
                  id: uuid.v4(),
                  name: nameController.text,
                  dosage: dosageController.text,
                  timeCluster: timeCluster,
                );

                context.read<SupplementProvider>().addSupplement(supplement);
                Navigator.pop(context);
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supplementProvider = context.watch<SupplementProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SUPPLEMENTS'),
      ),
      body: supplementProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : supplementProvider.supplements.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medication_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No supplements added',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text('Tap + to add your first supplement'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: supplementProvider.supplements.length,
                  itemBuilder: (context, index) {
                    final supplement = supplementProvider.supplements[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.medication),
                        title: Text(supplement.name),
                        subtitle: Text('${supplement.dosage} • ${supplement.timeCluster}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            supplementProvider.deleteSupplement(supplement.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSupplementDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
