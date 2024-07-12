// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
//
// class CreateTask extends StatefulWidget {
//   const CreateTask({super.key});
//
//   @override
//   CreateTaskState createState() => CreateTaskState();
// }
//
// /// State for MyApp
// class CreateTaskState extends State<CreateTask> {
//   String _selectedDate = '';
//   String _dateCount = '';
//   String _range = '';
//   String _rangeCount = '';
//
//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       if (args.value is PickerDateRange) {
//         _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
//         // ignore: lines_longer_than_80_chars
//             ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
//       } else if (args.value is DateTime) {
//         _selectedDate = args.value.toString();
//       } else if (args.value is List<DateTime>) {
//         _dateCount = args.value.length.toString();
//       } else {
//         _rangeCount = args.value.length.toString();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Edit Task',
//       home: SpecialForm(
//       ),
//     );
//   }
// }
//
// Widget SpecialForm() {
//   var _onSelectionChanged;
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Color(0xff45C4B0),
//       automaticallyImplyLeading: true,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back),
//         onPressed: () => Navigator.pop(context, false),
//       ),
//       title: const Text('Create Task'),
//     ),
//     body: Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: DropdownButton<DateRangePickerView>(
//             value: DateRangePickerView.decade,
//             onChanged: (value) {
//
//             },
//             items: const[
//               DropdownMenuItem<DateRangePickerView>(
//                 value: DateRangePickerView.decade,
//                 child: Text("Decade"),
//               ),
//               DropdownMenuItem<DateRangePickerView>(
//                 value: DateRangePickerView.month,
//                 child: Text("month"),
//               ),
//               DropdownMenuItem<DateRangePickerView>(
//                 value: DateRangePickerView.year,
//                 child: Text("year"),
//               ),
//
//             ],
//           ),
//         ),
//         SfDateRangePicker(
//           onSelectionChanged: _onSelectionChanged,
//           selectionMode: DateRangePickerSelectionMode.range,
//           initialSelectedRange: PickerDateRange(
//               DateTime.now().subtract(const Duration(days: 4)),
//               DateTime.now().add(const Duration(days: 3))),
//         ),
//       ],
//     ),
//   );;
// }
//
