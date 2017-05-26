//
//  CameraViewController.m
//  TestCamera
//
//  Created by Elian Medeiros on 26/05/17.
//  Copyright © 2017 Elian Medeiros. All rights reserved.
//

#import "CameraViewController.h"
#import "IPDFCameraViewController.h"

@interface CameraViewController() {
    IBOutlet IPDFCameraViewController *cameraView;
    IBOutlet UIImageView *focusIndicator;
}

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [cameraView setupCameraView];
    [cameraView setEnableBorderDetection:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [cameraView start];
    [cameraView setCameraViewType:IPDFCameraViewTypeBlackAndWhite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark Focus

- (IBAction)focusGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [sender locationInView:cameraView];
        [self focusIndicatorAnimateToPoint:location];
        [cameraView focusAtPoint:location completionHandler:^{
             [self focusIndicatorAnimateToPoint:location];
         }];
    }
}

- (void)focusIndicatorAnimateToPoint:(CGPoint)targetPoint {
    [focusIndicator setCenter:targetPoint];
    focusIndicator.alpha = 0.0;
    focusIndicator.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        focusIndicator.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            focusIndicator.alpha = 0.0;
        }];
    }];
}


#pragma mark Capture

- (IBAction)captureButton:(id)sender {
    __weak typeof(self) weakSelf = self;
    [cameraView captureImageWithCompletionHander:^(NSString *imageFilePath) {
         UIImageView *captureImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imageFilePath]];
         captureImageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
         captureImageView.frame = CGRectOffset(weakSelf.view.bounds, 0, -weakSelf.view.bounds.size.height);
         captureImageView.alpha = 1.0;
         captureImageView.contentMode = UIViewContentModeScaleAspectFit;
         captureImageView.userInteractionEnabled = YES;
         [weakSelf.view addSubview:captureImageView];
         
         UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(dismissPreview:)];
         [captureImageView addGestureRecognizer:dismissTap];
         
         [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.7 options:UIViewAnimationOptionAllowUserInteraction animations:^
          {
              captureImageView.frame = weakSelf.view.bounds;
          } completion:nil];
        
        //Save
        UIImageWriteToSavedPhotosAlbum(captureImageView.image, nil, nil, nil);
     }];
}

- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap {
    [UIView animateWithDuration:0.7
                          delay:0.0 usingSpringWithDamping:0.8
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         dismissTap.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
                     }
                     completion:^(BOOL finished) {
                         [dismissTap.view removeFromSuperview];
                     }];
}

@end
