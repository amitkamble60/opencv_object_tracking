//
//  ViewController.swift
//  openCvApp
//
//  Created by Apple on 27/07/24.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    private var assetReaderTrackOutput: AVAssetReaderTrackOutput!
    private var context = CIContext()
    
    private var cvPixel: CVPixelBuffer!
    
    private var workQueue = DispatchQueue(label: "com.amit.openCvApp", qos: .userInitiated)
    
    
//    private var videoFrame: UIImage!
    private var frameCounter = 0
    
    @IBOutlet weak var btnStart: UIButton!

    @IBOutlet weak var imgFrame: UIImageView!
    
    @IBOutlet weak var overlayViewer: OverlayView!
    
    private var openCVWrapper: OpenCVWrapper!;
    private var trackedObjectList = [TrackedObject]();
    
    private var url: URL!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initViews()
    
        
        print("\(OpenCVWrapper.openCVVersionString())")
        
        openCVWrapper = OpenCVWrapper()
        
        self.url = Bundle.main.url(forResource: "34860_B1", withExtension: "mp4")
        
        if self.url == nil {
            print("File not availbale")
            return
        }
        
    }
    
    func initViews(){
        
//        self.imgFrame = UIImageView(frame:CGRect(x:10, y:50, width:100, height:300));
//        self.view.addSubview(self.imgFrame)
        
//        self.frameViewer = FrameViewerView(frame: CGRect(x: 50, y: 50, width: 1080, height: 1280))
//        view.addSubview(self.frameViewer)
    }
    
    @IBAction func onStartButtonClick(_ sender: UIButton){
        
        if self.url == nil {
            print("File not availbale")
            return
        }
        
        if frameCounter<=1 {
            workQueue.async {
                self.startProcessingVideo(url:self.url)
            }
            return
        }
        
        frameCounter = 0;
        
    }
    
    
    private func startProcessingVideo(url: URL) {
        let asset = AVAsset(url: url)
        let assetReader = try! AVAssetReader(asset: asset)

        guard let videoTrack = asset.tracks(withMediaType: .video).first else { return }
        self.assetReaderTrackOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [kCVPixelBufferPixelFormatTypeKey as String: kCMPixelFormat_32BGRA])
        guard assetReader.canAdd(self.assetReaderTrackOutput) else {
            print("assetReader canAdd false")
            return
        }
        assetReader.add(self.assetReaderTrackOutput)
        assetReader.startReading()

        extractFrames()

    }
    
    func extractFrames(){
        print("extractFrames")
        
        guard let sampleBuffer = self.assetReaderTrackOutput.copyNextSampleBuffer() else {
            print("Failed to copyNextSampleBuffer")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to convert imageBuffer")
//            extractFrames()
            return
        }
        
        frameCounter = frameCounter + 1
        self.cvPixel = frame;
        
        print("frameCounter ", frameCounter)
        
        
//        updateUIWithReults();
        
        if (frameCounter <= 1){
            processDetection()
        } else {
            processTracking()
        }
//
    }
    
    func processTracking(){
        print("processTracking")
        
//        for trackObj in trackedObjectList{
//            trackObj.updateTracker()
//        }
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        let result = openCVWrapper.updateTracker(self.cvPixel, rect)
        
        print("-----Update Tracker------ ")
        print("-Status-", result[0])
        print("-Rect-", result[1] as! CGRect)
        
        trackedObjectList[0].setBoundingBox(rect: result[1] as! CGRect)
        
        updateUIWithReults();
        
    }
    
    func processDetection(){
        print("processDetection")
        
        let rect = CGRect(x: 145, y: 250, width: 100, height: 120)
        
        registerTrackers(box:rect)
        
        
    }
    
    func registerTrackers(box: CGRect){
        print("registerTrackers")
        
        trackedObjectList.append(TrackedObject(id:0, boundingBox: box, score: 0.5, lable:"First"))
        
        openCVWrapper.createTracker()
        
        let status = openCVWrapper.initTracker(self.cvPixel, box)
        
        print("----Init Tracker-----", status)
        
        updateUIWithReults()
        
    }
    
    func updateUIWithReults(){
        print("updateUIWithReults")
        
        guard let uiImage = self.imageFromSampleBuffer() else { return }
        DispatchQueue.main.async {
        
            
            self.imgFrame.image = uiImage
            
            self.overlayViewer.trackedObjectList=self.trackedObjectList
            self.overlayViewer.setNeedsDisplay()
            
        }
        
        self.extractFrames()
        
    }
    
    private func imageFromSampleBuffer() -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: self.cvPixel)
//        ciImage.depthData?.applyingExifOrientation(CGImagePropertyOrientation(rawValue: 6)!)
//        ciImage.oriented(.up)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
        
    }


}

