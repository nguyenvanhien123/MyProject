import 'package:flutter/material.dart';
import 'package:myapp/utils/universal_variables.dart';
import 'package:myapp/views/callscreens/pickup/pickup_layout.dart';
import 'package:myapp/views/log_Screen/widgets/floating_column.dart';

import 'widgets/log_list_container.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
