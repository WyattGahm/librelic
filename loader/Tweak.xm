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

#import "util.h"
#import "ShadowData.h"
#import "ShadowSettingsViewController.h"
#import "ShadowImportUtil.h"
#import "RainbowRoad.h"

#import "XLLogerManager.h"

@interface SCStatusBarOverlayLabelWindow : UIWindow
+(void)showErrorWithText:(id)arg1 backgroundColor:(id)arg2;
+(void)showMessageWithText:(id)arg1 backgroundColor:(id)arg2;
@end
SIGActionSheetCell * saveCell;


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
    if(![[ShadowData sharedInstance] enabled_secure: "storyghost"])
        orig_storyghost(self, _cmd, arg1);
}

static void (*orig_snapghost)(id self, SEL _cmd, long long arg1, id arg2, long long arg3, id arg4);
static void snapghost(id self, SEL _cmd, long long arg1, id arg2, long long arg3, id arg4){
    if(![[ShadowData sharedInstance] enabled_secure: "snapghost"]) orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
}

//no orig, were adding this
static void save(id self, SEL _cmd){
    SCOperaPageViewController *opera = (SCOperaPageViewController *)[[self attachedToView] performSelector:@selector(_operaPageViewController)];
    NSArray* mediaArray = [opera shareableMedias];

    //the mediaArray has 1 object, meaning most likely it is image
    if (mediaArray.count == 1){
      SCOperaShareableMedia *mediaObject = (SCOperaShareableMedia *)[mediaArray firstObject];
      //double check that the mediaObject is a image mediaType
      if (mediaObject.mediaType == 0){
        UIImage *snapImage = [mediaObject image];
        UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
        [%c(SCStatusBarOverlayLabelWindow) showMessageWithText:@"Success! Snap saved to camera roll! 👻" backgroundColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:0.64]];
      }
      //add error checking
      else{
        NSLog(@"Shadow tried saving image, but failed");
        [%c(SCStatusBarOverlayLabelWindow) showErrorWithText:@"Uh oh! Failed to save this snap. 😢" backgroundColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
      }
    }
    //the mediaArray has more than one object, meaning most likely it is a video
    else{
      //enumerate through the array to check which object contains the video asset
      for (SCOperaShareableMedia *mediaObject in mediaArray){

          NSLog(@"Shadow enumerating through array looking for video asset");
        //check if mediaObject is video mediaType and it's videoAsset is not null
        if ((mediaObject.mediaType == 1) && (mediaObject.videoAsset) && (mediaObject.videoURL == nil)){
          AVURLAsset *asset = (AVURLAsset *)(mediaObject.videoAsset);

          NSLog(@"Shadow found the video object to save %@",asset);
          NSURL *assetURL = asset.URL;
          //TODO: change the tempVideoFile output location
          NSURL *documentsURL = [[[NSFileManager defaultManager]
              URLsForDirectory:NSDocumentDirectory
                     inDomains:NSUserDomainMask] firstObject];
          NSURL *tempVideoFileURL = [documentsURL URLByAppendingPathComponent:[assetURL lastPathComponent]];

          AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
            initWithAsset:asset
               presetName:AVAssetExportPresetHighestQuality];
          exportSession.outputURL = tempVideoFileURL;
          exportSession.outputFileType = AVFileTypeQuickTimeMovie;
          [exportSession exportAsynchronouslyWithCompletionHandler:^{
            UISaveVideoAtPathToSavedPhotosAlbum(tempVideoFileURL.path,nil,nil,nil);
            [%c(SCStatusBarOverlayLabelWindow) showMessageWithText:@"Success! Snap saved to camera roll! 👻" backgroundColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:0.64]];
            NSLog(@"Shadow saved temp video file at path: %@ and transfered it into gallery",tempVideoFileURL);
          }];
        }
        //did not find a video asset but we did find a cached video url
        else if(mediaObject.mediaType == 1 && mediaObject.videoURL && mediaObject.videoAsset == nil){
          UISaveVideoAtPathToSavedPhotosAlbum(mediaObject.videoURL.path,nil,nil,nil);
          [%c(SCStatusBarOverlayLabelWindow) showMessageWithText:@"Success! Snap saved to camera roll! 👻" backgroundColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:0.64]];
        }
      }
    }
}



static void (*orig_savebtn)(id self, SEL _cmd, _Bool arg1, _Bool arg2, id arg3, id arg4);
static void savebtn(id self, SEL _cmd, _Bool arg1, _Bool arg2, id arg3, id arg4){
    //- (void)setPresented:(_Bool)arg1 animated:(_Bool)arg2 source:(id)arg3 completion:(id)arg4
    //%orig;
    //void (*orig)(id self, SEL _cmd, _Bool arg1, _Bool arg2, id arg3, id arg4) = (void*)objc_msgSend;
    //orig(self, @selector(orig_setPresented:), arg1, arg2, arg3, arg4); //orig

    
    orig_savebtn(self, _cmd, arg1, arg2, arg3, arg4);
    
    if(![[ShadowData sharedInstance] enabled_secure: "save"]) return;
    
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

    newOption.titleText = @"Save Snap🤪";
    //figure out internal way fo using selectors instead of gesture recog
    /* [newOption _addTarget:self action:@selector(saveSnap)]; */
    [newOption setTrailingAccessoryView:[[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"arrow.down.doc.fill"]]];

    saveCell = newOption;
    for(int i = 0; i < newOption.gestureRecognizers.count;i++)
    (void)[[newOption.gestureRecognizers objectAtIndex:i] initWithTarget:self action:@selector(saveSnap)];
    newOption.tag = 1;
    if(stack.arrangedSubviews.count > 0) [stack addArrangedSubview: div];
    [stack addArrangedSubview: newOption];
}

static void (*orig_markheader)(id self, SEL _cmd, NSUInteger arg1);
static void markheader(id self, SEL _cmd, NSUInteger arg1){
    orig_markheader(self, _cmd, arg1);
    NSLog(@"dbg0");
    
    /*
    if(![[ShadowData sharedInstance] shouldChangeHeader]){
        SIGHeaderTitle *headerTitle = (SIGHeaderTitle *)[[[[(UIView *)self subviews] lastObject].subviews lastObject].subviews firstObject];
        SIGLabel * label = [headerTitle.subviews firstObject];
        //if(![[label class] isEqual: %c(SIGLabel"))])return;
        SIGLabel *subtitle = [headerTitle.subviews lastObject];
        NSLayoutConstraint *laycst = MSHookIvar<NSLayoutConstraint *>(headerTitle, "_subtitleHeightConstraint");
        laycst.active = YES;
        [subtitle setHidden: YES];
        return;
    }
     */
    ((SIGHeaderItem*)[self performSelector:@selector(currentHeaderItem)]).title = @"Shadow X";
    SIGHeaderTitle *headerTitle = (SIGHeaderTitle *)[[[[(UIView *)self subviews] lastObject].subviews lastObject].subviews firstObject];//RelicHookIvar<SIGHeaderTitle *>(a,"_title");
    NSLog(@"dbg1");
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:headerTitle action:@selector(_titleTapped:)];
    [headerTitle addGestureRecognizer:singleFingerTap];
    SIGLabel * label = [headerTitle.subviews firstObject];
    if(![[label class] isEqual: %c(SIGLabel)])return;
    NSLog(@"dbg2");
    SIGLabel *subtitle = [headerTitle.subviews lastObject];
    NSLog(@"dbg3 %@",subtitle);
    [subtitle setHidden: NO];
    id user = [%c(User) performSelector:@selector(createUser)];
    NSString *dispname = (NSString *)[user performSelector:@selector(displayName_LEGACY_DO_NOT_USE)];
    subtitle.text = [[ShadowData sharedInstance].server[@"subtext"] stringByReplacingOccurrencesOfString:@"%NAME%" withString: [[dispname componentsSeparatedByString:@" "] firstObject]];
    NSLog(@"dbg4 %@",headerTitle);
    //NSLayoutConstraint *laycst = MSHookIvar<NSLayoutConstraint *>(headerTitle, "_subtitleHeightConstraint");
    //NSLog(@"dbg5 %@",laycst);
    //laycst.active = NO;
    if(![[ShadowData sharedInstance] enabled_secure: "rgb"]) return;
    NSLog(@"dbg6");
    RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)label];
    [effect resume];
    
}
static void (*orig_loaded)(id self, SEL _cmd);
static void loaded(id self, SEL _cmd){
    if(![ShadowData isFirst]) {
        UIViewController *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Hello and Welcome!" description:@"Shadow X has been loaded and injected using librelic.\n\nUsage: Tap \"Shadow X\" to open the settings panel.\n\nHave fun, and remember to report any and all bugs! 👻\n\nConsider donating to the developers, it means a lot and keeps the project going! 😊"];
        [self presentViewController:alert animated:YES completion:nil];
        [[ShadowData sharedInstance] save];
    }
    orig_loaded(self, _cmd);
    if(![[ShadowData sharedInstance] enabled_secure: "upload"]) return;
    if(![MSHookIvar<NSString *>(self, "_debugName") isEqual: @"Camera"]) return;
    NSString * pathToIcon = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].path stringByAppendingPathComponent:@"Composer/resources-private_profile.dir/res/core_button_share.png"];
    UIImage *uploadIcon = [[UIImage alloc] initWithContentsOfFile:pathToIcon];
    UIButton * uploadButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [uploadButton setImage:uploadIcon forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    double x = [UIScreen mainScreen].bounds.size.width - 20; //tweak me? dynamic maybe?
    double y = [UIScreen mainScreen].bounds.size.height - 100;//tweak me? dynamic maybe?
    uploadButton.center = CGPointMake(x, y);
    [((UIViewController*)self).view addSubview: uploadButton];
}

//new, so no orig
static void uploadhandler(id self, SEL _cmd){
    SCMainCameraViewController *cam = [((UIViewController*)self).childViewControllers firstObject];
    [[ShadowImportUtil new]pickMediaWithImageHandler:^(NSURL *url){
        [cam _handleDeepLinkShareToPreviewWithImageFile:url];
    } videoHandler:^(NSURL *url){
        [cam _handleDeepLinkShareToPreviewWithVideoFile:url];
    }];
    NSLog(@"Uploaded!");//info[@"UIImagePickerControllerOriginalImage"];????
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
    return ![[ShadowData sharedInstance] enabled_secure: "noads"];
}
%ctor{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        NSLog(@"APP LOADED");
        //[[XLLogerManager manager] showOnWindow];
    }];
    [[XLLogerManager manager] prepare];
    //[[XLLogerManager manager] showOnWindow];
    if( [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.toyopagroup.picaboo"]) NSLog(@"IGNORE THIS UNLESS YOURE HOOKING UIKIT");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"[Shadow X] Initializing Hooks...");
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
        RelicHookMessage(%c(SCContextV2SwipeUpGestureTracker), @selector(saveSnap), (void *)save);
        RelicHookMessage(%c(SCSwipeViewContainerViewController), @selector(upload), (void *)uploadhandler);
        RelicHookMessageEx(%c(SCSwipeViewContainerViewController), @selector(viewDidLoad), (void *)loaded, &orig_loaded);
        RelicHookMessageEx(%c(SCContextV2SwipeUpGestureTracker), @selector(setPresented:animated:source:completion:), (void *)savebtn, &orig_savebtn);
        RelicHookMessageEx(%c(SCChatViewHeader), @selector(attachCallButtonsPane), (void *)hidebuttons, &orig_hidebuttons);
        //RelicHookMessageEx(%c(SCSwipeViewContainerViewController), @selector(pageViewName), (void *)pagename, &orig_pagename);
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
    
    NSLog(@"[Shadow X] Hooks Initialized.");
    NSLog(@"[Shadow X] Shadow X has been loaded");
    NSLog(@"[Shadow X] Contact no5up#9993 or Kanji#2222 with important information");
    [[ShadowData sharedInstance] load];
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


%dtor{
    [[ShadowData sharedInstance] save];
    NSLog(@"[Shadow X] Shadow X has been unloaded");
}




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
