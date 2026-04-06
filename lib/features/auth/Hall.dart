import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HallScreen extends StatefulWidget {
  const HallScreen({super.key});

  @override
  State<HallScreen> createState() => _HallScreenState();
}

class _HallScreenState extends State<HallScreen> {
  String _selectedCapacity = 'Capacity: 1-4';
  String _selectedFloor = 'Floor 2';
  String _selectedAvailability = 'Available Now';

  final List<_RoomItem> _rooms = const [
    _RoomItem(
      name: 'AAAAAAA',
      capacity: 'Up to 2 people',
      floor: 'Floor 2',
      status: 'AVAILABLE',
      imageAsset: 'assets/images/room1.jpg',
    ),
    _RoomItem(
      name: 'BBBBBBB',
      capacity: 'Up to 8 people',
      floor: 'Floor 1',
      status: 'RESERVED',
      imageAsset: 'assets/images/room2.jpg',
    ),
    _RoomItem(
      name: 'CCCCCCC',
      capacity: 'Up to 12 people',
      floor: 'Floor 3',
      status: '',
      imageAsset: 'assets/images/room3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFCC3333)),
          onPressed: () => context.go('/student'),
        ),
        title: const Text(
          'Reserve a Space',
          style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Color(0xFF1A1A1A)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFCC3333), width: 2),
                    ),
                  ),
                  child: const Text(
                    'All Rooms',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFCC3333)),
                  ),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: _selectedCapacity, onTap: () {}),
                  const SizedBox(width: 8),
                  _FilterChip(label: _selectedFloor, onTap: () {}),
                  const SizedBox(width: 8),
                  _FilterChip(label: _selectedAvailability, onTap: () {}),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                return _RoomCard(room: _rooms[index]);
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/student');
          if (index == 3) context.go('/profile');
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFCC3333),
        unselectedItemColor: const Color(0xFFAAAAAA),
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.meeting_room_outlined), label: 'ROOMS'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_rounded), label: 'BOOKINGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'PROFILE'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF444444))),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF888888)),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final _RoomItem room;

  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
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
                Text(room.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.people_outline_rounded, size: 14, color: Color(0xFF888888)),
                    const SizedBox(width: 4),
                    Text('Capacity: ${room.capacity}', style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF888888)),
                    const SizedBox(width: 4),
                    Text(room.floor, style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => context.go('/book-room'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC3333),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Book Room', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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

class _RoomItem {
  final String name;
  final String capacity;
  final String floor;
  final String status;
  final String imageAsset;

  const _RoomItem({
    required this.name,
    required this.capacity,
    required this.floor,
    required this.status,
    required this.imageAsset,
  });
}