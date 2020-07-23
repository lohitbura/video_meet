import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "Lohit_Bura_Custom_Room");
  final subjectText = TextEditingController(text: "Test Video Chat");
  final nameText = TextEditingController(text: "Lohit Bura");
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80");//transparent blue
  var isAudioOnly = true;
  var isAudioMuted = false;
  var isVideoMuted = false;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Video Meet', style: TextStyle(color: Colors.white),),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24.0,
                ),
                Card(
                  elevation: 10   ,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: TextFormField(
                          controller: serverText,
                          decoration: InputDecoration(
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              labelText: "Server Url",
                            hintText: "Leave Blank for Jitsi server"
                          ),

                        ),
                        trailing: Icon(Icons.settings_input_antenna, color: Colors.grey,),
                      ),
                      ListTile(
                        title: TextFormField(
                          controller: roomText,
                          decoration: InputDecoration(
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              labelText: "Room",
                            hintText: "Room-LohitBura@123"
                          ),

                        ),
                        trailing: Icon(Icons.room, color: Colors.grey,),
                      ),
                      ListTile(
                        title: TextFormField(
                          controller: subjectText,
                          decoration: InputDecoration(
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              labelText: "Subject"
                          ),

                        ),
                        trailing: Icon(Icons.subject, color: Colors.grey,),
                      ),
                      ListTile(
                        title: TextFormField(
                          controller: nameText,
                          decoration: InputDecoration(
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              labelText: "Display Name"
                          ),

                        ),
                        trailing: Icon(Icons.person, color: Colors.grey,),
                      ),
                      ListTile(
                        title: TextFormField(
                          controller: emailText,
                          decoration: InputDecoration(
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              labelText: "Email Address"
                          ),

                        ),
                        trailing: Icon(Icons.email, color: Colors.grey,),
                      ),
                      ListTile(
                        title: TextFormField(
                          controller: iosAppBarRGBAColor,
                          decoration: InputDecoration(
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              labelText: "AppBar Color(IOS only)",
                              hintText: "Hint: This HAS to be in HEX RGBA format",
                          ),

                        ),
                        trailing: Icon(Icons.email, color: Colors.grey,),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Audio Only"),
                  value: isAudioOnly,
                  onChanged: _onAudioOnlyChanged,
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Audio Muted"),
                  value: isAudioMuted,
                  onChanged: _onAudioMutedChanged,
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  title: Text("Video Muted"),
                  value: isVideoMuted,
                  onChanged: _onVideoMutedChanged,
                ),
                Divider(
                  height: 48.0,
                  thickness: 2.0,
                ),
                SizedBox(
                  height: 64.0,
                  width: double.maxFinite,
                  child: RaisedButton(
                    onPressed: () {
                      _joinMeeting();
                    },
                    child: Text(
                      "Start Meet",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
    serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {

      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags =
      {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED : false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid)
      {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      }
      else if (Platform.isIOS)
      {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint> customContraints =
  {
    RoomNameConstraintType.MAX_LENGTH : new RoomNameConstraint(
            (value) { return value.trim().length <= 50; },
        "Maximum room name length should be 30."),

    RoomNameConstraintType.FORBIDDEN_CHARS : new RoomNameConstraint(
            (value) { return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false).hasMatch(value) == false; },
        "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}