import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/request_service.dart';

class BookRoom1Screen extends StatefulWidget {
  const BookRoom1Screen({super.key});

  @override
  State<BookRoom1Screen> createState() => _BookRoom1ScreenState();
}

class _BookRoom1ScreenState extends State<BookRoom1Screen> {
  DateTime _currentMonth = DateTime(2024, 11);
  int? _selectedDay = 5;
  String? _selectedTime;
  bool _isLoading = false;
  final RequestService _requestService = RequestService();

  final List<String> _timeSlots = [
    '09:00 AM',
    '10:30 AM',
    '12:00 PM',
    '01:30 PM',
    '11:00 PM',
    '09:30 PM',
  ];

  final Set<String> _bookedSlots = {'01:30 PM'};
  final String _currentSlot = '10:30 AM';

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  List<int?> _getDaysInMonth() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;
    final List<int?> days = List.filled(startWeekday, null);
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }
    return days;
  }

  String _monthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  // ── Reserve Now مع Firebase ──────────────────────────────
  void _handleReserve() async {
    if (_selectedDay == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _requestService.submitRequest(
      requestType: 'hall_reservation',
      title: 'Hall Reservation - Room A',
      description: 'Date: ${_monthName(_currentMonth.month)} $_selectedDay, ${_currentMonth.year} | Time: $_selectedTime',
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Reservation submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/student');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.go('/hall'),
          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1A1A)),
        ),
        title: const Text(
          'Reserve Hall',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Color(0xFF1A1A1A)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/hall_room1.jpg',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 160,
                      color: const Color(0xFF8B2222),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _previousMonth,
                        child: const Icon(Icons.chevron_left_rounded, color: Color(0xFF888888)),
                      ),
                      Text(
                        '${_monthName(_currentMonth.month)} ${_currentMonth.year}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                      ),
                      GestureDetector(
                        onTap: _nextMonth,
                        child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF888888)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) {
                      return SizedBox(
                        width: 32,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF888888), fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 8),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: days.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final day = days[index];
                      if (day == null) return const SizedBox();
                      final isSelected = day == _selectedDay;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = day),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFCC3333) : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$day',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Available Time Slots',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _timeSlots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                final time = _timeSlots[index];
                final isBooked = _bookedSlots.contains(time);
                final isCurrent = time == _currentSlot;
                final isSelected = time == _selectedTime;

                Color bgColor = const Color(0xFFFFF0F0);
                Color textColor = const Color(0xFFCC3333);
                Color borderColor = const Color(0xFFFFCCCC);

                if (isBooked) {
                  bgColor = const Color(0xFFF5F5F5);
                  textColor = const Color(0xFFAAAAAA);
                  borderColor = const Color(0xFFE0E0E0);
                } else if (isCurrent || isSelected) {
                  bgColor = const Color(0xFFCC3333);
                  textColor = Colors.white;
                  borderColor = const Color(0xFFCC3333);
                }

                return GestureDetector(
                  onTap: isBooked ? null : () => setState(() => _selectedTime = time),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            decoration: isBooked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        if (isCurrent && !isBooked) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.access_time_rounded, size: 14, color: textColor),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleReserve,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC3333),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.event_available_rounded, size: 20),
                label: _isLoading
                    ? const Text('Submitting...')
                    : const Text('Reserve Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}