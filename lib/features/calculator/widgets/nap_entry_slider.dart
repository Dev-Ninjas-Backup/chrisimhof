// import 'package:chrisimhof/core/common/widgets/custom_button.dart';
// import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
// import 'package:flutter/material.dart';
// import 'package:chrisimhof/core/const/app_colors.dart';
// import 'package:chrisimhof/core/const/global_text_style.dart';

// class NapEntryCard extends StatelessWidget {
//   final String napTitle; 
//   final TextEditingController durationController;
//   final VoidCallback onAddNap;

//   const NapEntryCard({
//     super.key,
//     required this.napTitle,
//     required this.durationController,
//     required this.onAddNap,
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
//           Text(
//             napTitle,
//             style: getTextStyle(
//               color: AppColors.primaryTextColor,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 24),
//           CustomTextFormField(
//             label: "Desired Nap Duration (min)",
//             hintText: "Enter Duration",
//             isRequired: true,
//             controller: durationController,
//             keyboardType: TextInputType.number,
//           ),
//           const SizedBox(height: 32),
          
//           CustomButton(
//             text: "+ Add Nap",
//             onTap: onAddNap,
//             width: double.infinity,
//           ),
//         ],
//       ),
//     );
//   }
// }


