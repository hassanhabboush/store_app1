// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:no_name_ecommerce/view/utils/responsive.dart';
// import '../utils/constant_colors.dart';

// class BottomNav extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTabTapped;
//   const BottomNav(
//       {Key? key, required this.currentIndex, required this.onTabTapped})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: isIos ? 90 : 70,
//       child: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//         selectedLabelStyle: const TextStyle(fontSize: 12),
//         selectedItemColor: primaryColor,
//         unselectedItemColor: greyFour,
//         onTap: onTabTapped, // new
//         currentIndex: currentIndex, // new
//         items: [
//           BottomNavigationBarItem(
//             icon: Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               child: SvgPicture.asset('assets/svg/home-icon.svg',
//                   color: currentIndex == 0 ? primaryColor : greyFour,
//                   semanticsLabel: 'Acme Logo'),
//             ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               child: SvgPicture.asset('assets/svg/orders-icon.svg',
//                   color: currentIndex == 1 ? primaryColor : greyFour,
//                   semanticsLabel: 'Acme Logo'),
//             ),
//             label: 'Orders',
//           ),
//           BottomNavigationBarItem(
//             icon: Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               child: SvgPicture.asset('assets/svg/saved-icon.svg',
//                   color: currentIndex == 2 ? primaryColor : greyFour,
//                   semanticsLabel: 'Acme Logo'),
//             ),
//             label: 'Saved',
//           ),
//           BottomNavigationBarItem(
//             icon: Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               child: SvgPicture.asset('assets/svg/search-icon.svg',
//                   color: currentIndex == 3 ? primaryColor : greyFour,
//                   semanticsLabel: 'Acme Logo'),
//             ),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               child: SvgPicture.asset('assets/svg/cart.svg',
//                   color: currentIndex == 3 ? primaryColor : greyFour,
//                   semanticsLabel: 'Acme Logo'),
//             ),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               child: SvgPicture.asset('assets/svg/settings-icon.svg',
//                   color: currentIndex == 4 ? primaryColor : greyFour,
//                   semanticsLabel: 'Acme Logo'),
//             ),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
