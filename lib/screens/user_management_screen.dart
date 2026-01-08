import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil semua user ketika screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F0),
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8BBD0),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
          child: Text(
            'Error: ${provider.error}',
            style: const TextStyle(color: Colors.red),
          ))
          : provider.users.isEmpty
          ? const Center(
          child: Text(
            'No users found',
            style: TextStyle(color: Colors.grey),
          ))
          : RefreshIndicator(
        onRefresh: provider.fetchUsers,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.users.length,
          itemBuilder: (context, index) {
            final user = provider.users[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFF48FB1),
                  child: Text(
                    user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(user.name),
                subtitle: Text('${user.email} - ${user.role}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon:
                      const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          _showUserDialog(context, user: user),
                    ),
                    IconButton(
                      icon:
                      const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _deleteUser(context, user.id),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF48FB1),
        onPressed: () => _showUserDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // =====================
  // Tambah / Edit User
  // =====================
  void _showUserDialog(BuildContext context, {User? user}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: user?.name ?? '');
    final _emailController = TextEditingController(text: user?.email ?? '');
    final roles = ['customer', 'seller', 'admin'];

    String _role = (user != null && roles.contains(user.role))
        ? user.role
        : 'customer';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: const Color(0xFFFDE8F0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(user == null ? 'Add User' : 'Edit User'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Enter email' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _role,
                  items: roles
                      .map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(r),
                  ))
                      .toList(),
                  onChanged: (v) => setStateDialog(() => _role = v!),
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48FB1)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final provider = context.read<UserProvider>();
                  final newUser = User(
                      id: user?.id ?? 0,
                      name: _nameController.text,
                      email: _emailController.text,
                      role: _role);

                  bool success;
                  if (user == null) {
                    success = await provider.addUser(newUser);
                  } else {
                    success = await provider.updateUser(newUser);
                  }

                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.error ?? 'Failed')));
                  }
                }
              },
              child: Text(user == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  // =====================
  // Hapus User
  // =====================
  void _deleteUser(BuildContext context, int id) async {
    final provider = context.read<UserProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await provider.deleteUser(id);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.error ?? 'Failed to delete')));
      }
    }
  }
}
