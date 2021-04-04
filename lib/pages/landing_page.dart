import 'dart:math';
import 'dart:ui';

import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/theme_config.dart';
import 'package:feelm/widgets/feelm_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:provider/provider.dart';
import 'package:feelm/models/sign.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  double left = 0;
  int? random;
  CustomAnimationControl _animationControl = CustomAnimationControl.PLAY;
  @override
  void initState() {
    // To randomize the background image
    random = Random().nextInt(10);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var words = Provider.of<List<Keyword>>(context);
    var signs = Provider.of<List<ZodiacSign>>(context);
    signs.sort((a, b) =>
        a.from.millisecondsSinceEpoch.compareTo(b.from.millisecondsSinceEpoch));
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // He
          MirrorAnimation<double>(
            tween: 0.0.tweenTo(-350.0),
            duration: 55.seconds,
            builder: (context, child, value) => Positioned.fill(
              bottom: 0,
              top: 0,
              left: value,
              child: Image.asset(
                'assets/collage$random.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // A smooth color layer at top of the background image
          Positioned.fill(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
            ),
          ),
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SfDateRangePicker(
                    confirmText: 'Are u sure?',
                    backgroundColor: Colors.white.withOpacity(0.6),
                    showActionButtons: true,
                    minDate: signs[0].from,
                    maxDate: signs.last.to,
                    selectionTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      cellDecoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmit: (value) {
                      var birthDate = value as DateTime;
                      kLog.wtf(birthDate);

                      kLog.wtf(signs
                          .where(
                            (sign) {
                              //This check is only for capricorn since the year changes
                              return birthDate.isBetween(sign.from, sign.to);
                            },
                          )
                          .first
                          .name);
                    },
                    view: DateRangePickerView.decade,
                    selectionMode: DateRangePickerSelectionMode.single,
                    headerHeight: 40,
                    headerStyle: const DateRangePickerHeaderStyle(
                      backgroundColor: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                    onSelectionChanged: (value) {
                      // kLog.wtf(value.value);
                    },
                  ),
                  CustomAnimation<double>(
                      tween: 0.0.tweenTo(400.0),
                      duration: 900.milliseconds,
                      curve: Curves.easeInOut,
                      builder: (context, child, value2) {
                        return CustomAnimation<double>(
                          tween: 0.0.tweenTo(200.0),
                          control: _animationControl,
                          duration: 500.milliseconds,
                          curve: Curves.easeInOut,
                          builder: (context, child, value) {
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: cielLight.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                      ),
                                      width: value * 1.1,
                                      height: value,
                                      child: AnimatedOpacity(
                                        opacity: value == 200 ? 1 : 0,
                                        duration: 2.seconds,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: FeelmTextField(
                                                  context: context,
                                                  label: 'Username',
                                                ),
                                              ),
                                              Flexible(
                                                child: FeelmTextField(
                                                  context: context,
                                                  label: 'Password',
                                                ),
                                              ),
                                              Flexible(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    kLog.wtf(
                                                        'Total keywords ${words.length}');
                                                    kLog.wtf(
                                                        'Total Zodiac Signs ${signs[1].keywords.length}');

                                                    // await signInWithFacebook();
                                                    // var x = await getKeywords('interview');
                                                    // var keywordIds = List.generate(
                                                    //   x.keywords.length,
                                                    //   (index) => x.keywords[index].id.toString(),
                                                    // );

                                                    // kLog.wtf(
                                                    //   List.generate(x.keywords.length,
                                                    //       (index) => x.keywords[index].name),
                                                    // );

                                                    // // var stringKeywords = keywordIds.join(',');
                                                    // // kLog.wtf(stringKeywords);
                                                    // var z = await discoverMovies(keywordIds.last);
                                                    // kLog.wtf(
                                                    //   List.generate(
                                                    //       z.length, (index) => z[index].title),
                                                    // );
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.facebook,
                                                    size: 30,
                                                    color: Color(0xff2E89FF),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(
                                      () {
                                        _animationControl ==
                                                CustomAnimationControl.PLAY
                                            ? _animationControl =
                                                CustomAnimationControl
                                                    .PLAY_REVERSE
                                            : _animationControl =
                                                CustomAnimationControl.PLAY;
                                      },
                                    );

                                    //await signInWithFacebook();
                                    //var x = await getKeywords('interview');
                                    // var keywordIds = List.generate(
                                    //   x.keywords.length,
                                    //   (index) => x.keywords[index].id.toString(),
                                    // );

                                    // kLog.wtf(
                                    //   List.generate(x.keywords.length,
                                    //       (index) => x.keywords[index].name),
                                    // );

                                    // // var stringKeywords = keywordIds.join(',');
                                    // // kLog.wtf(stringKeywords);
                                    // var z = await discoverMovies(keywordIds.last);
                                    // kLog.wtf(
                                    //   List.generate(
                                    //       z.length, (index) => z[index].title),
                                    // );
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.userCircle,
                                    size: 50,
                                    color: Color(0xff2E89FF),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
