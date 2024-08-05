//
//  OpenCVWrapper.m
//  openCvApp
//
//  Created by Apple on 31/07/24.
//

//#import <opencv2/opencv.hpp>
//#include <opencv2/tracking.hpp>
//#include <opencv2/tracking/tracker.hpp>

#import "OpenCVWrapper.h"


@interface OpenCVWrapper()

@property (nonatomic) cv::Ptr<cv::Tracker> mTracker;
//@property (nonatomic) std::list<T> mTrackerList;

@end

@implementation OpenCVWrapper

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

- (void) createTracker{
    _mTracker = cv::TrackerMedianFlow::create();
//    _mTrackerList.append()
}


-(bool) initTracker: (CVPixelBufferRef) pixelBuffer : (CGRect)boundingBox {
    
    cv::Mat imageMat = pixelBufferToMat(pixelBuffer);
//    cv::Mat imageMat;
//    UIImageToMat(frame, imageMat);
////
//    cv::Mat grayFrame;
//    cv::cvtColor(imageMat, grayFrame, cv::COLOR_BGRA2BGR);
    
    cv::Rect2d rect2d(boundingBox.origin.x, boundingBox.origin.y, boundingBox.size.width, boundingBox.size.height);
    
    return _mTracker->init(imageMat, rect2d);
}

-(NSArray *) updateTracker: (CVPixelBufferRef) pixelBuffer : (CGRect)boundingBox {
    
    cv::Mat imageMat = pixelBufferToMat(pixelBuffer);
//    cv::Mat imageMat;// = pixelBufferToMat(pixelBuffer);
//    UIImageToMat(frame, imageMat);
    cv::Rect2d rect2d(0, 0, 1, 1);
    
//    cv::Mat grayFrame;
//    cv::cvtColor(imageMat, grayFrame, cv::COLOR_BGRA2BGR);
    
    bool status = _mTracker->update(imageMat, rect2d);
    boundingBox = CGRectMake(rect2d.x, rect2d.y, rect2d.width, rect2d.height);
    
    return @[@(status), @(boundingBox)];
}


cv::Mat pixelBufferToMat(CVPixelBufferRef pixelBuffer) {
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    // Get information about the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    
    // Create a cv::Mat from the pixel buffer data
    cv::Mat mat(height, width, CV_8UC4, baseAddress, bytesPerRow);
    
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
//     Convert BGRA to BGR (if needed)
    cv::Mat bgrMat;
    cv::cvtColor(mat, bgrMat, cv::COLOR_BGRA2GRAY);
    
    return bgrMat;
}



@end
