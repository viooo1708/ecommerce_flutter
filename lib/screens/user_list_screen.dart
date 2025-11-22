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

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _users = _userService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F0), // pink pastel
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8BBD0), // pink pastel
        elevation: 2,
      ),
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
                ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No users found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final users = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFF48FB1),
                    foregroundColor: Colors.white,
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${user.email} - ${user.role}',
                      style:
                      const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await _showAddUserDialog(context);
          if (result == true) _loadUsers();
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New User',
        backgroundColor: const Color(0xFFF48FB1),
      ),
    );
  }

  Future<bool?> _showAddUserDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    String _role = 'customer';

    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFDE8F0), // pink pastel
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
              ),
              DropdownButtonFormField<String>(
                value: _role,
                items: ['customer', 'seller', 'admin']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => _role = v!,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF48FB1), // pink pastel
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _userService.createUser(
                  User(
                    id: 0,
                    name: _nameController.text,
                    email: _emailController.text,
                    role: _role,
                  ),
                );
                Navigator.pop(context, true);
              }
            },
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
