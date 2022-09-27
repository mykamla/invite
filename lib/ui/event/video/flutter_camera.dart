// ignore_for_file: must_be_immutable

library flutter_camera;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/theme/my_theme.dart';

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

  @override
  void initState() {
    super.initState();
    initCamera().then((_) {
      setCamera(0);
    });
  }

  Future initCamera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  void setCamera(int index) {
    controller = CameraController(cameras![index], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  bool _isTouchOn = false;
  bool _isFrontCamera = false;

  ///Switch
  bool _cameraView = true;

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(body: videoView());
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
    return Column(
      children: [
        Stack(
          key: const ValueKey(1),
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height,
              //  width: MediaQuery.of(context).size.width,
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
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            _isRecording == false
                                ? ''
                                : 'Enregistrement...',
                            style: TextStyle(
                                color: widget.iconColor, fontSize: 22),
                          ),
                        ),
                      ),

                      ///Flash toggle
                      flashToggleWidget()
                    ],
                  ),
                )),
          ],
        ),
        ///Bottom Controls
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {

                    ///Start
                    controller!.startVideoRecording();
                    setState(() {_isRecording = true;});

                    await Future.delayed(const Duration(seconds: 15));

                    ///Stop video recording
                    controller!.stopVideoRecording().then((value) async {
                      await Future.delayed(const Duration(seconds: 1));
                    //  Navigator.pop(context); //todo go to add event
                      widget.onVideoRecorded!(value);
                    });
                    setState(() {_isRecording = false;});


                  /*
                  //Start and stop video
                  if (_isRecording == false) {
                    ///Start
                    controller!.startVideoRecording();
                    _isRecording = true;

                  } else {
                    ///Stop video recording
                    controller!.stopVideoRecording().then((value) async {
                      await Future.delayed(const Duration(seconds: 15));
                      Navigator.pop(context); //todo go to add event
                      widget.onVideoRecorded!(value);
                    });
                    _isRecording = false;
                  }
                  */
                  setState(() {});
                },
                icon: Icon(
                  Icons.camera,
                  color: PrimaryColor,
                  size: 50,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              IconButton(
                onPressed: () {
                  //pause and resume video
                  if (_isRecording == true) {
                    //pause
                    if (_isPaused == true) {
                      ///resume
                      controller!.resumeVideoRecording();
                      _isPaused = false;
                    } else {
                      ///resume
                      controller!.pauseVideoRecording();
                      _isPaused = true;
                    }
                  }
                  setState(() {});
                },
                icon: Icon(
                  _isPaused == false
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: PrimaryColor300,
                  size: 30,
                ),
              ),
            ],
          ),
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
          color: widget.iconColor, size: 30),
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
      icon:
          Icon(Icons.change_circle_outlined, color: widget.iconColor, size: 30),
    );
  }
}
