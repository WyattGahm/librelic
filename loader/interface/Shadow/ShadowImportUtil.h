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
    [_vc dismissViewControllerAnimated:NO completion:nil];
    if([info[UIImagePickerControllerMediaType] isEqualToString: @"public.movie"]){
        if([ShadowData enabled:@"wraithuploads"]){
            [[NSFileManager defaultManager] copyItemAtPath:info[UIImagePickerControllerMediaURL] toPath:[ShadowData fileWithName:@"upload.mp4"] error:nil];
        }else{
            self.videoHandler(info[UIImagePickerControllerMediaURL]);
        }
    }else{
        self.imageHandler(info[UIImagePickerControllerImageURL]);
    }
}
@end

