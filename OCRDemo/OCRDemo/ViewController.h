//
//  ViewController.h
//  OCRDemo
//
//  Created by jason on 2017/7/9.
//  Copyright © 2017年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TesseractOCR.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "JYLabel.h"

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,G8TesseractDelegate,MFMailComposeViewControllerDelegate>

@end

