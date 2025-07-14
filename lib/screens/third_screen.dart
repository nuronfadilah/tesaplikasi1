import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<User> users = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && !isLoading && hasMore) {
        fetchUsers();
      }
    });
  }

 Future<void> fetchUsers({bool refresh = false}) async {
  if (refresh) {
    setState(() {
      users.clear();
      currentPage = 1;
      hasMore = true;
    });
  }

  setState(() => isLoading = true);

  try {
    final response = await http.get(
      Uri.parse('https://reqres.in/api/users?page=$currentPage'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> newUsers = data['data'];

      if (newUsers.isEmpty) {
        setState(() => hasMore = false);
      } else {
        setState(() {
          users.addAll(newUsers.map((e) => User.fromJson(e)).toList());
          currentPage++;
        });
      }
    } else {
      debugPrint('❌ Gagal memuat data. Status code: ${response.statusCode}');
      debugPrint('Body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: ${response.statusCode}')),
      );
    }
  } catch (e) {
    debugPrint('❌ Error saat fetch: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terjadi kesalahan saat memuat data')),
    );
  }

  setState(() => isLoading = false);
}




  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Thrid Screen',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
  onRefresh: () => fetchUsers(refresh: true),
  child: users.isEmpty && !isLoading
      ? const Center(child: Text('No users found'))
      : ListView.builder(
          controller: _scrollController,
          itemCount: users.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < users.length) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                ),
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .setSelectedUser('${user.firstName} ${user.lastName}');
                  Navigator.pop(context);
                },
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
),

    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
