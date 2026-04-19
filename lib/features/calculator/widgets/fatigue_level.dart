// import 'package:chrisimhof/core/const/app_colors.dart';
// import 'package:chrisimhof/core/const/global_text_style.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class FatigueLevel extends StatelessWidget {
//   final String headerText;
//   final RxString selectedOption;
//   final List<String> options;
//   final Function(String) onSelect;

//   const FatigueLevel({
//     super.key,
//     required this.headerText,
//     required this.selectedOption,
//     required this.options,
//     required this.onSelect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24.0),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           RichText(
//             text: TextSpan(
//               text: headerText,
//               style: getTextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//               children: const [
//                 TextSpan(
//                   text: ' *',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
          
//           // Buttons Flow (Horizontal)
//           Obx(
//             () => Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: options.map((option) {
//                 final bool isSelected = option == selectedOption.value;
                
//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: () => onSelect(option),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12.0, 
//                         horizontal: 16.0,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isSelected 
//                             ? AppColors.primaryButtonColor 
//                             : const Color(0xFFF1F3F5),
//                         borderRadius: BorderRadius.circular(10000.0),
//                       ),
//                       child: Text(
//                         option,
//                         textAlign: TextAlign.center,
//                         style: getTextStyle(
//                           fontSize: 14,
//                           fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                           color: const Color(0xFF1A1F26),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }