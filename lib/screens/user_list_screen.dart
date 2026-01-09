// screens/user_list_screen.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService _userService = UserService();
  late Future<List<User>> _users;

  // ✅ Warna aksi yang seragam
  final Color actionColor = const Color(0xFFF48FB1);

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _users = _userService.getUsers();
  }

  Future<void> _refreshUsers() async {
    setState(_loadUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F0),
      body: FutureBuilder<List<User>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No users found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final users = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshUsers,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 6.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    leading: CircleAvatar(
                      backgroundColor: actionColor,
                      foregroundColor: Colors.white,
                      radius: 22,
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${user.email} • ${user.role}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: actionColor,
                          onPressed: () => _showUserDialog(user: user),
                          tooltip: 'Edit User',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: actionColor,
                          onPressed: () => _confirmDelete(user),
                          tooltip: 'Delete User',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Add New User',
        backgroundColor: actionColor,
      ),
    );
  }

  // ==========================
  // Tambah / Edit User
  // ==========================
  void _showUserDialog({User? user}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: user?.name ?? '');
    final _emailController = TextEditingController(text: user?.email ?? '');
    String _role = user?.role ?? 'customer';

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
                  items: ['customer', 'seller', 'admin']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                backgroundColor: actionColor,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    if (user == null) {
                      await _userService.createUser(
                        User(
                          id: 0,
                          name: _nameController.text,
                          email: _emailController.text,
                          role: _role,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('User added successfully')),
                      );
                    } else {
                      await _userService.updateUser(
                        user.id,
                        User(
                          id: user.id,
                          name: _nameController.text,
                          email: _emailController.text,
                          role: _role,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('User updated successfully')),
                      );
                    }
                    Navigator.pop(context);
                    _refreshUsers();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed: $e')),
                    );
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

  // ==========================
  // Konfirmasi & Hapus User
  // ==========================
  void _confirmDelete(User user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete User'),
          ],
        ),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: actionColor),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _userService.deleteUser(user.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${user.name} deleted successfully')),
        );
        _refreshUsers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete ${user.name}: $e')),
        );
      }
    }
  }
}
