#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "RainbowRoad.h"
#import <MobileCoreServices/UTCoreTypes.h>


typedef void(^URLHandler)(NSURL * url);

@interface ShadowImportUtil : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
-(void)pickMediaWithImageHandler:(void (^)(NSURL *))iHandle videoHandler:(void (^)(NSURL *))vHandle;
@property (strong,nonatomic) NSURL *media;
@property (strong,nonatomic) URLHandler imageHandler;
@property (strong,nonatomic) URLHandler videoHandler;
@end

@implementation ShadowImportUtil 
{
    UIViewController *vc;
}

-(void)pickMediaWithImageHandler:(void (^)(NSURL *))iHandle videoHandler:(void (^)(NSURL *))vHandle{
    self.imageHandler = iHandle;
    self.videoHandler = vHandle;
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"Import" message:@"Pick an import method" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"https://";
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }];
    /*
    UIAlertAction *paste=[UIAlertAction actionWithTitle:@"Paste (Broken)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //importedPhoto = [UIPasteboard generalPasteboard].image;
    }];
     */
    UIAlertAction *select=[UIAlertAction actionWithTitle:@"Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
        vc = [self topVC];
        [vc presentViewController:picker animated:YES completion:nil]; 
    }];
    UIAlertAction *url=[UIAlertAction actionWithTitle:@"URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //NSString *urlText = alertVC.textFields[0].text;
        //self.media = [NSURL URLWithString:urlText];
        [self mediaHandler:[NSURL URLWithString:alertVC.textFields[0].text] alt:[NSURL URLWithString:alertVC.textFields[0].text]];
    }];
    
    UIAlertAction *none=[UIAlertAction actionWithTitle:@"Nothing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //do(nothing)
    }];
     
    [alertVC addAction:select];
    //[alertVC addAction:paste];
    [alertVC addAction:url];
    [alertVC addAction:none];
    [[self topVC] presentViewController:alertVC animated:true completion:nil];
}
-(void)mediaHandler:(NSURL *)media alt:(NSURL *)media2{
    if ([@[@"png",@"jpg",@"gif",@"tiff"] containsObject:[media pathExtension]]) {
        self.imageHandler(media2);
    }else{
        self.videoHandler(media);
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    /*
    //https://stackoverflow.com/a/10531752
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {//[mediaType isEqualToString:(__bridge NSString *)kUTTypeMovie]
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        [self mediaHandler:videoUrl];
    }else{
        [self mediaHandler:info[UIImagePickerControllerOriginalImage]];
    }
    
    
    
    
    importedPhoto = info[UIImagePickerControllerOriginalImage];
     */
    [self mediaHandler:info[UIImagePickerControllerMediaURL] alt:info[UIImagePickerControllerOriginalImage]];
    [vc dismissViewControllerAnimated:YES completion:nil];
     
}
-(UIViewController * )topVC{
    UIViewController *ret = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (ret.presentedViewController) ret = ret.presentedViewController;
    return ret;
}
@end
