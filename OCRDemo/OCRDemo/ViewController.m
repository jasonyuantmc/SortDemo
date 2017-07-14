//
//  ViewController.m
//  OCRDemo
//
//  Created by jason on 2017/7/9.
//  Copyright © 2017年 jason. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet JYLabel *showTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property(nonatomic,strong)MFMailComposeViewController * mailVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)orcAction:(UIButton *)sender {
    G8Tesseract * tesseract = [[G8Tesseract alloc]initWithLanguage:@"eng"];
    tesseract.delegate = self;
    //不翻译的
//    tesseract.charWhitelist = @"0123456789";
//    tesseract.image = [self.imageView.image g8_grayScale];
    tesseract.image = [[UIImage imageNamed:@"Lenore"]g8_grayScale];
    
//    tesseract.rect = self;//范围
    
    // Optional: Limit recognition time with a few seconds
    tesseract.maximumRecognitionTime = 2.0;
    
    // Start the recognition
    [tesseract recognize];
    
    // You could retrieve more information about recognized text with that methods:
//    NSArray *characterBoxes = [tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelSymbol];
//
//    NSArray *paragraphs = [tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelParagraph];
//    NSArray *characterChoices = tesseract.characterChoices;
    NSLog(@"%@",tesseract.recognizedText);
    
    self.showTextLabel.text = tesseract.recognizedText;
    
    [self sendMailWithText:tesseract.recognizedText];
   


//    UIImage *imageWithBlocks = [tesseract imageWithBlocks:characterBoxes drawText:YES thresholded:NO];
}

#pragma mark - 邮件形式发送
-(void)sendMailWithText:(NSString *)text
{
    if ([MFMailComposeViewController canSendMail]) {
        _mailVC = [[MFMailComposeViewController alloc]init];
        _mailVC.mailComposeDelegate = self;
        [_mailVC setSubject:@"Title"];
        [_mailVC setMessageBody:text isHTML:NO];
        [self presentViewController:_mailVC animated:NO completion:nil];
    }else{
//        NSString *f8Text = [NSString stringWithCString:[text UTF8String] encoding:NSUTF8StringEncoding];
        NSString *url = [NSString stringWithFormat:@"mailto://foo@example.com&subject=title&body=<b>%@</b>body!",text];
        NSString * mail = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: mail]];
    }
}

#pragma mark - mailComposeDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultFailed:
            
            break;
        case MFMailComposeResultCancelled:
            
            break;
            
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - 点击照片按钮
- (IBAction)selectBtnAction:(UIButton *)sender {
    
    __weak __typeof(&*self)weakSelf = self;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择" message:@"选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf getPhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction * picAction = [UIAlertAction actionWithTitle:@"相册" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf getPhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:photoAction];
    [alert addAction:picAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)getPhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    //开线程 防止卡死
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.sourceType = sourceType;
            imagePickerController.delegate = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            });
        });
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提醒", @"") message:NSLocalizedString(@"手机不支持拍照或不支持从本地获取图片", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{ //NS_DEPRECATED_IOS(2_0, 3_0);
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //原图
    UIImage * orignalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData * data = UIImageJPEGRepresentation(orignalImage, 0.1);
    
    _imageView.image = [UIImage imageWithData:data];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

#pragma g8 delegate
/**
 *  An optional method to be called periodically during recognition so
 *  the recognition's progress can be observed.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 */
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract
{
//    NSLog(@"text%@",tesseract.recognizedText);
     NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}
/**
 *  An optional method to be called periodically during recognition so
 *  the user can choose whether or not to cancel recognition.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 *
 *  @return Whether or not to cancel the recognition in progress.
 */
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract
{
    
    return NO;
}
/**
 *  An optional method to provide image preprocessing. To perform default
 *  Tesseract preprocessing return `nil` in this method.
 *
 *  @param tesseract   The `G8Tesseract` object performing the recognition.
 *  @param sourceImage The source `UIImage` to perform preprocessing.
 *
 *  @return Preprocessed `UIImage` or nil to perform default preprocessing.
 */
//- (UIImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(UIImage *)sourceImage
//{
//    
//}


@end
