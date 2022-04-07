//#define TWELVE


#import <Foundation/Foundation.h>
#include "../relicwrapper.m"
#include "SCNMessagingMessage.h"

#include <stdbool.h>


#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define _Bool bool
#define typeof __typeof__
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wformat-security"
#pragma clang diagnostic ignored "-Wunused-function"


#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Social/SLComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#include <MediaAccessibility/MediaAccessibility.h>
#import <Social/SLServiceTypes.h>
#import "SpringBoard/SpringBoard.h"
#import <CoreLocation/CoreLocation.h>


#import "SCContextV2ActionMenuViewController.h"
#import "SCNMessagingMessage.h"
#import "SIGActionSheetCell.h"
#import "SIGHeaderTitle.h"
#import "SIGHeaderItem.h"
#import "SIGLabel.h"
#import "SCContextV2SwipeUpViewController.h"
#import "SCContextActionMenuOperaDataSource.h"
#import "SCContextV2SwipeUpGestureTracker.h"
#import "SCOperaPageViewController.h"
#import "SCMainCameraViewController.h"
#import "SCContextV2Presenter.h"
#import "SIGAlertDialog.h"
#import "SIGAlertDialogAction.h"
#import "SCNMessagingUUID.h"
#import "SCStatusBarOverlayLabelWindow.h"
#import "SIGPullToRefreshGhostView.h"

#import "util.h"
#import "ShadowData.h"
#import "ShadowSettingsViewController.h"
#import "ShadowImportUtil.h"
#import "RainbowRoad.h"
#import "LocationPicker.h"

#import "XLLogerManager.h"



@interface SCOperaViewController : UIViewController
-(void)_advanceToNextPage:(BOOL)arg1;
@end

//SIGActionSheetCell * saveCell;

@interface ShadowHelper: NSObject
@end

@implementation ShadowHelper
+(void)screenshot{
    [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:UIApplicationUserDidTakeScreenshotNotification object:nil]];
}
+(void)banner:(NSString*)text color:(NSString *)color alpha:(float)alpha{
    if([[ShadowData sharedInstance] enabled_secure: "showbanners"]){
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:color];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&rgbValue];
        UIColor * bannerColor = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
        [%c(SCStatusBarOverlayLabelWindow) showMessageWithText:text backgroundColor:bannerColor];
    }
}
+(void)banner:(NSString*)text color:(NSString *)color{
    if([[ShadowData sharedInstance] enabled_secure: "showbanners"]){
        [self banner:text color:color alpha:.75];
    }
}
+(void)markSnap{
    if([ShadowData sharedInstance].seen == FALSE){
        [ShadowHelper banner:@"Marking as SEEN" color:@"#00FF00"];
        [ShadowData sharedInstance].seen = TRUE;
        if([[ShadowData sharedInstance] enabled_secure: "closeseen"]){
            //[(SCOperaPageViewController *)[ShadowData sharedInstance].currentopera autoAdvanceTimerDidFire];
            [((SCOperaViewController*)((SCOperaPageViewController *)[ShadowData sharedInstance].currentopera).delegate) _advanceToNextPage:YES];
        }
    }else{
        [ShadowHelper banner:@"Marking as UNSEEN" color:@"#00FF00"];
        [ShadowData sharedInstance].seen = FALSE;
    }
}
+(void)debug{
    [[XLLogerManager manager] showOnWindow];
}
+(void)pickLocation{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [[LocationPicker new] pickLocationWithCallback:^(NSDictionary *location){
        NSLog(@"location: %@",location);
        [ShadowData sharedInstance].location = [location mutableCopy];
        SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Warning!" description:@"This will reset all settings to default and close the App. Is that okay?"];
        SIGAlertDialogAction *call = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Reset" actionBlock:^(){
            //[ShadowData resetSettings];
            [alert dismissViewControllerAnimated:YES completion:nil];
            //exit(0);
        }];
        SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert _setActions: @[back,call]];
        [topVC presentViewController: alert animated: true completion:nil];
        
    } from:topVC];
}
+(void)reset{
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Warning!" description:@"This will reset all settings to default and close the App. Is that okay?"];
    SIGAlertDialogAction *call = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Reset" actionBlock:^(){
        [ShadowData resetSettings];
        [alert dismissViewControllerAnimated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            exit(0);
        });
    }];
    SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert _setActions: @[back,call]];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}
@end


static void (*orig_tap)(id self, SEL _cmd, id arg1);
static void tap(id self, SEL _cmd, id arg1){
    ShadowSettingsViewController *vc = [ShadowSettingsViewController new];
    [vc setModalPresentationStyle: UIModalPresentationPageSheet];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    vc.preferredContentSize = CGRectInset(topVC.view.bounds, 20, 20).size;
    [topVC presentViewController: vc animated: true completion:nil];
}

static _Bool (*orig_savehax)(id self, SEL _cmd);
static _Bool savehax(id self, SEL _cmd){
    if([[ShadowData sharedInstance] enabled_secure: "savehax"]){
        if([self messageType] == 18) return true;
    }
    return orig_savehax(self, _cmd);
}

static void (*orig_storyghost)(id self, SEL _cmd, id arg1);
static void storyghost(id self, SEL _cmd, id arg1){
    /*
    NSLog(@"STORY: %@",[self performSelector:@selector(friendStoryViewingSession)]);
    if(![[ShadowData sharedInstance] enabled_secure: "storyghost"])
        orig_storyghost(self, _cmd, arg1);
    */
    if(![[ShadowData sharedInstance] enabled_secure: "storyghost"]) orig_storyghost(self, _cmd, arg1);
    if(![[ShadowData sharedInstance] enabled_secure: "seenbutton"]) return;
    if([ShadowData sharedInstance].seen == TRUE){
        orig_storyghost(self, _cmd, arg1);
        [ShadowData sharedInstance].seen = FALSE;
    }
}

static void (*orig_snapghost)(id self, SEL _cmd, long long arg1, id arg2, long long arg3, void * arg4);
static void snapghost(id self, SEL _cmd, long long arg1, id arg2, long long arg3, void * arg4){
    if(![[ShadowData sharedInstance] enabled_secure: "snapghost"]) orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
    if(![[ShadowData sharedInstance] enabled_secure: "seenbutton"]) return;
    if([ShadowData sharedInstance].seen == TRUE){
        orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
        [ShadowData sharedInstance].seen = FALSE;
    }
}

//no orig, were adding this
static void save(SCOperaPageViewController* self, SEL _cmd) {
    if(![[ShadowData sharedInstance] enabled: @"markfriends"]){
        UIButton *button = [self.view.subviews lastObject];
        if([button class] == %c(UIButton)){
            UIImage *savedIcon = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/saved.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            [button setImage: savedIcon forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
    }
  NSArray *mediaArray = [self shareableMedias];
  if (mediaArray.count == 1) {
    SCOperaShareableMedia *mediaObject = (SCOperaShareableMedia *)[mediaArray firstObject];
    if (mediaObject.mediaType == 0) {
      UIImage *snapImage = [mediaObject image];
      UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
        [ShadowHelper banner:@"Snap saved to camera roll! 👻" color:@"#00FF00"];
      //[%c(SCStatusBarOverlayLabelWindow) showMessageWithText:@"Success! Snap saved to camera roll! 👻" backgroundColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:0.64]];
    } else {
        [ShadowHelper banner:@"Uh oh! Failed to save snap😢" color:@"#FF0000"];
      //[%c(SCStatusBarOverlayLabelWindow) showErrorWithText:@"Uh oh! Failed to save this snap. 😢" backgroundColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    }
  } else {
    for (SCOperaShareableMedia *mediaObject in mediaArray) {
      if ((mediaObject.mediaType == 1) && (mediaObject.videoAsset) && (mediaObject.videoURL == nil)) {
        AVURLAsset *asset = (AVURLAsset *)(mediaObject.videoAsset);
        NSURL *assetURL = asset.URL;
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *tempVideoFileURL = [documentsURL URLByAppendingPathComponent:[assetURL lastPathComponent]];

        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = tempVideoFileURL;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
          UISaveVideoAtPathToSavedPhotosAlbum(tempVideoFileURL.path, nil, nil, nil);
            [ShadowHelper banner:@"Snap saved to camera roll! 👻" color:@"#00FF00"];
          //[%c(SCStatusBarOverlayLabelWindow) showMessageWithText:@"Success! Snap saved to camera roll! 👻" backgroundColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:0.64]];
        }];
      } else if (mediaObject.mediaType == 1 && mediaObject.videoURL && mediaObject.videoAsset == nil) {
        UISaveVideoAtPathToSavedPhotosAlbum(mediaObject.videoURL.path, nil, nil, nil);
          [ShadowHelper banner:@"Snap saved to camera roll! 👻" color:@"#00FF00"];
        //[%c(SCStatusBarOverlayLabelWindow) showMessageWithText:@"Success! Snap saved to camera roll! 👻" backgroundColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:0.64]];
      }
    }
  }
}
/*
static void saveauto(id self,NSString * folder){
    NSLog(@"AUTOSAVING: %@", folder);
    NSArray* mediaArray = [self shareableMedias];
    //the mediaArray has 1 object, meaning most likely it is image
    if (mediaArray.count == 1){
      SCOperaShareableMedia *mediaObject = (SCOperaShareableMedia *)[mediaArray firstObject];
      //double check that the mediaObject is a image mediaType
      if (mediaObject.mediaType == 0){
        UIImage *snapImage = [mediaObject image];
          NSString * mediaId = (NSString *)[[self performSelector:@selector(page)] performSelector:@selector(_id)];
          NSURL *filePath = [[NSURL fileURLWithPath:folder] URLByAppendingPathComponent: [mediaId stringByAppendingString: @".png"]];
          NSLog(@"SAVING IMAGE: %@", filePath.absoluteString);
          [UIImagePNGRepresentation(snapImage) writeToFile:filePath.absoluteString atomically:YES];
        //UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
        //[%c(SCStatusBarOverlayLabelWindow) showMessageWithText:@"Success! Snap saved to camera roll! 👻" backgroundColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:0.64]];
      }
      //add error checking
      else{
        //[%c(SCStatusBarOverlayLabelWindow) showErrorWithText:@"Uh oh! Failed to save this snap. 😢" backgroundColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
      }
    }
    //the mediaArray has more than one object, meaning most likely it is a video
    else{
      //enumerate through the array to check which object contains the video asset
      for (SCOperaShareableMedia *mediaObject in mediaArray){
        //check if mediaObject is video mediaType and it's videoAsset is not null
        if ((mediaObject.mediaType == 1) && (mediaObject.videoAsset) && (mediaObject.videoURL == nil)){
          AVURLAsset *asset = (AVURLAsset *)(mediaObject.videoAsset);
          NSURL *assetURL = asset.URL;
          NSURL *tempVideoFileURL = [[NSURL fileURLWithPath:folder] URLByAppendingPathComponent: [assetURL lastPathComponent]];
          AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
          exportSession.outputURL = tempVideoFileURL;
          exportSession.outputFileType = AVFileTypeQuickTimeMovie;
          [exportSession exportAsynchronouslyWithCompletionHandler:^{
              NSLog(@"SAVING VIDEO 1: %@", tempVideoFileURL.absoluteString);
          }];
        }
        //did not find a video asset but we did find a cached video url
        else if(mediaObject.mediaType == 1 && mediaObject.videoURL && mediaObject.videoAsset == nil){
            NSURL *tempVideoFileURL = [[NSURL fileURLWithPath:folder] URLByAppendingPathComponent: [mediaObject.videoURL lastPathComponent]];
            NSLog(@"SAVING VIDEO 2: %@", tempVideoFileURL.absoluteString);
            id uhoh;
            [[NSFileManager defaultManager] copyItemAtPath: mediaObject.videoURL.path toPath: tempVideoFileURL.path error:&uhoh];
            //rename("from.txt", "to.txt")
            NSLog(@"GOT ERROR: %@", uhoh);
          //UISaveVideoAtPathToSavedPhotosAlbum(mediaObject.videoURL.path,nil,nil,nil);
         // [%c(SCStatusBarOverlayLabelWindow) showMessageWithText:@"Success! Snap saved to camera roll! 👻" backgroundColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:0.64]];
        }
      }
    }
}
*/


static void (*orig_savebtn)(id self, SEL _cmd, _Bool arg1, _Bool arg2, id arg3, id arg4);
static void savebtn(id self, SEL _cmd, _Bool arg1, _Bool arg2, id arg3, id arg4){
    //- (void)setPresented:(_Bool)arg1 animated:(_Bool)arg2 source:(id)arg3 completion:(id)arg4
    //%orig;
    //void (*orig)(id self, SEL _cmd, _Bool arg1, _Bool arg2, id arg3, id arg4) = (void*)objc_msgSend;
    //orig(self, @selector(orig_setPresented:), arg1, arg2, arg3, arg4); //orig

    
    orig_savebtn(self, _cmd, arg1, arg2, arg3, arg4);
    @try{
        if(![[ShadowData sharedInstance] enabled_secure: "save"]) return;
        if([[ShadowData sharedInstance] enabled_secure: "savebutton"]) return;
        
        SCContextV2SwipeUpViewController *menu = (SCContextV2SwipeUpViewController *)[self presentedViewController];
        SCContextV2ActionMenuViewController *action = (SCContextV2ActionMenuViewController *)[[menu childViewControllers] objectAtIndex: 1];
        UIStackView *stack = [[[[MSHookIvar<UIStackView *>(action, "_stackView") subviews] objectAtIndex:0] subviews] objectAtIndex:0];
        if([stack.arrangedSubviews lastObject].tag == 1) return;
        UIView *div = [UIView new];
        div.translatesAutoresizingMaskIntoConstraints = false;
        [div addConstraint: [div.heightAnchor constraintEqualToConstant: .666666]];
        div.backgroundColor = [UIColor colorWithRed: 0.21 green: 0.21 blue: 0.21 alpha: 1.00];
        if(stack.arrangedSubviews.count > 0) [stack addArrangedSubview: div];
        SIGActionSheetCell *newOption = [(SIGActionSheetCell *)[%c(SIGActionSheetCell) optionCellWithText:@""] initWithStyle:0];

        newOption.titleText = @"Save to Camera Roll";
        //figure out internal way fo using selectors instead of gesture recog
        /* [newOption _addTarget:self action:@selector(saveSnap)]; */
        [newOption setTrailingAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/save.png"]]];
        //saveCell = newOption;
        SCOperaPageViewController *opera = (SCOperaPageViewController *)[[self attachedToView] performSelector:@selector(_operaPageViewController)];
        for(int i = 0; i < newOption.gestureRecognizers.count;i++)
            (void)[[newOption.gestureRecognizers objectAtIndex:i] initWithTarget:opera action:@selector(saveSnap)];
        newOption.tag = 1;
        if(stack.arrangedSubviews.count > 0) [stack addArrangedSubview: div];
        [stack addArrangedSubview: newOption];
    }@catch(id anException) {
        [ShadowHelper banner:@"Incompatible save button!" color:@"#FF0000"];
    }
}

static void (*orig_markheader)(id self, SEL _cmd, NSUInteger arg1);
static void markheader(id self, SEL _cmd, NSUInteger arg1){
    orig_markheader(self, _cmd, arg1);
    @try{
        if([[ShadowData sharedInstance] enabled: @"customtitle"]){
            ((SIGHeaderItem*)[self performSelector:@selector(currentHeaderItem)]).title = [ShadowData sharedInstance].settings[@"customtitle"];
        }else{
            ((SIGHeaderItem*)[self performSelector:@selector(currentHeaderItem)]).title = @"Shadow X";
        }
    
        SIGHeaderTitle *headerTitle = (SIGHeaderTitle *)[[[[(UIView *)self subviews] lastObject].subviews lastObject].subviews firstObject];
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:headerTitle action:@selector(_titleTapped:)];
        SIGLabel * label = [headerTitle.subviews firstObject];
        [label addGestureRecognizer:singleFingerTap];
        if(![[label class] isEqual: %c(SIGLabel)])return;
        SIGLabel *subtitle = headerTitle.subviews[1];
        for(int i = 2; i < headerTitle.subviews.count; i++) [headerTitle.subviews[i] removeFromSuperview]; //remove indicators
        if(![[ShadowData sharedInstance] enabled_secure: "subtitle"]){
            [subtitle setHidden: NO];
            id user = [%c(User) performSelector:@selector(createUser)];
            NSString *dispname = (NSString *)[user performSelector:@selector(displayName_LEGACY_DO_NOT_USE)];
            subtitle.text = [[ShadowData sharedInstance].server[@"subtext"] stringByReplacingOccurrencesOfString:@"%NAME%" withString: [[dispname componentsSeparatedByString:@" "] firstObject]];
            NSLayoutConstraint *horiz = [NSLayoutConstraint constraintWithItem:subtitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerTitle attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            NSLayoutConstraint *vert = [NSLayoutConstraint constraintWithItem:subtitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerTitle attribute:NSLayoutAttributeCenterY multiplier:2.0 constant:-1];
            [headerTitle addConstraint:horiz];
            [headerTitle addConstraint:vert];
        }else{
            subtitle.text = @"";
        }
        
        if([[ShadowData sharedInstance] enabled_secure: "rgb"]){
            RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)label];
            [effect resume];
        }
    } @catch(id anException){
        //debug stuff
    }
}

static void (*orig_loaded2)(id self, SEL _cmd);
static void loaded2(SCOperaPageViewController* self, SEL _cmd){
    orig_loaded2(self, _cmd);
    /*
    if([[ShadowData sharedInstance] enabled: @"folder"]){
        saveauto(self,[ShadowData sharedInstance].settings[@"folder"]);
    }
    */
    [ShadowData sharedInstance].seen = FALSE;
    NSDictionary* properties = (NSDictionary*)[[self performSelector:@selector(page)] performSelector:@selector(properties)];
    if([[ShadowData sharedInstance] enabled_secure: "seenbutton"]){
        
        if([[ShadowData sharedInstance] enabled: @"markfriends"] && properties[@"discover_story_composite_id"] != nil){
            [ShadowData sharedInstance].seen = TRUE;
        }else{
            
            UIButton * seenButton = [UIButton buttonWithType:UIButtonTypeCustom];
            seenButton.frame = CGRectMake(40,40,40,40);
            UIImage *seenIcon = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/seen.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            [seenButton setImage: seenIcon forState:UIControlStateNormal];
            [seenButton addTarget:self action:@selector(markSeen) forControlEvents:UIControlEventTouchUpInside];
            if([[ShadowData sharedInstance] enabled_secure: "seenright"]){
                double x = [UIScreen mainScreen].bounds.size.width * 0.85; //tweak me? dynamic maybe?
                double y = [UIScreen mainScreen].bounds.size.height * 0.80;//tweak me? dynamic maybe?
                seenButton.center = CGPointMake(x, y - 50);
            }else{
                double x = [UIScreen mainScreen].bounds.size.width * 0.15;
                double y = [UIScreen mainScreen].bounds.size.height * 0.80;
                seenButton.center = CGPointMake(x, y);
            }
            [ShadowData sharedInstance].currentopera = self;
            [((UIViewController*)self).view addSubview: seenButton];
        }
    }
    if([[ShadowData sharedInstance] enabled_secure: "savebutton"]){
        UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.frame = CGRectMake(40,40,40,40);
        UIImage *saveIcon = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/save.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [saveButton setImage: saveIcon forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(saveSnap) forControlEvents:UIControlEventTouchUpInside];
        double x = [UIScreen mainScreen].bounds.size.width * 0.85; //tweak me? dynamic maybe?
        double y = [UIScreen mainScreen].bounds.size.height * 0.80;//tweak me? dynamic maybe?
        saveButton.center = CGPointMake(x, y);
        [((UIViewController*)self).view addSubview: saveButton];
    }
    if([[ShadowData sharedInstance] enabled_secure: "screenshotbtn"]){
        UIButton * scButton = [UIButton buttonWithType:UIButtonTypeCustom];
        scButton.frame = CGRectMake(40,40,40,40);
        UIImage *scIcon = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/screenshot.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [scButton setImage: scIcon forState:UIControlStateNormal];
        [scButton addTarget:%c(ShadowHelper) action:@selector(screenshot) forControlEvents:UIControlEventTouchUpInside];
        double x = [UIScreen mainScreen].bounds.size.width * 0.85; //tweak me? dynamic maybe?
        double y = [UIScreen mainScreen].bounds.size.height * 0.80;
        if([[ShadowData sharedInstance] enabled_secure: "seenbutton"]){
            scButton.center = CGPointMake(x, y - 100);
        }else{
            scButton.center = CGPointMake(x, y - 50);
        }
        [((UIViewController*)self).view addSubview: scButton];
    }
}


static void (*orig_loaded)(id self, SEL _cmd);
static void loaded(id self, SEL _cmd){
    if(![ShadowData isFirst]) {
        UIViewController *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Hello and Welcome!" description:@"Shadow X has been loaded and injected using librelic 2.0.\n\nUsage: Tap \"Shadow X\" to open the settings panel.\n\nHave fun, and remember to report any and all bugs! 👻\n\nDesigned privately by no5up and Kanji"];
        [self presentViewController:alert animated:YES completion:nil];
        [[ShadowData sharedInstance] save];
    }
    orig_loaded(self, _cmd);
    if(![[ShadowData sharedInstance] enabled_secure: "upload"]) return;
    if(![MSHookIvar<NSString *>(self, "_debugName") isEqual: @"Camera"]) return;
    UIButton * uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadButton.frame = CGRectMake(40,40,40,40);
    UIImage *uploadIcon = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/upload.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    [uploadButton setImage:uploadIcon forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    double x = [UIScreen mainScreen].bounds.size.width *0.88; //tweak me? dynamic maybe?
    double y = [UIScreen mainScreen].bounds.size.height *0.87;//tweak me? dynamic maybe?
    uploadButton.center = CGPointMake(x, y);
    [((UIViewController*)self).view addSubview: uploadButton];
}

//new, so no orig
static void uploadhandler(id self, SEL _cmd){
    SCMainCameraViewController *cam = [((UIViewController*)self).childViewControllers firstObject];
    ShadowImportUtil* util = [ShadowImportUtil new];
    [cam presentViewController: util animated: NO completion:nil];
    [util pickMediaWithImageHandler:^(NSURL *url){
        [util dismissViewControllerAnimated:NO completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            [cam _handleDeepLinkShareToPreviewWithImageFile:url];
            //[cam performSelector: @selector(captureStillImage)];
        });
    } videoHandler:^(NSURL *url){
        [util dismissViewControllerAnimated:NO completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            [cam _handleDeepLinkShareToPreviewWithVideoFile:url];
            //[cam performSelector: @selector(captureStillImage)];
        });
    }];
    /*
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Upload" description:@""];
    SIGAlertDialogAction *upload = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Select" actionBlock:^(){
        [importUtil pickMedia];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    SIGAlertDialogAction *option2 = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Option 2" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert _setActions: @[upload,option2,back]];
    
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
     */
}
static void (*orig_hidebtn)(id self, SEL _cmd);
static void hidebtn(id self, SEL _cmd){
    orig_hidebtn(self, _cmd);
    if(![[ShadowData sharedInstance] enabled_secure: "hidenewchat"]) return;
    //[[XLLogerManager manager] showOnWindow];
    [self performSelector:@selector(removeFromSuperview)];
}

static void (*orig_callconfirmaudio)(id self, SEL _cmd);
static void callconfirmaudio(id self, SEL _cmd){
    if(![[ShadowData sharedInstance] enabled_secure: "callconfirmaudio"]){
        orig_callconfirmaudio(self, _cmd);
        return;
    }
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Woah!" description:@"Did you mean to start an audio call?"];
    
    SIGAlertDialogAction *call = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Call" actionBlock:^(){
        orig_callconfirmaudio(self, _cmd);
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alert _setActions: @[back,call]];
    
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}
static void (*orig_callconfirmvideo)(id self, SEL _cmd);
static void callconfirmvideo(id self, SEL _cmd){
    if(![[ShadowData sharedInstance] enabled_secure: "callconfirmvideo"]){
        orig_callconfirmvideo(self, _cmd);
        return;
    }
    SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Woah!" description:@"Did you mean to start a video call?"];
    
    SIGAlertDialogAction *call = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Call" actionBlock:^(){
        orig_callconfirmvideo(self, _cmd);
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alert _setActions: @[back,call]];
    
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    [topVC presentViewController: alert animated: true completion:nil];
}


static void (*orig_hidebuttons)(id self, SEL _cmd, id arg1);
static void hidebuttons(id self, SEL _cmd, id arg1){
    orig_hidebuttons(self, _cmd, arg1);
    if(![[ShadowData sharedInstance] enabled_secure: "nocall"]) return;
    [((UIView*)arg1) setHidden:YES];
}

//remove emojis
//SCFriendsFeedFriendmojiViewModel,initWithFriendmojiText:friendmojiTextSize:expiringStreakFriendmojiText:expiringStreakFriendmojiTextSize:

//- (id)initWithFriendmojiText:(NSAttributedString *)arg1 friendmojiTextSize:(struct CGSize)arg2 expiringStreakFriendmojiText:(id)arg3 expiringStreakFriendmojiTextSize:(struct CGSize)arg4{
static id (*orig_noemojis)(id self,SEL _cmd,NSAttributedString *arg1, struct CGSize arg2, id arg3, struct CGSize arg4);
static id noemojis(id self,SEL _cmd,NSAttributedString *arg1, struct CGSize arg2, id arg3, struct CGSize arg4){
    orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4);
    if(![[ShadowData sharedInstance] enabled_secure: "friendmoji"]) return orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4);
    if([arg1.string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) return orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4);
    return orig_noemojis(self, _cmd, [[NSAttributedString new] initWithString:@""], arg2, arg3, arg4);
}

//scramble friends
//SCUnifiedProfileSquadmojiView setViewModel:
static void (*orig_scramblefriends)(id self, SEL _cmd, NSArray *arg1);
static void scramblefriends(id self, SEL _cmd, NSArray *arg1){
    if(![[ShadowData sharedInstance] enabled_secure: "scramble"]){
        orig_scramblefriends(self, _cmd, arg1);
        return;
    }
    NSMutableArray *viewModel = [arg1 mutableCopy];
    NSUInteger count = [viewModel count];
    if (count <= 1) return;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [viewModel exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    orig_scramblefriends(self, _cmd, [viewModel copy]);
}

//Views Spoofing
//SCUnifiedProfileMyStoriesHeaderDataModel totalViewCount ->unsigned long long
static unsigned long long (*orig_views)(id self, SEL _cmd);
static unsigned long long views(id self, SEL _cmd){
    if(![[ShadowData sharedInstance] enabled_secure: "spoofviews"])
        return orig_views(self, _cmd);
    return [[ShadowData sharedInstance].settings[@"spoofviews"] intValue];
}

//SCUnifiedProfileMyStoriesHeaderDataModel totalScreenshotCount ->unsigned long long

static unsigned long long (*orig_screenshots)(id self, SEL _cmd);
static unsigned long long screenshots(id self, SEL _cmd){
    if(![[ShadowData sharedInstance] enabled_secure: "spoofsc"])
        return orig_screenshots(self, _cmd);
    return [[ShadowData sharedInstance].settings[@"spoofsc"] intValue];
}


static bool noads(id self, SEL _cmd){
    if([[ShadowData sharedInstance] enabled_secure: "noads"]){
        return FALSE;
    }
    return TRUE;
}


static BOOL (*orig_pinned)(id self, SEL _cmd, id arg1);
static BOOL pinned(id self, SEL _cmd, id arg1){
    if([[ShadowData sharedInstance] enabled_secure: "pinnedchats"]){
        MSHookIvar<long long>(self,"_maxPinnedConversations") = [[ShadowData sharedInstance].settings[@"pinnedchats"] intValue];
    }
    return orig_pinned(self, _cmd, arg1);
}




static void (*orig_updateghost)(id self, SEL _cmd, long arg1);
static void updateghost(id self, SEL _cmd, long arg1){
    orig_updateghost(self, _cmd, arg1);
    if([[ShadowData sharedInstance] enabled_secure: "eastereggs"]){
        id ghost = MSHookIvar<id>(self,"_ghost");
        UIImageView *normal = MSHookIvar<UIImageView *>(ghost, "_defaultBody");
        UIImageView *wink = MSHookIvar<UIImageView *>(ghost, "_winkBody");
        UIImageView *shocked = MSHookIvar<UIImageView *>(ghost, "_shockedBody");
        
        UIImage *rose = [UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/rose.png"];
        
        normal.image = rose;
        wink.image = rose;
        shocked.image = rose;
        
        UIImageView *hands = MSHookIvar<UIImageView *>(self,"_hands");
        hands.alpha = 0;
        NSArray *ghostConstraints = MSHookIvar<NSArray *>(self,"_normalGhostConstraints");
        NSLayoutConstraint *bottom = [ghostConstraints lastObject];
        bottom.constant = -1 * rose.size.height;
    }
}

static void (*orig_settingstext)(id self, SEL _cmd);
static void settingstext(id self, SEL _cmd){
    orig_settingstext(self, _cmd);
    //NSLog(@"swifty: %@, I am %@",%c(SCSettingsImplementation.SCSettingsViewController),[self class]);
    
    UITableView * table = MSHookIvar<UITableView *>(self, "_scrollView");//swift????
    if(!table) return;
    if(![table respondsToSelector:@selector(paddedTableFooterView)]) return;
    UILabel * label = (UILabel *)[table performSelector:@selector(paddedTableFooterView)];
    if(label.tag != 1){
        label.text = [[label.text componentsSeparatedByString:@"\n"][0] stringByAppendingString: @"\nShadow X (relicloader) | librelic 2.0"];  //@"\nlibrelic 2\nShadow X (relicloader)"];
        label.tag = 1;
    }
    
    // -[SCSettingsImplementation.SCSettingsViewController viewDidLoad]
}


id (*orig_location)(id self, SEL _cmd);
id location(id self, SEL _cmd){
    if(![[ShadowData sharedInstance] enabled_secure: "location"]) return orig_location(self, _cmd);
    double longitude = [[ShadowData sharedInstance].location[@"Longitude"] doubleValue];
    double latitude = [[ShadowData sharedInstance].location[@"Latitude"] doubleValue];
    CLLocation * newlocation = [[CLLocation alloc]initWithLatitude: latitude longitude: longitude];
    return newlocation;//[[CLLocation alloc]initWithLatitude:35.8800 longitude:76.5151];
}

void (*orig_openurl)(id self, SEL _cmd, id arg1, id arg2);
void openurl(id self, SEL _cmd, id arg1, id arg2){
    if([[ShadowData sharedInstance] enabled: @"openurl"]){
        [[UIApplication sharedApplication] openURL:(NSURL *)arg1 options:@{} completionHandler:nil];
    }else{
        orig_openurl(self, _cmd, arg1, arg2);
    }
}

void (*orig_openurl2)(id self, SEL _cmd, id arg1, long arg2, id arg3, id arg4, id arg5);
void openurl2(id self, SEL _cmd, id arg1, long arg2, id arg3, id arg4, id arg5){
    NSLog(@"URL:%@ ext:%ld ",arg1, arg2);
    if([[ShadowData sharedInstance] enabled: @"openurl"]){
        [[UIApplication sharedApplication] openURL:(NSURL *)arg1 options:@{} completionHandler:nil];
    }else{
        orig_openurl2(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    }
}

@interface SCSwipeViewContainerViewController: NSObject
@property NSUInteger allowedDirections;
@end

long (*orig_nomapswipe)(id self, SEL _cmd, id arg1);
long nomapswipe(id self, SEL _cmd, id arg1){
    NSString *pageName = MSHookIvar<NSString *>(self, "_debugName");
    if([[ShadowData sharedInstance] enabled: @"nomapswiping"]){
        if([pageName isEqualToString:@"Friend Feed"]){
            ((SCSwipeViewContainerViewController*)self).allowedDirections = 1;
        }
    }
    return orig_nomapswipe(self, _cmd, arg1);
}

uint64_t confirmshot(id self, SEL _cmd){
    uint64_t (*orig)(id self, SEL _cmd) = (typeof(orig))class_getMethodImplementation([self class], _cmd);
    if(![[ShadowData sharedInstance] enabled: @"scpassthrough"] && [[ShadowData sharedInstance] enabled: @"screenshotconfirm"]){
        SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Screenshot" description:@"Should we notify the app that you took a screenshot?"];
        
        SIGAlertDialogAction *screenshot = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Screenshot" actionBlock:^(){
            [alert dismissViewControllerAnimated:YES completion:nil];
            return orig(self, _cmd);
        }];
        SIGAlertDialogAction *ignore = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Supress" actionBlock:^(){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert _setActions: @[ignore,screenshot]];
        UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        while (topVC.presentedViewController) topVC = topVC.presentedViewController;
        [topVC presentViewController: alert animated: true completion:nil];
    }
}

%hook NSNotificationCenter
- (void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4 {
    NSString *data = arg3;
    if([data isEqual: @"UIApplicationUserDidTakeScreenshotNotification"]){
        if([[ShadowData sharedInstance] enabled: @"screenshot"]){
            NSLog(@"Hey! Call this to trigger a recording: -[%@ %@]",[arg1 class],NSStringFromSelector(arg2));
            RelicHookMessage([arg1 class], arg2, (void *)confirmshot);
        }
    }
    if([data isEqual: @"SCUserDidScreenRecordContentNotification"]){
        if([[ShadowData sharedInstance] enabled: @"screenrecord"]){
            return;
        }
    }
    %orig;
}
%end

void markSeen(SCOperaPageViewController * self, SEL _cmd){
    if([[ShadowData sharedInstance] enabled_secure: "closeseen"]){
        [ShadowHelper banner:@"Marking as SEEN" color:@"#00FF00"];
        [ShadowData sharedInstance].seen = TRUE;
        [((SCOperaViewController*)self.delegate) _advanceToNextPage:YES];
    }else{
        if([ShadowData sharedInstance].seen == FALSE){
            [ShadowHelper banner:@"Marking as SEEN" color:@"#00FF00"];
            [ShadowData sharedInstance].seen = TRUE;
        }else{
            [ShadowHelper banner:@"Marking as UNSEEN" color:@"#00FF00"];
            [ShadowData sharedInstance].seen = FALSE;
        }
    }
    
}
uint64_t (*orig_nohighlights)(id self, SEL _cmd, id arg1, BOOL arg2);
uint64_t nohighlights(id self, SEL _cmd, id arg1, BOOL arg2){
    if([[ShadowData sharedInstance] enabled: @"highlights"]){
        NSArray* items = (NSArray*)arg1;
        if(![[items[0] performSelector:@selector(accessibilityIdentifier)] isEqualToString:@"arbar_create"])
            return orig_nohighlights(self, _cmd, @[items[0],items[1],items[2],items[3]], arg2);
    }
    return orig_nohighlights(self, _cmd, arg1, arg2);
}

id (*orig_nodiscover)(id self, SEL _cmd);
id nodiscover(UIView* self, SEL _cmd){
    if([[ShadowData sharedInstance] enabled: @"discover"]){
        if(self.superview.class != %c(SCHorizontalOneBounceCollectionView)) [self removeFromSuperview];
    }
    return orig_nodiscover(self, _cmd);
}

id (*orig_nodiscover2)(id self, SEL _cmd);
id nodiscover2(UIView* self, SEL _cmd){
    if([[ShadowData sharedInstance] enabled: @"discover"]){
        if(self.superview.class != %c(SCHorizontalOneBounceCollectionView)) [self removeFromSuperview];
    }
    return orig_nodiscover2(self, _cmd);
}


void (*orig_noquickadd)(id self, SEL _cmd);
void noquickadd(id self, SEL _cmd){
    orig_noquickadd(self, _cmd);
    if([[ShadowData sharedInstance] enabled: @"quickadd"]){
        NSString *identifier = [self performSelector:@selector(accessibilityIdentifier)];
        if([identifier isEqual:@"quick_add_item"]) [self performSelector:@selector(removeFromSuperview)];
    }
}
void (*orig_loaded3)(id self, SEL _cmd);
void loaded3(id self, SEL _cmd){
    orig_loaded3(self, _cmd);
    if([[ShadowData sharedInstance] enabled_secure: "scspambtn"]){
        UIButton * scButton = [UIButton buttonWithType:UIButtonTypeCustom];
        scButton.frame = CGRectMake(40,40,40,40);
        UIImage *scIcon = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/screenshot.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [scButton setImage: scIcon forState:UIControlStateNormal];
        [scButton addTarget:self action:@selector(screenshot) forControlEvents:UIControlEventTouchUpInside];
        double x = [UIScreen mainScreen].bounds.size.width * 0.50; //tweak me? dynamic maybe?
        double y = [UIScreen mainScreen].bounds.size.height * 0.10;
        scButton.center = CGPointMake(x, y );
        [((UIViewController*)self).view addSubview: scButton];
    }
}

void screenshotspam(id self, SEL _cmd){
    for(int i = 0; i < 100; i ++)
    [self performSelector:@selector(userDidTakeScreenshot)];
}

//_sendSnapNoSendToViewWithAddToMyStory:0x0 recipientUsernames:0x285fa0180 recipientUserIds:0x2891b96e0 mischiefs:0x1f82e44a8 selectedOurStory:0x0 selectedCustomStories:0x285fa2760 businessIds:0x285fa2400 appStories:0x285fa0600


//_sendToRecipients:storiesPostingConfig:businessIds:groups:appStories:additionalText:
//_handleRequestAndInviteFeaturesAndSendSnap:0x2879153b0 sendToRecipients:0x0 showSendToLoadingOverlay:0x0 recipientUsernames:0x285fa0180 mischiefs:0x1f82e44a8]
//_sendSnapNoSendToViewWithAddToMyStoryAfterInterceptorCheck:0x0 recipientUsernames:0x285fa0180 recipientUserIds:0x2891b96e0 mischiefs:0x1f82e44a8 selectedOurStory:0x0 selectedCustomStories:0x285fa2760 businessIds:0x285fa2400 appStories:0x285fa0600]
 


//_handleRequestAndInviteFeaturesAndSendSnap:sendToRecipients:showSendToLoadingOverlay:recipientUsernames:mischiefs:

%ctor{
    /*
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        NSLog(@"APP LOADED");
        //[[XLLogerManager manager] showOnWindow];
    }];
     */
    [[XLLogerManager manager] prepare];
    
    //if( [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.toyopagroup.picaboo"]);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RelicHookMessageEx(%c(SIGHeaderTitle), @selector(_titleTapped:), (void *)tap, &orig_tap);
        RelicHookMessageEx(%c(SCFriendsFeedCreateButton), @selector(resetCreateButton), (void *)hidebtn, &orig_hidebtn);
        RelicHookMessageEx(%c(SCNMessagingMessage), @selector(isSaved), (void *)savehax, &orig_savehax);
        RelicHookMessageEx(%c(SIGHeader), @selector(_stylize:), (void *)markheader, &orig_markheader);
        RelicHookMessageEx(%c(SCTCallButtons), @selector(_audioButtonPressed), (void *)callconfirmaudio, &orig_callconfirmaudio);
        RelicHookMessageEx(%c(SCTCallButtons), @selector(_videoButtonPressed), (void *)callconfirmvideo,  &orig_callconfirmvideo);
        RelicHookMessageEx(%c(SCFriendsFeedFriendmojiViewModel), @selector(initWithFriendmojiText:friendmojiTextSize:expiringStreakFriendmojiText:expiringStreakFriendmojiTextSize:), (void *)noemojis, &orig_noemojis);
        RelicHookMessageEx(%c(SCUnifiedProfileMyStoriesHeaderDataModel), @selector(totalViewCount), (void *)views, &orig_views);
        RelicHookMessageEx(%c(SCUnifiedProfileMyStoriesHeaderDataModel), @selector(totalScreenshotCount), (void *)screenshots, &orig_screenshots);
        RelicHookMessageEx(%c(SCUnifiedProfileSquadmojiView), @selector(setViewModel:), (void *)scramblefriends, &orig_scramblefriends);
        RelicHookMessageEx(%c(SCSingleStoryViewingSession), @selector(_markStoryAsViewedWithStorySnap:), (void *)storyghost, &orig_storyghost);
        RelicHookMessageEx(%c(SCNMessagingSnapManager),@selector(onSnapInteraction:conversationId:messageId:callback:), (void *)snapghost, &orig_snapghost);
        RelicHookMessageEx(%c(SIGScrollViewKeyValueObserver),@selector(_contentOffsetDidChange), (void *)settingstext, &orig_settingstext);
        RelicHookMessageEx(%c(SCURLAttachmentHandler),@selector(openURL:baseView:), (void *)openurl, &orig_openurl);
        RelicHookMessageEx(%c(SCContextV2BrowserPresenter),@selector(presentURL:preferExternal:metricParams:fromViewController:completion:), (void *)openurl2, &orig_openurl2);
        RelicHookMessage(%c(SCOperaPageViewController), @selector(saveSnap), (void *)save);
        RelicHookMessage(%c(SCOperaPageViewController), @selector(markSeen), (void *)markSeen);
        
        RelicHookMessageEx(%c(SCChatMainViewController), @selector(viewDidFullyAppear), (void *)loaded3, &orig_loaded3);
        RelicHookMessage(%c(SCChatMainViewController), @selector(screenshot), (void *)screenshotspam);
        
        RelicHookMessageEx(%c(SIGPullToRefreshView), @selector(setHeight:), (void *)updateghost, &orig_updateghost);
                           
        RelicHookMessage(%c(SCSwipeViewContainerViewController), @selector(upload), (void *)uploadhandler);
        //RelicHookMessageEx(%c(SIGPullToRefreshGhostView), @selector(rainbow), (void *)updateghost, &orig_updateghost);
        RelicHookMessageEx(%c(SCLocationManager), @selector(location), (void *)location, &orig_location);
        RelicHookMessageEx(%c(SCOperaPageViewController), @selector(viewDidLoad), (void *)loaded2, &orig_loaded2);
        RelicHookMessageEx(%c(SCPinnedConversationsDataCoordinator), @selector(hasPinnedConversationWithId:), (void *)pinned, &orig_pinned);
        RelicHookMessageEx(%c(SCSwipeViewContainerViewController), @selector(viewDidLoad), (void *)loaded, &orig_loaded);
        RelicHookMessageEx(%c(SCContextV2SwipeUpGestureTracker), @selector(setPresented:animated:source:completion:), (void *)savebtn, &orig_savebtn);
        RelicHookMessageEx(%c(SCChatViewHeader), @selector(attachCallButtonsPane), (void *)hidebuttons, &orig_hidebuttons);
        RelicHookMessageEx(%c(SCDiscoverFeedStoryCollectionViewCell), @selector(viewModel), (void *)nodiscover, &orig_nodiscover);
        RelicHookMessageEx(%c(SCDiscoverFeedPublisherStoryCollectionViewCell), @selector(viewModel), (void *)nodiscover2, &orig_nodiscover2);
        RelicHookMessageEx(%c(SCSwipeViewContainerViewController), @selector(isFullyVisible:), (void *)nomapswipe, &orig_nomapswipe);
        RelicHookMessageEx(%c(SIGNavigationBarView), @selector(initWithItems:leadingAligned:), (void *)nohighlights, &orig_nohighlights);
        RelicHookMessageEx(%c(SCSnapchatterTableViewCell), @selector(layoutSubviews), (void *)noquickadd, &orig_noquickadd);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowShowsAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowEmbeddedWebViewAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowPublicStoriesAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowDiscoverAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowContentInterstitialAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowCognacAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowStoryAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowUserStoriesAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowAds), (void *)noads);
    });
    NSLog(@"[Shadow X + Relic] Hooks Initialized and Tweak Loaded");
    [[ShadowData sharedInstance] load];
}

%dtor {
    //if(![ShadowData isFirst]) [[ShadowData sharedInstance] save];
    NSLog(@"[Shadow X + Relic] Hooks Unloaded (App Closed)");
}

/*
%hook SCNMessagingMessage
- (BOOL)canDelete{
    return NO;
}
- (_Bool)isErasedSnapStatusMessage{
    return NO;
}
%end

%hook SCFideliusMessageEncryptionKeyTable
- (BOOL)_deleteRecordsOlderThanTimestamp:(double)arg1{
    return NO;
}
- (void)deleteRecord:(id)arg1 messageId:(long long)arg2{
    %orig(nil,1);
}
%end

%hook SCChatFailedMessageDeleteActionData
- (BOOL)isEqual:(id)arg1{
    return NO;
}
-(NSString *)messageId{
    return nil;
}
-(NSString *)conversationId{
    return nil;
}
%end

%hook SOJUGalleryServletDeleteEntriesResponse
+ (void)registerMessageFields:(id)arg1{
    %orig(nil);
}
%end

%hook SCListsLists
- (id)deleteListsWithMessage:(id)arg1 responseHandler:(id)arg2 callOptions:(id)arg3{
    return nil;
}

%end

%hook SCStackedChatViewModel
- (BOOL)canStackMessage:(id)arg1 lastDeletedSequenceNumber:(unsigned long long)arg2{
    return NO;
}
%end

%hook SCStackedStickerChatViewModel
- (BOOL)canStackMessage:(id)arg1 lastDeletedSequenceNumber:(unsigned long long)arg2{
    return NO;
}
%end

static BOOL (*orig_savehax)(id self, SEL _cmd);
BOOL savehax(id self, SEL _cmd){
    if([self messageType] == 18){
        NSLog(@"Saving Message...");
        return true;
    }
    return orig_savehax(self, _cmd);
}

static void (*orig_snapghost)(id self, SEL _cmd, long long arg1, id arg2, long long arg3, id arg4);
static void snapghost(id self, SEL _cmd, long long arg1, id arg2, long long arg3, id arg4){
    NSLog(@"Hello, you opened a snap!");
    orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
}


%ctor {
    NSLog(@"RelicLoader Active :) if you arent no5up or kanji wyd bro");
    RelicHookMessageEx(%c(SCNMessagingMessage), @selector(isSaved), (void*)savehax, &orig_savehax);
    RelicHookMessageEx(%c(SCNMessagingSnapManager), @selector(onSnapInteraction:conversationId:messageId:callback:), (void *)snapghost, &orig_snapghost);
}


*/
