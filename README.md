# opencv_object_tracking

This is just a simple app to showcase the opencv integration along with the object tracking.

To build the frame follow the steps:

1. Clone opencv repo and checkout the version that you required.

    git clone https://github.com/opencv/opencv.git
    git checkout VERSION

2. Clone opencv repo and checkout the version same as opencv.

    git clone https://github.com/opencv/opencv_contrib.git
    git checkout VERSION

3. Now hit below command to build the framework

    python3 opencv/platforms/ios/build_framework.py ios --contrib opencv_contrib --iphoneos_archs arm64 --iphonesimulator_archs x86_64

    Specify the archs that you want to run  

Now, framework is ready to integrate. Follow the steps below for add framework and make app runnable.

1. Add a video file into the project that you want to apply object tracking.

2. Replace the video name in ViewController.swift at below line of 

    self.url = Bundle.main.url(forResource: "video", withExtension: "mp4") // replace your file name with video

3. Run your app and hit start button on the screen.
