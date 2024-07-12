import 'package:flutter/material.dart';

Widget DatePicker({DateTime? datetime})
{
  datetime ??= DateTime.now(); //selected date is current date if its null
  return TextField(
    onSubmitted: (String value){
      print(value);
    },
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.search),
      suffixIcon: Icon(Icons.clear),
      labelText: 'Filled',
      hintText: 'hint text',
      helperText: 'supporting text',
      filled: true,
    ),
  );
}