// ignore_for_file: must_be_immutable

library flutter_camera;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';

class FlutterCamera extends StatefulWidget {
  // final List<CameraDescription>? cameras;
  final Color? color;
  final Color? iconColor;
  Function(XFile)? onImageCaptured;
  Function(XFile)? onVideoRecorded;
  final Duration? animationDuration;

  FlutterCamera(
      {Key? key,
      this.onImageCaptured,
      this.animationDuration = const Duration(seconds: 1),
      this.onVideoRecorded,
      this.iconColor = Colors.white,
      required this.color})
      : super(key: key);

  @override
  _FlutterCameraState createState() => _FlutterCameraState();
}

class _FlutterCameraState extends State<FlutterCamera> {
  List<CameraDescription>? cameras;

  CameraController? controller;
  CountDownController countDownController = CountDownController();

  bool? willPopScope;
  int? endTime;
  bool? onLPressed;

  @override
  void initState() {
    initCamera().then((_) {
      setCamera(0);
    });
    willPopScope = true;
    onLPressed = false;
    super.initState();
  }

  Future initCamera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  void setCamera(int index) {
    controller = CameraController(cameras![index], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  bool _isTouchOn = false;
  bool _isFrontCamera = false;
  bool endRecording = false;

  ///Switch
  bool _cameraView = true;

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container(color: PrimaryColor);
    }
  //  var eventState = Provider.of<EventState>(context, listen: false);
    !endRecording
        ? setState(() {
          willPopScope = true;
        })
        : setState(() {
          willPopScope = false;
        });
    return Scaffold(
      backgroundColor: PrimaryColor,
      bottomNavigationBar:
      ///Bottom Controls
      !endRecording
        ? Container(
        height: 200,
          width: 200,
          child: Opacity(
            opacity: 1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                NeonCircularTimer(
                  width: 130,
                  duration: 15,
                  controller : countDownController,
                  isTimerTextShown: false,
                  neumorphicEffect: false,
                  innerFillGradient: LinearGradient(colors: [
                    PinkColor,
                    PinkColor
                  ]),
                  autoStart: false,
                  onComplete: () {
                    ///Stop video recording
                    controller!.stopVideoRecording().then((value) async {
                      await Future.delayed(const Duration(seconds: 1));
                      //  Navigator.pop(context); //todo go to add event
                      widget.onVideoRecorded!(value);
                    });
                    setState(() {_isRecording = false; endRecording = true;});
                    setState(() {});
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {onLPressed = true;});
                    countDownController.start();
                    ///Start
                    controller!.startVideoRecording();
                    setState(() {_isRecording = true;});
                    print('@@ conp');
                    print(countDownController.getTimeInSeconds());
                  },
                  onLongPressEnd: (o) {
                    print('@@@BN');
                    countDownController.pause();
                    print('@@@BN2');
                    ///Stop video recording
                    controller!.stopVideoRecording().then((value) async {
                      await Future.delayed(const Duration(seconds: 1));
                      //  Navigator.pop(context); //todo go to add event
                      widget.onVideoRecorded!(value);
                    });
                    setState(() {_isRecording = false; endRecording = true;});
                    setState(() {});
                  },
                child: Icon(
                  Icons.fiber_manual_record,
                  color: YellowColor,
                  size: 120,
                ),
              ),
              ]
            ),
          )
        )
        : SizedBox(),


        body: !endRecording ? videoView()
        : WillPopScope(
        onWillPop: () async => willPopScope!,
        child: SingleChildScrollView(
       //   physics: const NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: PrimaryColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Loading(),
                  SizedBox(height: 10,),
              //    Text('${eventState.progessUpload}', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10,),
                  Text('Patientez s\'il vous plait', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10,),
                  Text('Envoie de la vidéo en cours', style: TextStyle(color: Colors.white)),

                  SizedBox(height: 150,),

                  TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(PrimaryColor400)
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Anuller', style: TextStyle(color: Colors.white),))
                ],
              ),
            ),
          ),
        )
    )
    );
  }

  void captureImage() {
    controller!.takePicture().then((value) {
      Navigator.pop(context);
      widget.onImageCaptured!(value);
    });
  }

  void setVideo() {
    controller!.startVideoRecording();
  }

  ///Camera View Layout
  Widget cameraView() {
    return Stack(
      key: const ValueKey(0),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CameraPreview(
            controller!,
          ),
        ),

        ///Side controlls
        Positioned(
            top: 40,
            right: 0,
            child: Column(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: widget.iconColor,
                      size: 30,
                    )),
                cameraSwitcherWidget(),
                flashToggleWidget()
              ],
            )),

        ///Bottom Controls
        Positioned(
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    captureImage();
                  },
                  icon: Icon(
                    Icons.camera,
                    color: widget.iconColor,
                    size: 50,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _cameraView = false;
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                    child: CircleAvatar(
                      backgroundColor: widget.color,
                      child: const Icon(Icons.video_call),
                      radius: 13,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  bool _isRecording = false;
  bool _isPaused = false;

  double _width = 300;
  double _height = 300;
  Color _color = Colors.white;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(10);

  ///Video View
  Widget videoView() {
    final scale = 1 / (controller!.value.aspectRatio * MediaQuery.of(context).size.aspectRatio);
    return Column(
      children: [
        Stack(
          key: const ValueKey(1),
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: CameraPreview(
                controller!,
              ),
            ),

            ///Side controlls
            Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 40),
                  width: MediaQuery.of(context).size.width,
                  color: widget.color,
                  height: 100,
                  child: Row(
                    children: [
                      ///Front Camera toggle
                      cameraSwitcherWidget(),

 /*
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: _isRecording == true
                            ? Text(
                            countDownController.getTimeInSeconds().toString(),
                            style: const TextStyle(color: PinkColor, fontWeight: FontWeight.normal, fontSize: 30),
                          )
                              : SizedBox()
                        ),
                      ),
*/
                      ///Flash toggle
                      flashToggleWidget()
                    ],
                  ),
                )),


          ],
        ),

      ],
    );
  }

  Widget flashToggleWidget() {
    return IconButton(
      onPressed: () {
        if (_isTouchOn == false) {
          controller!.setFlashMode(FlashMode.torch);
          _isTouchOn = true;
        } else {
          controller!.setFlashMode(FlashMode.off);
          _isTouchOn = false;
        }
        setState(() {});
      },
      icon: Icon(_isTouchOn == false ? Icons.flash_on : Icons.flash_off,
       //   color: widget.iconColor, size: 30),
          color: YellowColor, size: 30),
    );
  }

  Widget cameraSwitcherWidget() {
    return IconButton(
      onPressed: () {
        if (_isFrontCamera == false) {
          setCamera(1);
          _isFrontCamera = true;
        } else {
          setCamera(0);
          _isFrontCamera = false;
        }
        setState(() {});
      },
      icon: Icon(Icons.cameraswitch, color: YellowColor, size: 30),
    );
  }

}
