import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewPageProgressIndicator extends StatelessWidget {
  const NewPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
      child: Center(
        child: SizedBox(
          height: 23,
          width: 23,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
