import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'invite_people_screen.dart';
import 'create_activity_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  
  List<Map<String, dynamic>> members = [];

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _removeMember(int index) {
    setState(() {
      members.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Create Group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('GROUP NAME', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _groupNameController,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF0B2B6A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('MEMBERS (${members.length})', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const InvitePeopleScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.person_add_alt_1, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text('Invite', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: members.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B2B6A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(member['initial'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 16),
                          Text(member['name'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _removeMember(index),
                            child: const Icon(Icons.close, color: Colors.white70, size: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Get.to(() => const CreateActivityScreen());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Activity', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2B6A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.person_remove),
                      label: const Text('Remove Members', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), 
            ],
          ),
        ),
      ),
    );
  }
}
