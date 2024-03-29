//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Sep 17 2017 16:24:48).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

@class NSLayoutConstraint, NSMutableArray, NSMutableDictionary, NSMutableSet, NSString, SCCameraOverlayView, SCCameraToolbarButton, SCCameraVerticalToolbarSplitter, SCDisposableObserver, SCDisposableObserverLifecycle, SCFeatureReference, SCFeatureSettingsService, SCLazy, SCUserSession, UIView, SCFeature;
@protocol SCCameraTimelineModeConfiguration, SCCameraVerticalToolbarConfiguration, SCCapturer, SCFeatureCameraToolbarDelegate;

@interface SCCameraVerticalToolbar : NSObject

- (void)showToolbarItem:(id)arg1 animated:(_Bool)arg2;	// IMP=0x00000001001fa944
- (void)removeToolbarItem:(id)arg1;	// IMP=0x00000001056ed6d4
- (void)prepareForCapture;	// IMP=0x00000001056ed678
- (void)_addToolbarItem:(id)arg1;	// IMP=0x00000001001cfe6c
- (void)addToolbarItem:(id)arg1;	// IMP=0x00000001001cfd38
- (void)reloadToolbar:(_Bool)arg1;	// IMP=0x00000001001d0dc4
- (void)dealloc;	// IMP=0x00000001056ed40c
- (id)initWithCapturer:(id)arg1 features:(id)arg2 applicationLifecycleEvents:(id)arg3 viewControllerLifecycleEvents:(id)arg4 mainCameraViewControllerLifecycleEvents:(id)arg5 cameraViewType:(long long)arg6 userSession:(id)arg7 cameraUserActionLogger:(id)arg8 verticalToolbarConfiguration:(id)arg9 timelineModeConfig:(id)arg10;	// IMP=0x00000001001ced6c

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

