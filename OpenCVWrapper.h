//
//  OpenCVWrapper.h
//  openCvApp
//
//  Created by Apple on 31/07/24.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef struct {
//    CGRect boundingBox;
//    bool status;
//} TrackerResult;

@interface OpenCVWrapper : NSObject

+ (NSString *)openCVVersionString;

- (void) createTracker;

- (bool) initTracker: (CVPixelBufferRef) pixelBuffer : (CGRect)boundingBox;

- (NSArray *) updateTracker: (CVPixelBufferRef) pixelBuffer : (CGRect)boundingBox;



@end


NS_ASSUME_NONNULL_END
