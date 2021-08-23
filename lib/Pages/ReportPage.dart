import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:racing_manager/Components/CustomDialog.dart';
import 'package:racing_manager/Components/CustomTextFiled.dart';
import 'package:racing_manager/Components/MainButton.dart';
import 'package:racing_manager/Models/ReportModel.dart';
import 'package:racing_manager/Pages/MainPage.dart';
import 'package:racing_manager/Resources/Constants.dart';
import 'package:racing_manager/Resources/Strings.dart';

enum ReportType {
  OTHER,
  PASS_CONTROL,
  ENTER_IN_GATE_FROM_WRONG_PATH,
  NOT_FASTEN_SEAT_BELT,
  STOP_IN_MARSHAL_RANGE_VIEW,
  REVERSE_GEAR,
  DANGEROUS_MOVEMENT,
  TURN_IN_CONTROL_AREA,
}

class ReportPage extends StatelessWidget {
  final TextEditingController competitorController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final List<DropdownMenuItem<ReportType>> typeDropDownItems = [
    DropdownMenuItem(
        value: ReportType.PASS_CONTROL, child: Text(strPassControl)),
    DropdownMenuItem(
        value: ReportType.ENTER_IN_GATE_FROM_WRONG_PATH,
        child: Text(strEnterInGateFromWrongPath)),
    DropdownMenuItem(
        value: ReportType.NOT_FASTEN_SEAT_BELT,
        child: Text(strNotFastenSeatBelt)),
    DropdownMenuItem(
        value: ReportType.STOP_IN_MARSHAL_RANGE_VIEW,
        child: Text(strStopInMarshalRangeView)),
    DropdownMenuItem(
        value: ReportType.REVERSE_GEAR, child: Text(strReverseGear)),
    DropdownMenuItem(
        value: ReportType.DANGEROUS_MOVEMENT,
        child: Text(strDangerousMovement)),
    DropdownMenuItem(
        value: ReportType.TURN_IN_CONTROL_AREA,
        child: Text(strTurnInControlArea)),
    DropdownMenuItem(value: ReportType.OTHER, child: Text(strOther)),
  ];
  ReportType? selectedReportType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(strCreateReport)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            CustomTextField(
                inputType: TextInputType.number,
                prefixIcon: Icons.account_box_outlined,
                controller: competitorController,
                label: strCompetitorNumber),
            SizedBox(height: 15),
            CustomTextField(
                expand: true,
                prefixIcon: Icons.description_outlined,
                inputType: TextInputType.multiline,
                controller: descController,
                label: strDescription),
            SizedBox(height: 15),
            DropdownButtonFormField<ReportType>(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))),
                onChanged: (reportType) => selectedReportType = reportType!,
                hint: Text(strSelectReportType),
                items: typeDropDownItems),
            SizedBox(height: 30),
            MainButton(
                text: strAddReport,
                callBack: () async {
                  if (competitorController.text.isNotEmpty &&
                      descController.text.isNotEmpty &&
                      selectedReportType != null) {
                    await Hive.openBox<ReportModel>(REPORT_BOX);
                    await Hive.box<ReportModel>(REPORT_BOX).add(ReportModel(
                        competitorNumber: int.parse(competitorController.text),
                        descriptions: descController.text,
                        type: selectedReportType.toString(),
                        time: DateTime.now().toString()));
                    await showDialog(
                      context: context,
                      builder: (ctx) =>
                          CustomDialog(message: strReportAddedSuccessfully),
                    );
                    Navigator.pop(context);
                  } else {
                    await showDialog(
                      context: context,
                      builder: (ctx) => CustomDialog(
                          message: strFirstEnterValues,
                          messageColor: Colors.red),
                    );
                  }
                }),
          ],
        )),
      ),
    );
  }
}