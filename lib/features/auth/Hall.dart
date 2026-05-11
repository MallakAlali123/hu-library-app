import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

class HallScreen extends StatefulWidget {
  const HallScreen({super.key});

  @override
  State<HallScreen> createState() => _HallScreenState();
}

class _HallScreenState extends State<HallScreen> {
  // قائمة بأسماء الصور (Fallback في حال لم توجد صور في Firebase)
  final List<String> _roomImages = [
    'assets/images/room1.jpg',
    'assets/images/room2.jpg',
    'assets/images/room3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/student'),
        ),
        title: Text(
          'Reserve a Space'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          // زر البحث (يمكن تفعيله لاحقاً)
          IconButton(
            icon: Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {},
          ),
          // ✅ إضافة زر "My Bookings" للوصول السريع
          IconButton(
            icon: Icon(Icons.event_note_outlined, color: Theme.of(context).colorScheme.onSurface),
            tooltip: 'My Bookings',
            onPressed: () {
              context.go('/bookings');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tabs ─────────────────────────────────────────
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFCC3333), width: 2)),
                  ),
                  child: Text(
                    'All Rooms'.tr(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFCC3333)),
                  ),
                ),
              ],
            ),
          ),

          // ── Room List من Firebase ──────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('halls').snapshots(),
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFCC3333)));
                }

                // Error
                if (snapshot.hasError) {
                  debugPrint("Firebase Error: ${snapshot.error}");
                  return Center(child: Text('Error loading data'.tr()));
                }

                // No Data
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.meeting_room_outlined, size: 64, color: Color(0xFFCC3333)),
                        const SizedBox(height: 16),
                        Text('No halls available'.tr()),
                        const SizedBox(height: 8),
                        Text('(Check collection name in Firebase)', style: TextStyle(fontSize: 10, color: Colors.red)),
                      ],
                    ),
                  );
                }

                // Success
                final halls = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: halls.length,
                  itemBuilder: (context, index) {
                    final data = halls[index].data() as Map<String, dynamic>;
                    
                    // التعامل مع حالة الغرفة (Available vs Reserved)
                    final isAvailable = (data['status']?.toString().toLowerCase() ?? 'available') == 'available';

                    return _RoomCard(
                      room: _RoomItem(
                        id: halls[index].id, // تمرير الـ ID
                        name: data['name'] ?? 'Unknown Room',
                        capacity: data['capacity']?.toString() ?? '0',
                        floor: data['floor'] ?? 'Unknown Floor',
                        status: isAvailable ? 'AVAILABLE' : 'RESERVED',
                        imageAsset: _roomImages[index % _roomImages.length],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/student');
          if (index == 2) context.go('/bookings'); // ✅ تفعيل زر BOOKINGS في الأسفل
          if (index == 3) context.go('/profile');
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: const Color(0xFFCC3333),
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.meeting_room_outlined), label: 'ROOMS'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_rounded), label: 'BOOKINGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'PROFILE'),
        ],
      ),
    );
  }
}

// --- Room Card Widget ---
class _RoomCard extends StatelessWidget {
  final _RoomItem room;

  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  room.imageAsset,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 150,
                    color: const Color(0xFF8B2222),
                    child: const Icon(Icons.meeting_room_outlined, size: 60, color: Colors.white),
                  ),
                ),
              ),
              if (room.status.isNotEmpty)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: room.status == 'AVAILABLE' ? const Color(0xFF2E7D32) : const Color(0xFFCC3333),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      room.status,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.people_outline_rounded, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text('Capacity: ${room.capacity}', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(room.floor, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: room.status == 'RESERVED'
                        ? null
                        : () => context.go('/book-room', extra: room.name), // ✅ تمرير اسم الغرفة
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC3333),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: Text(
                      room.status == 'RESERVED' ? 'Reserved'.tr() : 'Book Room'.tr(),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Data Model ---
class _RoomItem {
  final String id; // أضفنا ID
  final String name;
  final String capacity;
  final String floor;
  final String status;
  final String imageAsset;

  const _RoomItem({
    required this.id,
    required this.name,
    required this.capacity,
    required this.floor,
    required this.status,
    required this.imageAsset,
  });
}