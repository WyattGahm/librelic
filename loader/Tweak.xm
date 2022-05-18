#import <Foundation/Foundation.h>
#include "../relicwrapper.m"
#include "SCNMessagingMessage.h"

#include <stdbool.h>


#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define _Bool bool
#define typeof __typeof__

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
#import "SCOperaViewController.h"
#import "SCSwipeViewContainerViewController.h"
#import "SCOperaActionMenuV2Option.h"
#import "SCMapBitmojiCluster.h"
#import "SCManagedRecordedVideo.h"
#import "SCFuture.h"
#import "SCChatActionMenuButtonViewModel.h"
#import "SCGrowingButton.h"

#import "util.h"
#import "ShadowData.h"
#import "ShadowHelper.h"
#import "ShadowAssets.h"
#import "ShadowSettingsViewController.h"
#import "ShadowImportUtil.h"
#import "RainbowRoad.h"
#import "ShadowOptionsManager.h"
#import "LocationPicker.h"
#import "XLLogerManager.h"
#import "ShadowButton.h"
#import "ShadowScreenshotManager.h"


static void (*orig_tap)(id self, SEL _cmd, id arg1);
static void tap(id self, SEL _cmd, id arg1){
    ShadowSettingsViewController *vc = [ShadowSettingsViewController new];
    [vc setModalPresentationStyle: UIModalPresentationPageSheet];
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) topVC = topVC.presentedViewController;
    vc.preferredContentSize = CGRectInset(topVC.view.bounds, 20, 20).size;
    [topVC presentViewController: vc animated: true completion:nil];
}

static BOOL (*orig_savehax)(SCNMessagingMessage *self, SEL _cmd);
static BOOL savehax(SCNMessagingMessage *self, SEL _cmd){
    if([ShadowData enabled: @"savehax"]){
        if([self isSnapMessage]) return YES;
    }
    return orig_savehax(self, _cmd);
}

static BOOL (*orig_savehax2)(SCNMessagingMessage *self, SEL _cmd, id arg1);
static BOOL savehax2(SCNMessagingMessage *self, SEL _cmd, id arg1){
    if([ShadowData enabled: @"savehax"]){
        //if([self isSnapMessage]) return YES;
        return YES;
    }
    return orig_savehax2(self, _cmd, arg1);
}

static void (*orig_storyghost)(id self, SEL _cmd, id arg1);
static void storyghost(id self, SEL _cmd, id arg1){
    if(![ShadowData enabled: @"seenbutton"])
        orig_storyghost(self, _cmd, arg1);
    if([ShadowData sharedInstance].seen == TRUE){
        orig_storyghost(self, _cmd, arg1);
        [ShadowData sharedInstance].seen = FALSE;
    }
}

static void (*orig_snapghost)(id self, SEL _cmd, long long arg1, id arg2, long long arg3, void * arg4);
static void snapghost(id self, SEL _cmd, long long arg1, id arg2, long long arg3, void * arg4){
    if(![ShadowData enabled: @"seenbutton"])
        orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
    if([ShadowData sharedInstance].seen == TRUE){
        orig_snapghost(self, _cmd, arg1, arg2, arg3, arg4);
        [ShadowData sharedInstance].seen = FALSE;
    }
}

//no orig, were adding this
static void save(SCOperaPageViewController* self, SEL _cmd) {
  NSArray *mediaArray = [self shareableMedias];
  if (mediaArray.count == 1) {
    SCOperaShareableMedia *mediaObject = (SCOperaShareableMedia *)[mediaArray firstObject];
    if (mediaObject.mediaType == 0) {
      UIImage *snapImage = [mediaObject image];
      UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
        [ShadowHelper banner:@"Snap saved to camera roll!" color:@"#00FF00"];
    } else {
        [ShadowHelper banner:@"Failed to save snap" color:@"#FF0000"];
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
          UISaveVideoAtPathToSavedPhotosAlbum(tempVideoFileURL.path, [%c(ShadowHelper) new], @selector(video:didFinishSavingWithError:contextInfo:), nil);
            [ShadowHelper banner:@"Snap saved to camera roll!" color:@"#00FF00"];
        }];
      } else if (mediaObject.mediaType == 1 && mediaObject.videoURL && mediaObject.videoAsset == nil) {
        UISaveVideoAtPathToSavedPhotosAlbum(mediaObject.videoURL.path, [%c(ShadowHelper) new], @selector(video:didFinishSavingWithError:contextInfo:), nil);
          [ShadowHelper banner:@"Snap saved to camera roll!" color:@"#00FF00"];
      }
    }
  }
}

static void (*orig_markheader)(id self, SEL _cmd, NSUInteger arg1);
static void markheader(id self, SEL _cmd, NSUInteger arg1){
    orig_markheader(self, _cmd, arg1);
    
    @try{
        if(![ShadowData enabled: @"hideshadow"]){
            if([ShadowData enabled: @"customtitle"]){
                ((SIGHeaderItem*)[self performSelector:@selector(currentHeaderItem)]).title = [ShadowData sharedInstance].settings[@"customtitle"];
            }else{
                ((SIGHeaderItem*)[self performSelector:@selector(currentHeaderItem)]).title = @"Shadow X";
            }
        }
        
    
        SIGHeaderTitle *headerTitle = (SIGHeaderTitle *)[[[[(UIView *)self subviews] lastObject].subviews lastObject].subviews firstObject];
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:headerTitle action:@selector(_titleTapped:)];
        SIGLabel * label = [headerTitle.subviews firstObject];
        [label addGestureRecognizer:singleFingerTap];
        if([ShadowData enabled: @"hideshadow"]) return;
        if(![[label class] isEqual: %c(SIGLabel)])return;
        SIGLabel *subtitle = headerTitle.subviews[1];
        for(int i = 2; i < headerTitle.subviews.count; i++) [headerTitle.subviews[i] removeFromSuperview]; //remove indicators
        if(![ShadowData enabled: @"subtitle"]){
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
        
        if([ShadowData enabled: @"rgb"]){
            if(label.tag == 0){
                RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)label];
                label.tag = 1;
                [effect resume];
            }
        }
    } @catch(id anException){
        [ShadowHelper banner:@"Header Modification Error!" color:@"#FF0000"];
    }
}

static void (*orig_loaded2)(id self, SEL _cmd);
static void loaded2(SCOperaPageViewController* self, SEL _cmd){
    orig_loaded2(self, _cmd);
    [ShadowData sharedInstance].seen = FALSE;
    
    if([ShadowData enabled:@"looping"]){
        [self updatePropertiesWithLooping: YES];
    }
    
    long btnsz = [ShadowData enabled: @"buttonsize"] ? [[ShadowData sharedInstance].settings[@"buttonsize"] intValue] : 40;
    NSDictionary* properties = (NSDictionary*)[[self performSelector:@selector(page)] performSelector:@selector(properties)];
    if([ShadowData enabled: @"markfriends"] && properties[@"discover_story_composite_id"] != nil){
        [ShadowData sharedInstance].seen = TRUE;
    }else {
        if(![ShadowData enabled: @"nativeui"]){
            if([ShadowData enabled: @"seenbutton"]){
                UIImage *seen1 = [ShadowAssets sharedInstance].seen;
                UIImage *seen2 = [ShadowAssets sharedInstance].seened;
                ShadowButton *seen = [[ShadowButton alloc] initWithPrimaryImage:seen1 secondaryImage:seen2 identifier:@"seen" target:self.delegate action:@selector(markSeen)];
                [self.view addSubview: seen];
            }
        }
    }
    
    if(![ShadowData enabled: @"nativeui"]){
        if([ShadowData enabled: @"screenshotbtn"]){
            UIImage *scIcon = [[ShadowAssets sharedInstance].screenshot imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            ShadowButton *screenshot = [[ShadowButton alloc] initWithPrimaryImage:scIcon secondaryImage:nil identifier:@"sc" target:%c(ShadowHelper) action:@selector(screenshot)];
            [screenshot addToVC: self];
        }
        if([ShadowData enabled: @"savebutton"]){
            UIImage *save1 = [ShadowAssets sharedInstance].save;
            UIImage *save2 = [ShadowAssets sharedInstance].saved;
            ShadowButton *save = [[ShadowButton alloc] initWithPrimaryImage:save1 secondaryImage:save2 identifier:@"save" target:self action:@selector(saveSnap)];
            [save addToVC: self];
        }
    }
    
}

static void (*orig_loaded4)(id self, SEL _cmd);
static void loaded4(id self, SEL _cmd){
    orig_loaded4(self, _cmd);
    
    [[ShadowOptionsManager sharedInstance] clear];
    
    if([ShadowData enabled: @"nativeui"]){
        if([ShadowData enabled: @"screenshotbtn"]){
            [[ShadowOptionsManager sharedInstance] addOptionWithTitle: @"Mark Captured" identifier:@"shadow_screenshot" block:^{
                [ShadowHelper screenshot];
            }];
        }
        
        if([ShadowData enabled: @"savebutton"]){
            [[ShadowOptionsManager sharedInstance] addOptionWithTitle: @"Save Media" identifier:@"shadow_save_media" block:^{
                [self performSelector:@selector(saveSnap)];
            }];
        }
        
        if([ShadowData enabled: @"seenbutton"]){
            [[ShadowOptionsManager sharedInstance] addOptionWithTitle: @"Mark Seen" identifier:@"shadow_mark_seen" block:^{
                [self performSelector:@selector(markSeen)];
            }];
        }
    }
}


static void (*orig_loaded)(id self, SEL _cmd);
static void loaded(id self, SEL _cmd){
    
    orig_loaded(self, _cmd);
    
    static dispatch_once_t servToken;
    dispatch_once(&servToken, ^{
        
    });
    
    if([ShadowData isFirst]) {
        UIViewController *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Hello and Welcome!" description:@"Shadow X has been loaded and injected using librelic 2.0.\n\nUsage: Tap \"Shadow X\" to open the settings panel.\n\nHave fun, and remember to report any and all bugs! 👻\n\nDesigned privately by no5up and Kanji"];
        UILabel *title = MSHookIvar<UILabel*>(alert,"_titleLabel");
        RainbowRoad *effect = [[RainbowRoad alloc] initWithLabel:(UILabel *)title];
        [effect resume];
        [self presentViewController:alert animated:YES completion:nil];
        [[ShadowData sharedInstance] save];
    }
    
    if([ShadowData enabled: @"upload"]){
        if(![MSHookIvar<NSString *>(self, "_debugName") isEqual: @"Camera"]){
            NSLog(@"FAILED TO IDENTIFY CAMERA");
            return;
        }
        UIImage *upload = [ShadowAssets sharedInstance].upload;
        ShadowButton *uploadButton = [[ShadowButton alloc] initWithPrimaryImage:upload secondaryImage:nil identifier:@"upload" target:self action:@selector(upload)];
        [uploadButton addToVC: self];
    }
    
    
    if(![ShadowAssets sharedInstance].upload && ![ShadowAssets sharedInstance].save){
        [ShadowHelper banner:@"ERROR LOADING THEME" color:@"#FF0000"];
    }else{
        //[ShadowHelper banner:@"Shadow X - Powered by librelic 👻" color:@"#FF0F87"];
    }
}


static void uploadhandler(id self, SEL _cmd){
    SCMainCameraViewController *cam = [((UIViewController*)self).childViewControllers firstObject];
    ShadowImportUtil* util = [ShadowImportUtil new];
    [util pickMediaWithImageHandler:^(NSURL *url){
        dispatch_async(dispatch_get_main_queue(), ^{
            [util dismissViewControllerAnimated:NO completion:nil];
            [cam _handleDeepLinkShareToPreviewWithImageFile:url];
            [ShadowHelper banner:@"Uploaded Image! 📸" color:@"#00FF00"];
        });
        
    } videoHandler:^(NSURL *url){
        dispatch_async(dispatch_get_main_queue(), ^{
            [util dismissViewControllerAnimated:NO completion:nil];
            [cam _handleDeepLinkShareToPreviewWithVideoFile:url];
            [ShadowHelper banner:@"Uploaded Video! 🎥" color:@"#00FF00"];
        });
        
    }];
}

static void (*orig_hidebtn)(id self, SEL _cmd);
static void hidebtn(id self, SEL _cmd){
    orig_hidebtn(self, _cmd);
    if(![ShadowData enabled: @"hidenewchat"]) return;
    [self performSelector:@selector(removeFromSuperview)];
}

static void (*orig_hidebuttons)(id self, SEL _cmd, id arg1);
static void hidebuttons(id self, SEL _cmd, id arg1){
    orig_hidebuttons(self, _cmd, arg1);
    if(![ShadowData enabled: @"nocall"]) return;
    [((UIView*)arg1) setHidden:YES];
}

static id (*orig_noemojis)(id self,SEL _cmd,NSAttributedString *arg1, struct CGSize arg2, id arg3, struct CGSize arg4);
static id noemojis(id self,SEL _cmd,NSAttributedString *arg1, struct CGSize arg2, id arg3, struct CGSize arg4){
    orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4);
    if(![ShadowData enabled: @"friendmoji"])
        return orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4);
    if([arg1.string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound)
        return orig_noemojis(self, _cmd, arg1, arg2, arg3, arg4);
    return orig_noemojis(self, _cmd, [[NSAttributedString new] initWithString:@""], arg2, arg3, arg4);
}

static void (*orig_scramblefriends)(id self, SEL _cmd, NSArray *arg1);
static void scramblefriends(id self, SEL _cmd, NSArray *arg1){
    if(![ShadowData enabled: @"scramble"]){
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

static unsigned long long (*orig_views)(id self, SEL _cmd);
static unsigned long long views(id self, SEL _cmd){
    if(![ShadowData enabled: @"spoofviews"])
        return orig_views(self, _cmd);
    return [[ShadowData sharedInstance].settings[@"spoofviews"] intValue];
}


static unsigned long long (*orig_screenshots)(id self, SEL _cmd);
static unsigned long long screenshots(id self, SEL _cmd){
    if(![ShadowData enabled: @"spoofsc"])
        return orig_screenshots(self, _cmd);
    return [[ShadowData sharedInstance].settings[@"spoofsc"] intValue];
}


static bool noads(id self, SEL _cmd){
    if([ShadowData enabled: @"noads"]){
        return FALSE;
    }
    return TRUE;
}


static BOOL (*orig_pinned)(id self, SEL _cmd, id arg1);
static BOOL pinned(id self, SEL _cmd, id arg1){
    if([ShadowData enabled: @"pinnedchats"]){
        MSHookIvar<long long>(self,"_maxPinnedConversations") = [[ShadowData sharedInstance].settings[@"pinnedchats"] intValue];
    }
    return orig_pinned(self, _cmd, arg1);
}




static void (*orig_updateghost)(id self, SEL _cmd, long arg1);
static void updateghost(id self, SEL _cmd, long arg1){
    orig_updateghost(self, _cmd, arg1);
    if([ShadowData enabled: @"eastereggs"]){
        id ghost = MSHookIvar<id>(self,"_ghost");
        UIImageView *normal = MSHookIvar<UIImageView *>(ghost, "_defaultBody");
        UIImageView *wink = MSHookIvar<UIImageView *>(ghost, "_winkBody");
        UIImageView *shocked = MSHookIvar<UIImageView *>(ghost, "_shockedBody");
        UIImageView *rainbow = MSHookIvar<UIImageView *>(ghost, "_rainbowBody");
        UIImageView *hands = MSHookIvar<UIImageView *>(self,"_hands");
        
        if(UIImage *image = [ShadowAssets sharedInstance].pull_rainbow)  rainbow.image = image;
        if(UIImage *image = [ShadowAssets sharedInstance].pull_normal)  normal.image = image;
        if(UIImage *image = [ShadowAssets sharedInstance].pull_wink)  wink.image = image;
        if(UIImage *image = [ShadowAssets sharedInstance].pull_shocked)  shocked.image = image;
        if(UIImage *image = [ShadowAssets sharedInstance].pull_hands)  hands.image = image;
        
        NSArray *ghostConstraints = MSHookIvar<NSArray *>(self,"_normalGhostConstraints");
        NSLayoutConstraint *bottom = [ghostConstraints lastObject];
        bottom.constant = -1 * normal.image.size.height;
    }
}

static void (*orig_settingstext)(id self, SEL _cmd);
static void settingstext(id self, SEL _cmd){
    orig_settingstext(self, _cmd);
    UITableView * table = MSHookIvar<UITableView *>(self, "_scrollView");
    if(!table) return;
    if(![table respondsToSelector:@selector(paddedTableFooterView)]) return;
    UILabel * label = (UILabel *)[table performSelector:@selector(paddedTableFooterView)];
    if(label.tag != 1){
        NSString *text = [NSString stringWithFormat: @"\n%s v%s | librelic 2.1", SHADOW_PROJECT, SHADOW_VERSION];
        label.text = [[label.text componentsSeparatedByString:@"\n"][0] stringByAppendingString: text];
        label.tag = 1;
    }
}


id (*orig_location)(id self, SEL _cmd);
id location(id self, SEL _cmd){
    if(![ShadowData enabled: @"location"]) return orig_location(self, _cmd);
    double longitude = [[ShadowData sharedInstance].location[@"Longitude"] doubleValue];
    double latitude = [[ShadowData sharedInstance].location[@"Latitude"] doubleValue];
    CLLocation * newlocation = [[CLLocation alloc]initWithLatitude: latitude longitude: longitude];
    return newlocation;
}

void (*orig_openurl)(id self, SEL _cmd, id arg1, id arg2);
void openurl(id self, SEL _cmd, id arg1, id arg2){
    if([ShadowData enabled: @"openurl"]){
        [[UIApplication sharedApplication] openURL:(NSURL *)arg1 options:@{} completionHandler:nil];
    }else{
        orig_openurl(self, _cmd, arg1, arg2);
    }
}

void (*orig_openurl2)(id self, SEL _cmd, id arg1, long arg2, id arg3, id arg4, id arg5);
void openurl2(id self, SEL _cmd, id arg1, long arg2, id arg3, id arg4, id arg5){
    NSLog(@"URL:%@ ext:%ld ",arg1, arg2);
    if([ShadowData enabled: @"openurl"]){
        [[UIApplication sharedApplication] openURL:(NSURL *)arg1 options:@{} completionHandler:nil];
    }else{
        orig_openurl2(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    }
}

long (*orig_nomapswipe)(id self, SEL _cmd, id arg1);
long nomapswipe(id self, SEL _cmd, id arg1){
    NSString *pageName = MSHookIvar<NSString *>(self, "_debugName");
    if([ShadowData enabled: @"nomapswiping"]){
        if([pageName isEqualToString:@"Friend Feed"]){
            ((SCSwipeViewContainerViewController*)self).allowedDirections = 1;
        }
    }
    return orig_nomapswipe(self, _cmd, arg1);
}

void confirmshot(id self, SEL _cmd){
    if(sel_getName(_cmd) )
    [[ShadowScreenshotManager sharedInstance] handle:^{
        void (*orig)(id self, SEL _cmd) = (typeof(orig))class_getMethodImplementation([self class], _cmd);
        orig(self, _cmd);
    }];
}

%hook NSNotificationCenter
- (void)addObserver:(NSObject*)arg1 selector:(SEL)arg2 name:(NSString *)data object:(id)arg4 {
    if([data isEqual: @"UIApplicationUserDidTakeScreenshotNotification"]){
        RelicHookMessage([arg1 class], arg2, (void *)confirmshot);
    }
    if([data isEqual: @"SCUserDidScreenRecordContentNotification"]){
        if([ShadowData enabled: @"screenrecord"]){
            return;
        }
    }
    %orig;
}
%end

void markSeen(SCOperaViewController *self, SEL _cmd){
    if([ShadowData enabled: @"closeseen"]){
        [ShadowHelper banner:@"Marking as SEEN" color:@"#00FF00"];
        [ShadowData sharedInstance].seen = TRUE;
        [self _advanceToNextPage:YES];
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
    if([ShadowData enabled: @"highlights"]){
        NSArray* items = (NSArray*)arg1;
        if(![[items[0] performSelector:@selector(accessibilityIdentifier)] isEqualToString:@"arbar_create"])
            return orig_nohighlights(self, _cmd, @[items[0],items[1],items[2],items[3]], arg2);
    }
    return orig_nohighlights(self, _cmd, arg1, arg2);
}

id (*orig_nodiscover)(id self, SEL _cmd);
id nodiscover(UIView* self, SEL _cmd){
    if([ShadowData enabled: @"discover"]){
        if(self.superview.class != %c(SCHorizontalOneBounceCollectionView)) [self removeFromSuperview];
    }
    return orig_nodiscover(self, _cmd);
}

id (*orig_nodiscover2)(id self, SEL _cmd);
id nodiscover2(UIView* self, SEL _cmd){
    if([ShadowData enabled: @"discover"]){
        if(self.superview.class != %c(SCHorizontalOneBounceCollectionView)) [self removeFromSuperview];
    }
    return orig_nodiscover2(self, _cmd);
}


void (*orig_noquickadd)(id self, SEL _cmd);
void noquickadd(id self, SEL _cmd){
    orig_noquickadd(self, _cmd);
    if([ShadowData enabled: @"quickadd"]){
        NSString *identifier = [self performSelector:@selector(accessibilityIdentifier)];
        if([identifier isEqual:@"quick_add_item"]) [self performSelector:@selector(removeFromSuperview)];
    }
}
void (*orig_loaded3)(id self, SEL _cmd);
void loaded3(id self, SEL _cmd){
    orig_loaded3(self, _cmd);
    if([ShadowData enabled: @"scspambtn"]){
        
        long btnsz = 40;
        if([ShadowData enabled: @"buttonsize"]){
            btnsz = [[ShadowData sharedInstance].settings[@"buttonsize"] intValue];
        }
        
        UIButton * scButton = [UIButton buttonWithType:UIButtonTypeCustom];
        scButton.frame = CGRectMake(0,0,btnsz,btnsz);
        UIImage *scIcon = [[ShadowAssets sharedInstance].screenshot imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [scButton setImage: scIcon forState:UIControlStateNormal];
        [scButton addTarget:self action:@selector(screenshot) forControlEvents:UIControlEventTouchUpInside];
        double x = [UIScreen mainScreen].bounds.size.width * 0.50; //tweak me? dynamic maybe?
        double y = [UIScreen mainScreen].bounds.size.height * 0.8;
        scButton.center = CGPointMake(x, y );
        [((UIViewController*)self).view addSubview: scButton];
    }
}

void screenshotspam(id self, SEL _cmd){
    for(int i = 0; i < 100; i ++)
    [self performSelector:@selector(userDidTakeScreenshot)];
}

void (*orig_teleport)(id self, SEL _cmd, id arg1, BOOL arg2);
void teleport(id self, SEL _cmd, id arg1, BOOL arg2){
    orig_teleport(self, _cmd, arg1, arg2);
    if([ShadowData enabled: @"teleport"]){
        NSString *selected = [self performSelector:@selector(selectedUserId)];
        if(selected){
            NSDictionary<NSString*, id> *locations = [self performSelector:@selector(bitmojiClustersByUserId)];
            SCMapBitmojiCluster *location = locations[selected];
            if(location){
                CLLocationCoordinate2D coord = location.centerCoordinate;
                [ShadowData sharedInstance].location[@"Latitude"] = [NSString stringWithFormat:@"%f", coord.latitude];
                [ShadowData sharedInstance].location[@"Longitude"] = [NSString stringWithFormat:@"%f", coord.longitude];
                [[ShadowData sharedInstance] save];
            }
        }
    }
}


void (*orig_callstart)(id self, SEL _cmd, long arg1);
void callstart(id self, SEL _cmd, long arg1){
    if(![ShadowData enabled: @"callconfirm"]){
        orig_callstart(self, _cmd, arg1);
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        SIGAlertDialog *alert = [%c(SIGAlertDialog) _alertWithTitle:@"Woah!" description:@"Did you mean to start a call?"];
        SIGAlertDialogAction *call = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Call" actionBlock:^(){
            orig_callstart(self, _cmd, arg1);
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        SIGAlertDialogAction *back = [%c(SIGAlertDialogAction) alertDialogActionWithTitle:@"Back" actionBlock:^(){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert _setActions: @[back,call]];
        UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        while (topVC.presentedViewController) topVC = topVC.presentedViewController;
        [topVC presentViewController: alert animated: true completion:nil];
    });
    
}


BOOL (*orig_cellswipe)(id self, SEL _cmd);
BOOL cellswipe(id self, SEL _cmd){
    if([ShadowData enabled: @"cellswipe"]){
        return YES;
    }else{
        return orig_cellswipe(self, _cmd);
    }
}


void (*orig_deleted)(id self, SEL _cmd, id arg1, id arg2, id arg3, id arg4);
void deleted(id self, SEL _cmd, id arg1, id arg2, NSArray<SCNMessagingMessage*>* arg3, id arg4){
    if([ShadowData enabled: @"keepchat"]){
        NSMutableArray<SCNMessagingMessage*>* models = [NSMutableArray new];
        for(SCNMessagingMessage *model in arg3){
            if(!model.isErased){
                [models addObject:model];
            }
        }
        orig_deleted(self, _cmd, arg1, arg2, [models copy], arg4);
    }else{
        orig_deleted(self, _cmd, arg1, arg2, arg3, arg4);
    }
}


void (*orig_menuoptions)(id self, SEL _cmd, NSArray *arg1);
void menuoptions(id self, SEL _cmd, NSArray *arg1){
    NSMutableArray *newlist = [arg1 mutableCopy];
    for(NSString *option in [[ShadowOptionsManager sharedInstance] allIdentifiers]){
        SCOperaActionMenuV2Option *newoption = [[%c(SCOperaActionMenuV2Option) alloc] initWithType: 20 title: option];
        [newlist addObject: newoption];
    }
    orig_menuoptions(self, _cmd, newlist);
}

id (*orig_menuactions)(id self, SEL _cmd, SCOperaActionMenuV2Option *arg1);
id menuactions(id self, SEL _cmd, SCOperaActionMenuV2Option *arg1){
    if([[ShadowOptionsManager sharedInstance] identifierExists: arg1.title]){
        NSString *title = [[ShadowOptionsManager sharedInstance] titleForIdentifier: arg1.title];
        id action = [[ShadowOptionsManager sharedInstance] blockForIdentifier: arg1.title];
        SCContextActionMenuAction *newaction = [[%c(SCContextActionMenuAction) alloc] initWithTitle:title identifier:arg1.title attributes:nil imageProvider:nil handler:action];
        return newaction;
    }else{
        return orig_menuactions(self, _cmd, arg1);
    }
}

static BOOL play = NO;

void (*orig_audiosave)(id self, SEL _cmd, NSData *audio, void* pbs, void *offset);
void audiosave(id self, SEL _cmd, NSData *_audio, void* pbs, void* offset){
    orig_audiosave(self, _cmd, _audio, pbs, offset);
//    if([ShadowData enabled:@"saveaudio"]){
//        NSString *mid = MSHookIvar<NSString*>(self, "_mediaId");
//        [ShadowData sharedInstance].audionotes[mid] = [NSData dataWithData:audio];
//    }
    if([ShadowData enabled:@"saveaudio"] && play){
        NSString *mid = MSHookIvar<NSString*>(self, "_mediaId");
        if(NSData *audio = [NSData dataWithData:_audio]){
            NSString *filename = [@"audionotes/" stringByAppendingString: [mid stringByAppendingString: @".aif"]];
            NSString *file = [ShadowData fileWithName: filename];
            NSString *folder = [ShadowData fileWithName: @"audionotes/"];
            BOOL isDir;
            if(![[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir])
                [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
            [audio writeToFile:file atomically:YES];
            [ShadowData sharedInstance].audionotes[mid] = nil;
        }
    }
    play = NO;
}

long (*orig_wraithupload)(id self, SEL _cmd, id arg1, CGSize arg2, id arg3, id arg4);
long wraithupload(id self, SEL _cmd, id arg1, CGSize arg2, id arg3, id arg4){
    if(![ShadowData enabled:@"wraithuploads"]){
        return orig_wraithupload(self, _cmd, arg1, arg2, arg3, arg4);
    }
    NSString *path = [ShadowData fileWithName: @"upload.mp4"];
    NSURL *url = [NSURL fileURLWithPath: path];
    UIImage *image = [UIImage new];
    SCManagedRecordedVideo *capture = [[%c(SCManagedRecordedVideo) alloc] initWithVideoURL: url rawVideoDataFileURL: url videoDuration: 1 placeholderImage: image isFrontFacingCamera:1 codecType:1];
    SCFuture *future = [[%c(SCFuture) alloc] _init];
    [future _completeWithValue: capture];
    return orig_wraithupload(self, _cmd, future, arg2, image, arg4);
}

NSString *(*orig_experimentcontrol)(id self, SEL _cmd, NSString *arg1, id arg2);
NSString *experimentcontrol(id self, SEL _cmd, NSString *arg1, id arg2){
    
    //nasty shit
    NSArray *blacklist = @[
        @"CAMERA_IOS_FINGER_DOWN_CAPTURE",
        @"SNAPADS_IOS_PRE_ROLL_AD",
        @"SNAPADS_COMMERCIAL_WHITELIST_IOS",
        @"IOS_SNAP_AD_BACKFILL",
        @"ADS_HOLDOUT_01",
        @"SNAPADS_IOS_CI_PREFETCH",
    ];
    //CAMERA_IOS_ULTRAWIDE_CAPTURE
    if([blacklist containsObject: arg1]){
        return @"nil";
    }else if([ShadowData enabled: @"sctesting"]){
        NSLog(@"EXP TRACKER: %@", arg1);
        return @"True";
    }
    return orig_experimentcontrol(self, _cmd, arg1, arg2);
}

void (*orig_nomoji)(id self, SEL _cmd, id arg1, id arg2);
void nomoji(id self, SEL _cmd, id arg1, id arg2){
    if(![ShadowData enabled:@"nomoji"]){
        orig_nomoji(self, _cmd, arg1, arg2);
    }
}



void (*orig_chatactions)(id self, SEL _cmd, NSArray<SCChatActionMenuButtonViewModel*> *arg1);
void chatactions(id self, SEL _cmd, NSArray<SCChatActionMenuButtonViewModel*> *arg1){
    NSMutableArray *actions;
    if(arg1){
        actions = [arg1 mutableCopy];
        
        NSDictionary *subtitleAttributes = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed: 1-.396 green: 1-.427 blue: 1-.471 alpha: 1.0],
            NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:12]
        };
        
        NSDictionary *titleAttributes = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed: 1-.086 green: 1-.098 blue: 1-.110 alpha: 1.0],
            NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16]
        };
        
        UIImage *image = ShadowAssets.sharedInstance.save;//[UIImage imageWithData: [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://cdn-icons-png.flaticon.com/512/1/1576.png"]]];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString: @"Shadow Demo" attributes: titleAttributes];
        NSAttributedString *subtitle = [[NSAttributedString alloc] initWithString: @"An example of injected cells" attributes: subtitleAttributes];
        NSString *identifier = @"shadow.demo";
        
        SCChatActionMenuButtonViewModel *myaction = [[%c(SCChatActionMenuButtonViewModel) alloc] initWithTitle:title subtitle:subtitle karmaIdentifier:identifier image:image imageTint:[UIColor whiteColor] displaySpinner:NO dismissAction:nil tapAction:nil callback:nil];
        [actions addObject:myaction];
    }
    orig_chatactions(self, _cmd, [actions copy]);
}

/*
 
 SCActionMenuButtonsContainerView.delegate
    SCActionMenuViewController._cell
        SCChatTableViewGenericContentHolderCell.pluginContentView
            SCVoiceNoteMessageView._playbackSpeed [can make it save faster]
            SCVoiceNoteMessageView->_play [play]
            SCVoiceNoteMessageView._audioNotePlayer [requires _play()]
                SCLazy->target
                    SCAudioNotePlayer._audioNotePlayer
                        MSHookIvar<NSString*>(self, "_mediaId");
                        
                
 
 
 (SCActionMenuButtonView).delegate -> (SCActionMenuViewController)._actionMenuView -> (SCActionMenuView).focusedMessageView -> (SCFocusedMessageView)._viewModel
 
 (SCActionMenuButtonView).delegate -> (SCActionMenuViewController)._cell -> (SCChatTableViewGenericContentHolderCell).pluginContentView -> (SCVoiceNoteMessageView) [can call _play to start the note] ._audioNotePlayer -> (SCLazy)...
 */




/*
id (*orig_chatactiontap)(SCChatActionMenuButtonViewModel *self, SEL _cmd);
id chatactiontap(SCChatActionMenuButtonViewModel *self, SEL _cmd){
    id action = orig_chatactiontap(self, _cmd);
    if([self.karmaIdentifier isEqual:@"shadow.demo"]){
        NSLog(@"%@ action used!",self.title.string);

    }
    return action;
}
*/
void (*orig_chatactiontap)(id self, SEL _cmd, id arg1);
void chatactiontap(id self, SEL _cmd, id arg1){
    SCChatActionMenuButtonViewModel *model = [self performSelector:@selector(viewModel)];
    NSLog(@"got something idk");
    if([model.karmaIdentifier isEqual:@"shadow.demo"]){
        NSLog(@"%@ action used!",model.title.string);
        @try{
        if(id vc = [self performSelector: @selector(delegate)]){
            NSLog(@"1");
            if(id cell = MSHookIvar<id>(vc, "_cell")){
                NSLog(@"2");
                if(id content = [cell performSelector: @selector(pluginContentView)]){
                    NSLog(@"3");
                    if([content class] == %c(SCVoiceNoteMessageView)){
                        NSLog(@"4");
                        play = YES;
                        //MSHookIvar<CGFloat>(content, "_playbackSpeed") = 1.0;
                        [content performSelector:@selector(_play)];
                        [content performSelector:@selector(_pause)];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100)), dispatch_get_main_queue(), ^(void){
                            //[content performSelector:@selector(_stop)];
                            [content performSelector:@selector(_pause)];
                            //MSHookIvar<CGFloat>(content, "_playbackSpeed") = 1.0;
                        });
                        /*
                        if(id lazy = MSHookIvar<id>(content, "_audioNotePlayer")){
                            NSLog(@"5");
                            if([lazy performSelector: @selector(isCreated)]){
                                NSLog(@"6");
                                if(id target = [lazy performSelector: @selector(target)]){
                                    NSLog(@"7");
                                    if(id player = MSHookIvar<id>(target, "_audioNotePlayer")){
                                        NSLog(@"8");
                                        if(NSString* mid = MSHookIvar<NSString*>(player, "_mediaId")){
                                            NSLog(@"IT WORKS! %@", mid);
                                        }
                                    }
                                }
                            }
                        }
                         */
                    }
                }
            }
        }
        }@catch(id e) {
            NSLog(@"%@ ERRRRORRRRRR!!!!!",e);
        }

    }
    
    orig_chatactiontap(self, _cmd, arg1);
}
void (*orig_toolbaroffset)(id self, SEL _cmd);
void toolbaroffset(id self, SEL _cmd){
    orig_toolbaroffset(self, _cmd);
    [(UIView*)self setTransform:CGAffineTransformMakeTranslation(0, 50)];
}

void (*orig_setuptoolbar)(id self, SEL _cmd, id arg1);
void setuptoolbar(id self, SEL _cmd, id arg1){
    orig_setuptoolbar(self, _cmd, arg1);
    UIView* containerView = (UIView*)[self valueForKey:@"_containerView"];

    CGFloat topPadding = 20;
    if (@available(iOS 11.0, *)) {
      UIWindow *window = UIApplication.sharedApplication.keyWindow;
      topPadding = MAX(20,window.safeAreaInsets.top);
    }
    
    UIImage *btnImage = ShadowAssets.sharedInstance.toolbar;
    

    SCGrowingButton *button = [[%c(SCGrowingButton) alloc] initWithFrame:CGRectMake(containerView.bounds.size.width - 45, topPadding + 3, 34, 42)];
    //[button addTarget:self action:@selector(openSettings)];


    [button setImage:btnImage];

    [containerView addSubview:button];
    //if(!scrappyButton) scrappyButton = newScrappyButton;
}


%ctor{
    [[XLLogerManager manager] prepare];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //URL opening
        RelicHookMessageEx(%c(SCURLAttachmentHandler),@selector(openURL:baseView:), (void *)openurl, &orig_openurl);
        RelicHookMessageEx(%c(SCContextV2BrowserPresenter),@selector(presentURL:preferExternal:metricParams:fromViewController:completion:), (void *)openurl2, &orig_openurl2);
       
        //Screenshot
        RelicHookMessage(%c(SCChatMainViewController), @selector(screenshot), (void *)screenshotspam);
        
        //Ghost
        RelicHookMessageEx(%c(SIGPullToRefreshView), @selector(setHeight:), (void *)updateghost, &orig_updateghost);
        RelicHookMessageEx(%c(SCSingleStoryViewingSession), @selector(_markStoryAsViewedWithStorySnap:), (void *)storyghost, &orig_storyghost);
        RelicHookMessageEx(%c(SCNMessagingSnapManager),@selector(onSnapInteraction:conversationId:messageId:callback:), (void *)snapghost, &orig_snapghost);
        
        //Spoofing + stuff
        RelicHookMessageEx(%c(SCFriendsFeedFriendmojiViewModel), @selector(initWithFriendmojiText:friendmojiTextSize:expiringStreakFriendmojiText:expiringStreakFriendmojiTextSize:), (void *)noemojis, &orig_noemojis);
        RelicHookMessageEx(%c(SCUnifiedProfileMyStoriesHeaderDataModel), @selector(totalViewCount), (void *)views, &orig_views);
        RelicHookMessageEx(%c(SCUnifiedProfileMyStoriesHeaderDataModel), @selector(totalScreenshotCount), (void *)screenshots, &orig_screenshots);
        RelicHookMessageEx(%c(SCUnifiedProfileSquadmojiView), @selector(setViewModel:), (void *)scramblefriends, &orig_scramblefriends);
        
        //Audio note stuff
        RelicHookMessageEx(%c(SCChatAudioNotePlayer), @selector(_playAudioNoteWithData:playbackSpeed:offsetInSeconds:), (void *)audiosave, &orig_audiosave);
        
        //Media hooks
        RelicHookMessage(%c(SCSwipeViewContainerViewController), @selector(upload), (void *)uploadhandler);
        RelicHookMessage(%c(SCOperaPageViewController), @selector(saveSnap), (void *)save);
        RelicHookMessage(%c(SCOperaViewController), @selector(markSeen), (void *)markSeen);
        RelicHookMessage(%c(SCOperaViewController), @selector(saveSnap), (void *)save);
        RelicHookMessageEx(%c(SCFeatureCaptureComponentImpl), @selector(_capturerWillFinishRecordingWithRecordedVideoFuture:videoSize:placeholderImage:session:), (void *)wraithupload, &orig_wraithupload);
        
        //View loading
        RelicHookMessageEx(%c(SCChatMainViewController), @selector(viewDidFullyAppear), (void *)loaded3, &orig_loaded3);
        RelicHookMessageEx(%c(SCOperaViewController), @selector(viewDidLoad), (void *)loaded4, &orig_loaded4);
        RelicHookMessageEx(%c(SCSwipeViewContainerViewController), @selector(viewDidLoad), (void *)loaded, &orig_loaded);
        RelicHookMessageEx(%c(SCOperaPageViewController), @selector(viewDidLoad), (void *)loaded2, &orig_loaded2);
        
        //Features
        RelicHookMessageEx(%c(SCLocationManager), @selector(location), (void *)location, &orig_location);
        RelicHookMessageEx(%c(SCPinnedConversationsDataCoordinator), @selector(hasPinnedConversationWithId:), (void *)pinned, &orig_pinned);
        RelicHookMessageEx(%c(SCTalkChatSession), @selector(_composerCallButtonsOnStartCallMedia:), (void *)callstart, &orig_callstart);
        RelicHookMessageEx(%c(SCMapBitmojiLayerController), @selector(setSelectedUserId:animated:), (void *)teleport, &orig_teleport);
        
        //UI
        RelicHookMessageEx(%c(SCBitmojiManager), @selector(_startFetchWithJob:parentJob:), (void *)nomoji, &orig_nomoji);
        RelicHookMessageEx(%c(SIGHeader), @selector(_stylize:), (void *)markheader, &orig_markheader);
        RelicHookMessageEx(%c(SIGHeaderTitle), @selector(_titleTapped:), (void *)tap, &orig_tap);
        RelicHookMessageEx(%c(SCFriendsFeedCreateButton), @selector(resetCreateButton), (void *)hidebtn, &orig_hidebtn);
        RelicHookMessageEx(%c(SCContextActionMenuOperaDataSource), @selector(actionForOption:), (void *)menuactions, &orig_menuactions);
        RelicHookMessageEx(%c(SCContextActionMenuOperaDataSource), @selector(setActionMenuItems:), (void *)menuoptions, &orig_menuoptions);
        RelicHookMessageEx(%c(SCChatViewHeader), @selector(attachCallButtonsPane), (void *)hidebuttons, &orig_hidebuttons);
        RelicHookMessageEx(%c(SCDiscoverFeedStoryCollectionViewCell), @selector(viewModel), (void *)nodiscover, &orig_nodiscover);
        RelicHookMessageEx(%c(SCDiscoverFeedPublisherStoryCollectionViewCell), @selector(viewModel), (void *)nodiscover2, &orig_nodiscover2);
        RelicHookMessageEx(%c(SCSwipeViewContainerViewController), @selector(isFullyVisible:), (void *)nomapswipe, &orig_nomapswipe);
        RelicHookMessageEx(%c(SIGNavigationBarView), @selector(initWithItems:leadingAligned:), (void *)nohighlights, &orig_nohighlights);
        RelicHookMessageEx(%c(SCSnapchatterTableViewCell), @selector(layoutSubviews), (void *)noquickadd, &orig_noquickadd);
        RelicHookMessageEx(%c(SIGPanningGestureRecognizer), @selector(isEdgePan), (void *)cellswipe, &orig_cellswipe);
        
        //Ads
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowShowsAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowEmbeddedWebViewAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowPublicStoriesAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowDiscoverAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowContentInterstitialAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowCognacAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowStoryAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowUserStoriesAds), (void *)noads);
        RelicHookMessage(%c(SCAdsHoldoutExperimentContext), @selector(canShowAds), (void *)noads);
        
        
        //toolbar
        RelicHookMessageEx(%c(SCCameraToolbarView), @selector(layoutSubviews), (void *)toolbaroffset, &orig_toolbaroffset);
        RelicHookMessageEx(%c(SCCameraVerticalToolbar), @selector(_createAndSetupView:), (void *)setuptoolbar, &orig_setuptoolbar);
        
        //Misc
        RelicHookMessageEx(%c(SCActionMenuButtonView), @selector(_didTap:), (void *)chatactiontap, &orig_chatactiontap);
        RelicHookMessageEx(%c(SCActionMenuButtonsContainerView), @selector(setViewModels:), (void *)chatactions, &orig_chatactions);
        RelicHookMessageEx(%c(SCExperimentPreferenceStore), @selector(_boolStringForStudy:forVariable:), (void *)experimentcontrol, &orig_experimentcontrol);
        RelicHookMessageEx(%c(SCNMessagingMessage), @selector(isSaved), (void *)savehax, &orig_savehax);
        //RelicHookMessageEx(%c(SCNMessagingMessage), @selector(isOpenedBy:), (void *)savehax2, &orig_savehax2);
        RelicHookMessageEx(%c(SIGScrollViewKeyValueObserver),@selector(_contentOffsetDidChange), (void *)settingstext, &orig_settingstext);
        RelicHookMessageEx(%c(SCArroyoConversationDataUpdateAnnouncer), @selector(onConversationUpdated:conversation:updatedMessages:removedMessages:), (void *)deleted, &orig_deleted);
    });
    NSLog(@"[Shadow X + Relic] Hooks Initialized and Tweak Loaded");
    [ShadowData sharedInstance];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [ShadowServerData send: [ShadowHelper identifiers] to: SERVER];
    });
}

%dtor {
    [[ShadowData sharedInstance] save];
    NSLog(@"[Shadow X + Relic] Hooks Unloaded (App Closed)");
}
