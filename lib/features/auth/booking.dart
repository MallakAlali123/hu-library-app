import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../services/booking_service.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final BookingService _bookingService = BookingService();

  Future<List<BookingModel>>? _bookingsFuture;

  final Set<String> _cancellingIds = {};

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    setState(() {
      _bookingsFuture = _bookingService.getUserBookings();
    });
  }

  Future<void> _cancelBooking(String bookingId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Booking?'.tr()),
        content: Text(
          'Are you sure you want to cancel this booking?'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Yes'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _cancellingIds.add(bookingId);
    });

    final result =
        await _bookingService.cancelBooking(bookingId);

    if (!mounted) return;

    setState(() {
      _cancellingIds.remove(bookingId);
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking cancelled successfully'.tr(),
          ),
          backgroundColor: Colors.green,
        ),
      );

      _loadBookings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Confirmed':
        return 'Confirmed'.tr();

      case 'Pending':
        return 'Pending'.tr();

      case 'Cancelled':
        return 'Cancelled'.tr();

      default:
        return status;
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Confirmed':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;

      case 'Pending':
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFEF6C00);
        break;

      case 'Cancelled':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        break;

      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const primaryColor = Color(0xFFCC3333);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => context.go('/student'),
        ),

        title: Text(
          'My Bookings'.tr(),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Color(0xFFCC3333),
            ),
            onPressed: _loadBookings,
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          _loadBookings();
        },

        child: FutureBuilder<List<BookingModel>>(
          future: _bookingsFuture,

          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade200,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Error loading bookings'.tr(),
                    ),
                  ],
                ),
              );
            }

            final bookings = snapshot.data ?? [];

            if (bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: theme.colorScheme.onSurface
                          .withOpacity(0.3),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'No bookings found'.tr(),
                      style: TextStyle(
                        color: theme
                            .colorScheme.onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),

              itemCount: bookings.length,

              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16),

              itemBuilder: (context, index) {
                final booking = bookings[index];

                final isCancelling =
                    _cancellingIds.contains(booking.id);

                return _buildBookingCard(
                  booking,
                  theme,
                  primaryColor,
                  isCancelling,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    BookingModel booking,
    ThemeData theme,
    Color primaryColor,
    bool isCancelling,
  ) {
    String initial = booking.roomName.isNotEmpty
        ? booking.roomName[0].toUpperCase()
        : '?';

    bool canCancel = booking.status == 'Pending';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 100,
            height: 110,

            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),

              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),

            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color:
                      primaryColor.withOpacity(0.8),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      Expanded(
                        child: Text(
                          booking.roomName,

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                            color: theme
                                .colorScheme
                                .onSurface,
                          ),

                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),

                      _buildStatusBadge(
                        booking.status,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: theme
                            .colorScheme.onSurface
                            .withOpacity(0.6),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        booking.date,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: theme
                            .colorScheme.onSurface
                            .withOpacity(0.6),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        booking.time,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (canCancel)
            Padding(
              padding:
                  const EdgeInsets.only(right: 12),

              child: isCancelling
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Color.fromARGB(255, 212, 14, 14),
                      ),

                      onPressed: () =>
                          _cancelBooking(
                        booking.id,
                      ),

                      tooltip:
                          'Cancel Booking'.tr(),
                    ),
            ),
        ],
      ),
    );
  }
}