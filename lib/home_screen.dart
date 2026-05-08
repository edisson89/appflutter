import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:network_x/item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  String? _editingItemId; // ID del item que se está editando

  // Controladores para los campos del formulario
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _editItem(Item item) {
    setState(() {
      _editingItemId = item.id;
      _nameController.text = item.name;
      _descriptionController.text = item.description;
    });
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_editingItemId == null) {
          // CREAR: Generamos una referencia nueva
          final docRef = _itemsCollection.doc();
          final newItem = Item(
            id: docRef.id,
            name: _nameController.text,
            description: _descriptionController.text,
          );
          await docRef.set(newItem.toJson());
        } else {
          // ACTUALIZAR: Usamos el ID existente
          await _itemsCollection.doc(_editingItemId).update({
            'name': _nameController.text,
            'description': _descriptionController.text,
          });
        }

        if (mounted) {
          final isEditing = _editingItemId != null;
          setState(() {
            _editingItemId = null;
          });

          _nameController.clear();
          _descriptionController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(isEditing ? '¡Item actualizado!' : '¡Item guardado!'),
                backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      await _itemsCollection.doc(id).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item eliminado correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network X - Items'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveItem,
                          child: Text(_editingItemId == null
                              ? 'Agregar Item'
                              : 'Actualizar Item'),
                        ),
                      ),
                      if (_editingItemId != null) ...[
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () => setState(() {
                            _editingItemId = null;
                            _nameController.clear();
                            _descriptionController.clear();
                          }),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(), // Separador visual entre el formulario y la lista
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _itemsCollection.orderBy('name').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Algo salió mal'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay items disponibles'));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    // Validación simple para asegurar que los datos existen
                    if (data.isEmpty) return const SizedBox.shrink();

                    final item = Item.fromJson(data);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _editingItemId == item.id
                            ? Colors.orange.shade200
                            : null,
                        child: Text(item.name.isNotEmpty
                            ? item.name[0].toUpperCase()
                            : '?'),
                      ),
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editItem(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () => _deleteItem(item.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
