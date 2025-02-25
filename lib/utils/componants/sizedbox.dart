import 'package:flutter/material.dart';

/// Width-based SizedBoxes
SizedBox sizedBoxW5(BuildContext context) =>
    SizedBox(width: MediaQuery.of(context).size.width * 0.013); // ~5px
SizedBox sizedBoxW10(BuildContext context) =>
    SizedBox(width: MediaQuery.of(context).size.width * 0.025); // ~10px
SizedBox sizedBoxW15(BuildContext context) =>
    SizedBox(width: MediaQuery.of(context).size.width * 0.038); // ~15px
SizedBox sizedBoxW20(BuildContext context) =>
    SizedBox(width: MediaQuery.of(context).size.width * 0.05); // ~20px
SizedBox sizedBoxW30(BuildContext context) =>
    SizedBox(width: MediaQuery.of(context).size.width * 0.075); // ~30px

/// Height-based SizedBoxes
SizedBox sizedBoxH5(BuildContext context) =>
    SizedBox(height: MediaQuery.of(context).size.height * 0.006); // ~5px
SizedBox sizedBoxH10(BuildContext context) =>
    SizedBox(height: MediaQuery.of(context).size.height * 0.012); // ~10px
SizedBox sizedBoxH15(BuildContext context) =>
    SizedBox(height: MediaQuery.of(context).size.height * 0.018); // ~15px
SizedBox sizedBoxH20(BuildContext context) =>
    SizedBox(height: MediaQuery.of(context).size.height * 0.025); // ~20px
SizedBox sizedBoxH30(BuildContext context) =>
    SizedBox(height: MediaQuery.of(context).size.height * 0.037); // ~30px
