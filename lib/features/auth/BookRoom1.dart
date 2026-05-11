import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../services/booking_service.dart'; // تأكد من صحة المسار

class BookRoom1Screen extends StatefulWidget {
  // ✅ 1. تعريف المتغير في الكلاس
  final String roomName;

  // ✅ 2. استقبال المتغير في الـ Constructor
  const BookRoom1Screen({
    super.key, 
    required this.roomName, // هذا السطر سيحل مشكلة الخطأ
  });

  @override
  State<BookRoom1Screen> createState() => _BookRoom1ScreenState();
}

class _BookRoom1ScreenState extends State<BookRoom1Screen> {
  // --- State ---
  DateTime _currentMonth = DateTime.now();
  int? _selectedDay;
  String? _selectedTime;
  bool _isLoading = false;
  
  final BookingService _bookingService = BookingService();

  // --- Configuration ---
  final List<String> _timeSlots = [
    '09:00 AM',
    '10:30 AM',
    '12:00 PM',
    '01:30 PM',
    '03:00 PM',
    '04:30 PM',
  ];

  final Set<String> _bookedSlots = {'01:30 PM'}; 

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().day;
  }

  // --- Calendar Logic ---

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
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    
    int weekdayIndex = firstDayOfMonth.weekday % 7;

    final List<int?> days = [];

    for (int i = 0; i < weekdayIndex; i++) {
      days.add(null);
    }

    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }
    
    return days;
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  // --- Submission Logic ---

  void _handleReserve() async {
    if (_selectedDay == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a date and time'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dateString = '${_monthName(_currentMonth.month)} $_selectedDay, ${_currentMonth.year}';

      // ✅ 3. استخدام اسم الغرفة القادم من الـ Router
      final result = await _bookingService.createBooking(
        roomName: widget.roomName, 
        date: dateString,
        time: _selectedTime!,
      );

      if (!mounted) return;
      
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Reservation submitted successfully!'.tr()),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/bookings'); 
      } else {
        throw Exception(result['message'] ?? 'Unknown error');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = _getDaysInMonth();
    final primaryColor = const Color(0xFFCC3333);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.colorScheme.onSurface),
          onPressed: () => context.go('/hall'),
        ),
        title: Text(
          'Reserve Hall'.tr(),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: theme.colorScheme.onSurface),
            onPressed: () {
              // TODO: Show info dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Image ---
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/hall.png',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor.withOpacity(0.8), primaryColor.withOpacity(0.4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.meeting_room, color: Colors.white70, size: 60),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        // ✅ 4. عرض اسم الغرفة الصحيح
                        widget.roomName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Calendar Section ---
            Text(
              'Select Date'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: Icon(Icons.chevron_left, color: theme.colorScheme.onSurface),
                        splashRadius: 20,
                      ),
                      Text(
                        '${_monthName(_currentMonth.month)} ${_currentMonth.year}',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: theme.colorScheme.onSurface
                        ),
                      ),
                      IconButton(
                        onPressed: _nextMonth,
                        icon: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface),
                        splashRadius: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) {
                      return SizedBox(
                        width: 36,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12, 
                            color: theme.colorScheme.onSurface.withOpacity(0.6), 
                            fontWeight: FontWeight.w600
                          ),
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
                      final isToday = day == DateTime.now().day && 
                                      _currentMonth.month == DateTime.now().month &&
                                      _currentMonth.year == DateTime.now().year;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = day),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.transparent,
                            shape: BoxShape.circle,
                            border: isToday && !isSelected 
                                ? Border.all(color: primaryColor, width: 1.5) 
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '$day',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected 
                                    ? Colors.white 
                                    : theme.colorScheme.onSurface,
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

            // --- Time Slots Section ---
            Text(
              'Available Time Slots'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _timeSlots.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                final time = _timeSlots[index];
                final isBooked = _bookedSlots.contains(time);
                final isSelected = time == _selectedTime;

                Color bgColor;
                Color textColor;
                Color borderColor;

                if (isBooked) {
                  bgColor = theme.colorScheme.surfaceContainerHighest;
                  textColor = theme.colorScheme.onSurface.withOpacity(0.4);
                  borderColor = Colors.transparent;
                } else if (isSelected) {
                  bgColor = primaryColor;
                  textColor = Colors.white;
                  borderColor = primaryColor;
                } else {
                  bgColor = theme.colorScheme.surface;
                  textColor = theme.colorScheme.onSurface;
                  borderColor = theme.colorScheme.outline;
                }

                return GestureDetector(
                  onTap: isBooked ? null : () => setState(() => _selectedTime = time),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              decoration: isBooked ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          if (isBooked)
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Icon(
                                Icons.close, 
                                size: 14, 
                                color: textColor
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // --- Reserve Button ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleReserve,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primaryColor.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24, 
                        height: 24, 
                        child: CircularProgressIndicator(
                          color: Colors.white, 
                          strokeWidth: 2.5
                        )
                      )
                    : Text(
                        'Reserve Now'.tr(),
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}