// import 'package:flutter/material.dart';
// import 'package:smartassist/pages/Leads/single_details_pages/singleLead_followup.dart';
// import 'package:smartassist/pages/home/single_details_pages/singleLead_followup.dart';

// class OppFollUps extends StatefulWidget {
//   const OppFollUps({super.key});

//   @override
//   State<OppFollUps> createState() => _OppFollUpsState();
// }

// class _OppFollUpsState extends State<OppFollUps> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: SizedBox(
//         height: 80,
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(
//                 255, 245, 244, 244), // Background color for the content
//             borderRadius: BorderRadius.circular(10), // Optional rounded corners
//             border: const Border(
//               left: BorderSide(
//                 width: 8.0, // Left border width
//                 color: Color.fromARGB(255, 81, 223, 121), // Left border color
//               ),
//             ),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Image.asset('assets/star.png'),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       const Text(
//                         'Tira Smith',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                             color: Color.fromARGB(255, 139, 138, 138)),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Image.asset('assets/vector.png'),
//                       )
//                     ],
//                   ),
//                   const Padding(padding: EdgeInsets.only(bottom: 5)),
//                   Row(
//                     children: [
//                       // Icon(
//                       //   Icons.phone,
//                       //   color: Colors.grey,
//                       // ),
//                       // Image.asset('assets/phone.png'),
//                       const Padding(padding: EdgeInsets.only(right: 5)),
//                       const Text('Today 3pm',
//                           style: TextStyle(
//                               fontWeight: FontWeight.normal,
//                               fontSize: 12,
//                               color: Colors.grey)),
//                     ],
//                   ),
//                 ],
//               ),
//               const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Discovery Sport',
//                     style: TextStyle(
//                         color: Colors.grey, fontWeight: FontWeight.w500),
//                   ),
//                   Padding(padding: EdgeInsets.only(bottom: 5)),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.calendar_month_outlined,
//                         color: Colors.grey,
//                       ),
//                       Text(
//                         'Tomorrow',
//                         style: TextStyle(
//                             color: Colors.grey, fontWeight: FontWeight.w400),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const FollowupsDetails(leadId: '',)));
//                     },
//                     child: Image.asset('assets/arrowButton.png'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
