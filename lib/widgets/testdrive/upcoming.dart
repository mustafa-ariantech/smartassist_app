import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smartassist/config/component/color/colors.dart';
import 'package:smartassist/config/component/font/font.dart';
import 'package:smartassist/pages/Leads/single_details_pages/singleLead_followup.dart';
import 'package:smartassist/pages/home/single_details_pages/singleLead_followup.dart';
import 'package:http/http.dart' as http;
import 'package:smartassist/services/api_srv.dart';
import 'package:smartassist/utils/storage.dart';
import 'package:smartassist/widgets/home_btn.dart/edit_dashboardpopup.dart/testdrive.dart';
import 'package:smartassist/widgets/testdrive_verifyotp.dart';

class TestUpcoming extends StatefulWidget {
  final List<dynamic> upcomingTestDrive;
  final bool isNested;
  final Function(String, bool)? onFavoriteToggle;
  const TestUpcoming({
    super.key,
    required this.upcomingTestDrive,
    required this.isNested,
    this.onFavoriteToggle,
  });

  @override
  State<TestUpcoming> createState() => _TestUpcomingState();
}

class _TestUpcomingState extends State<TestUpcoming> {
  List<dynamic> upcomingTestDrives = [];
  final Map<String, double> _swipeOffsets = {};
  @override
  void initState() {
    super.initState();
    upcomingTestDrives = widget.upcomingTestDrive;
    print('this is testdrive');
    print(widget.upcomingTestDrive);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, String eventId) {
    setState(() {
      _swipeOffsets[eventId] =
          (_swipeOffsets[eventId] ?? 0) + (details.primaryDelta ?? 0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, dynamic item, int index) {
    String eventId = item['event_id'];

    double swipeOffset = _swipeOffsets[eventId] ?? 0;

    if (swipeOffset > 100) {
      // Right Swipe (Favorite)
      _toggleFavorite(eventId, index);
    } else if (swipeOffset < -100) {
      // Left Swipe (Call)
      _handleTestDrive(item);
    }

    // Reset animation
    setState(() {
      _swipeOffsets[eventId] = 0.0;
    });
  }

  void _handleTestDrive(dynamic item) {
    String email = item['updated_by'] ?? '';
    String mobile = item['mobile'] ?? '';
    String eventId = item['event_id'] ?? '';
    String leadId = item['lead_id'] ?? '';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestdriveVerifyotp(
          email: email,
          mobile: mobile,
          leadId: leadId,
          eventId: eventId,
        ),
      ),
    );
    print("Call action triggered for ${item['name']}");
  }

  Future<void> _toggleFavorite(String eventId, int index) async {
    bool currentStatus = widget.upcomingTestDrive[index]['favourite'] ?? false;
    bool newFavoriteStatus = !currentStatus;

    final success = await LeadsSrv.favoriteEvent(eventId: eventId);

    if (success) {
      setState(() {
        widget.upcomingTestDrive[index]['favourite'] = newFavoriteStatus;
      });

      if (widget.onFavoriteToggle != null) {
        widget.onFavoriteToggle!(eventId, newFavoriteStatus);
      }
    }
  }

  // Future<void> _toggleFavorite(String eventId, int index) async {
  //   final token = await Storage.getToken();
  //   try {
  //     // Get the current favorite status before toggling
  //     bool currentStatus =
  //         widget.upcomingTestDrive[index]['favourite'] ?? false;
  //     bool newFavoriteStatus = !currentStatus;

  //     final response = await http.put(
  //       Uri.parse(
  //         'https://api.smartassistapp.in/api/favourites/mark-fav/event/$eventId',
  //       ),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //       // No need to send in body since taskId is already in the URL
  //     );

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         widget.upcomingTestDrive[index]['favourite'] = newFavoriteStatus;
  //       });

  //       // Notify the parent if the callback is provided
  //       if (widget.onFavoriteToggle != null) {
  //         widget.onFavoriteToggle!(eventId, newFavoriteStatus);
  //       }
  //     } else {
  //       print('Failed to toggle favorite: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error toggling favorite: $e');
  //   }
  // }

  Future<void> _getOtp(String eventId) async {
    final success = await LeadsSrv.getOtp(eventId: eventId);

    if (success) {
      print('✅ Test drive started successfully');
    } else {
      print('❌ Failed to start test drive');
    }

    if (mounted) setState(() {});
  }

  // Future<void> _getOtp(
  //   String eventId,
  // ) async {
  //   try {
  //     final url = Uri.parse(
  //         'https://api.smartassistapp.in/api/events/$eventId/send-consent');
  //     final token = await Storage.getToken();

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     print('Starting test drive for event: ${eventId}');
  //     print('this is the get orp api hit');
  //     print(response.statusCode);

  //     if (response.statusCode == 200) {
  //       print('Test drive started successfully');
  //     } else {}
  //   } catch (e) {
  //     print('Error starting test drive: $e');
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.upcomingTestDrive.isEmpty) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'No upcoming TestDrive available',
            style: AppFont.smallText12(context),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: widget.isNested
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      itemCount: widget.upcomingTestDrive.length,
      itemBuilder: (context, index) {
        var item = widget.upcomingTestDrive[index];

        if (!(item.containsKey('assigned_to') &&
            item.containsKey('start_date') &&
            item.containsKey('lead_id') &&
            item.containsKey('event_id'))) {
          return ListTile(title: Text('Invalid data at index $index'));
        }

        String eventId = item['event_id'];
        double swipeOffset = _swipeOffsets[eventId] ?? 0;

        return GestureDetector(
          onHorizontalDragUpdate: (details) =>
              _onHorizontalDragUpdate(details, eventId),
          onHorizontalDragEnd: (details) =>
              _onHorizontalDragEnd(details, item, index),
          child: upcomingTestDrivesItem(
            key: ValueKey(item['event_id']),
            name: item['name'],
            vehicle: item['PMI'] ?? 'Range Rover Velar',
            subject: item['subject'] ?? 'Meeting',
            date: item['start_date'],
            email: item['updated_by'],
            leadId: item['lead_id'],
            startTime: item['start_time'],
            eventId: item['event_id'],
            isFavorite: item['favourite'] ?? false,
            swipeOffset: swipeOffset,
            onToggleFavorite: () {
              _toggleFavorite(eventId, index);
            },
            otpTrigger: () {
              _getOtp(eventId);
            },
            fetchDashboardData: () {},
            handleTestDrive: () {
              _handleTestDrive(item);
            },

            // Placeholder, replace with actual method
          ),
        );
      },
    );
  }
}

class upcomingTestDrivesItem extends StatefulWidget {
  final String name, date, vehicle, subject, leadId, eventId, startTime, email;
  final bool isFavorite;
  final VoidCallback fetchDashboardData;
  final double swipeOffset;
  final VoidCallback onToggleFavorite;
  final VoidCallback handleTestDrive;
  final dynamic item;
  final VoidCallback otpTrigger;
  const upcomingTestDrivesItem({
    super.key,
    required this.name,
    required this.date,
    required this.vehicle,
    required this.leadId,
    required this.isFavorite,
    required this.fetchDashboardData,
    required this.eventId,
    required this.startTime,
    required this.subject,
    required this.swipeOffset,
    required this.email,
    required this.onToggleFavorite,
    required this.handleTestDrive,
    this.item,
    required this.otpTrigger,
  });

  @override
  State<upcomingTestDrivesItem> createState() => _upcomingTestDrivesItemState();
}

class _upcomingTestDrivesItemState extends State<upcomingTestDrivesItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: _buildFollowupCard(context), // ✅ Pass context here
    );
  }

  Widget _buildFollowupCard(BuildContext context) {
    bool isFavoriteSwipe = widget.swipeOffset > 50;
    bool isCallSwipe = widget.swipeOffset < -50;
    // // Gradient background for swipe
    // LinearGradient _buildSwipeGradient() {
    //   if (isFavoriteSwipe) {
    //     return const LinearGradient(
    //       colors: [
    //         Color.fromRGBO(239, 206, 29, 0.67),
    //         Color.fromRGBO(239, 206, 29, 0.67)
    //       ],
    //       begin: Alignment.centerLeft,
    //       end: Alignment.centerRight,
    //     );
    //   } else if (isCallSwipe) {
    //     return LinearGradient(
    //       colors: [Colors.blue.withOpacity(0.2), Colors.blue.withOpacity(0.2)],
    //       begin: Alignment.centerRight,
    //       end: Alignment.centerLeft,
    //     );
    //   }
    //   return const LinearGradient(
    //     colors: [AppColors.containerBg, AppColors.containerBg],
    //     begin: Alignment.centerLeft,
    //     end: Alignment.centerRight,
    //   );
    // }

    return Slidable(
      key: ValueKey(widget.leadId), // Always good to set keys
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          ReusableSlidableAction(
            onPressed: widget.onToggleFavorite, // handle fav toggle
            backgroundColor: Colors.amber,
            icon: widget.isFavorite
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            foregroundColor: Colors.white,
          ),
        ],
      ),

      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          if (widget.subject == 'Test Drive')
            ReusableSlidableAction(
              onPressed: () {
                widget.handleTestDrive();
                widget.otpTrigger();
              },
              backgroundColor: Colors.blue,
              icon: Icons.directions_car,
              foregroundColor: Colors.white,
            ),
          if (widget.subject == 'Send SMS')
            ReusableSlidableAction(
              onPressed: _messageAction,
              backgroundColor: Colors.blueGrey,
              icon: Icons.message_rounded,
              foregroundColor: Colors.white,
            ),
          // Edit is always shown
          ReusableSlidableAction(
            onPressed: _mailAction,
            backgroundColor: const Color.fromARGB(255, 231, 225, 225),
            icon: Icons.edit,
            foregroundColor: Colors.white,
          ),
        ],
      ),

      child: Stack(
        children: [
          // Favorite Swipe Overlay
          if (isFavoriteSwipe)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellow.withOpacity(0.2),
                      Colors.yellow.withOpacity(0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 15),
                      Icon(
                        widget.isFavorite
                            ? Icons.star_outline_rounded
                            : Icons.star_rounded,
                        color: const Color.fromRGBO(226, 195, 34, 1),
                        size: 40,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.isFavorite ? 'Unfavorite' : 'Favorite',
                        style: GoogleFonts.poppins(
                          color: Color.fromRGBO(187, 158, 0, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Call Swipe Overlay
          if (isCallSwipe)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.colorsBlue, AppColors.colorsBlue],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Start Test Drive',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            ),

          // Main Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.containerBg,
              // gradient: _buildSwipeGradient(),
              borderRadius: BorderRadius.circular(5),
              border: Border(
                left: BorderSide(
                  width: 8.0,
                  color: widget.isFavorite
                      ? (isCallSwipe
                            ? Colors.blue.withOpacity(
                                0.2,
                              ) // Green when swiping for a call
                            : Colors.yellow.withOpacity(
                                isFavoriteSwipe ? 0.1 : 0.9,
                              )) // Keep yellow when favorite
                      : (isFavoriteSwipe
                            ? Colors.yellow.withOpacity(0.1)
                            : (isCallSwipe
                                  ? Colors.blue.withOpacity(0.2)
                                  : AppColors.sideGreen)),
                ),
              ),
            ),
            child: Opacity(
              opacity: (isFavoriteSwipe || isCallSwipe) ? 0 : 1.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildUserDetails(context),
                              _buildVerticalDivider(15),
                              _buildCarModel(context),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildSubjectDetails(context),
                              _date(context),
                              _time(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  _buildNavigationButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _messageAction() {
    print("Message action triggered");
  }

  void _mailAction() {
    print("Mail action triggered");

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Testdrive(onFormSubmit: () {}, eventId: widget.eventId),
        );
      },
    );
  }

  Widget _buildUserDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.name, style: AppFont.dashboardName(context)),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildSubjectDetails(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.directions_car, color: Colors.blue, size: 18),
        const SizedBox(width: 5),
        Text('${widget.subject},', style: AppFont.smallText(context)),
      ],
    );
  }

  Widget _time() {
    DateTime parsedTime = DateFormat("HH:mm:ss").parse(widget.startTime);
    String formattedTime = DateFormat("ha").format(parsedTime);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 4),
        Text(
          formattedTime,
          style: GoogleFonts.poppins(
            color: AppColors.fontColor,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _date(BuildContext context) {
    String formattedDate = '';
    try {
      DateTime parseDate = DateTime.parse(widget.date);
      // formattedDate = DateFormat('dd MMM').format(parseDate);
      // Check if the date is today
      if (parseDate.year == DateTime.now().year &&
          parseDate.month == DateTime.now().month &&
          parseDate.day == DateTime.now().day) {
        formattedDate = 'Today';
      } else {
        // If not today, format it as "26th March"
        int day = parseDate.day;
        String suffix = _getDaySuffix(day);
        String month = DateFormat('MMM').format(parseDate); // Full month name
        formattedDate = '${day}$suffix $month';
      }
    } catch (e) {
      formattedDate = widget.date;
    }
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(formattedDate, style: AppFont.smallText(context)),
      ],
    );
  }

  // Helper method to get the suffix for the day (e.g., "st", "nd", "rd", "th")
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Widget _buildVerticalDivider(double height) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: height,
      width: 0.1,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.fontColor)),
      ),
    );
  }

  Widget _buildCarModel(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 100,
      ), // Adjust width as needed
      child: Text(
        widget.vehicle,
        style: AppFont.dashboardCarName(context),
        overflow: TextOverflow.visible, // Allow text wrapping
        softWrap: true, // Enable wrapping
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context) {
    // ✅ Accept context
    return GestureDetector(
      onTap: () {
        if (widget.leadId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FollowupsDetails(
                leadId: widget.leadId,
                isFromFreshlead: false,
              ),
            ),
          );
        } else {
          print("Invalid leadId");
        }
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.arrowContainerColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReusableSlidableAction extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData icon;
  final Color? foregroundColor;
  final double iconSize;

  const ReusableSlidableAction({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    this.foregroundColor,
    this.iconSize = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return SlidableAction(
    //   onPressed: (context) => onPressed(),
    //   backgroundColor: backgroundColor,
    //   foregroundColor: foregroundColor ?? Colors.white,
    //   icon: icon,
    //   borderRadius: BorderRadius.circular(8),
    // );
    return CustomSlidableAction(
      onPressed: (context) => onPressed(),
      backgroundColor: backgroundColor,
      child: Icon(icon, size: iconSize, color: foregroundColor ?? Colors.white),
    );
  }
}
