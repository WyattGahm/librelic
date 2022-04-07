#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "RainbowRoad.h"
#import <MobileCoreServices/UTCoreTypes.h>


typedef void(^URLHandler)(NSURL * url);

@interface ShadowImportUtil : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
-(void)pickMediaWithImageHandler:(void (^)(NSURL *))iHandle videoHandler:(void (^)(NSURL *))vHandle;
@property (strong,nonatomic) URLHandler imageHandler;
@property (strong,nonatomic) URLHandler videoHandler;
@end

@implementation ShadowImportUtil
{
    UIImagePickerController *_picker;
    UIViewController *_vc;
}

-(void)pickMediaWithImageHandler:(void (^)(NSURL *))iHandle videoHandler:(void (^)(NSURL *))vHandle{
    self.imageHandler = iHandle;
    self.videoHandler = vHandle;
    _picker = [[UIImagePickerController alloc] init];
    _picker.videoExportPreset = AVAssetExportPresetPassthrough;
    _picker.delegate = self;
    //_picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    _vc = topVC;
    
    [_vc presentViewController:_picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
    NSLog(@"REACHED CRITICAL POINT 0");
    [_vc dismissViewControllerAnimated:YES completion:nil];
    if([info[UIImagePickerControllerMediaType] isEqualToString: @"public.movie"]){
        self.videoHandler(info[UIImagePickerControllerMediaURL]);
    }else{
        self.imageHandler(info[UIImagePickerControllerImageURL]);
    }
   
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_vc dismissViewControllerAnimated:YES completion:nil];
    self.videoHandler(nil);
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    //_image = info[UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}
 */
@end

