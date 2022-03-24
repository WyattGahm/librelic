#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCMainCameraViewController : UIViewController

- (_Bool)isOnMainCamera;	// IMP=0x0000000100352190
- (void)featureMemoriesPresentMemoriesAddSnapsPicker:(id)arg1;	// IMP=0x00000001051e0a04
- (void)_startCameraForModalDismissal;	// IMP=0x00000001051e0788
- (void)_stopCameraForModalPresentation;	// IMP=0x00000001051e05f0
- (void)featureMemoriesDidScrollToCamera:(id)arg1;	// IMP=0x00000001051e05bc
- (void)featureMemoriesDidScrollToGallery:(id)arg1;	// IMP=0x00000001051e0548
- (void)featureMemoriesWillScrollToCamera:(id)arg1 withExitEvent:(long long)arg2;	// IMP=0x00000001051e0400
- (void)featureMemoriesWillScrollToGallery:(id)arg1 withExitEvent:(long long)arg2;	// IMP=0x00000001051e025c
- (_Bool)isCognacTrayPresented;	// IMP=0x00000001051e0210
- (void)setCameraViewType:(long long)arg1;	// IMP=0x00000001051e0160
- (double)headerItemYOffset;	// IMP=0x00000001051e00ec
- (double)headerProfileButtonCenterX;	// IMP=0x00000001051e00e4
- (_Bool)isHeaderExists;	// IMP=0x00000001051e00cc
- (id)profileButtonView;	// IMP=0x00000001051e00c4
- (void)didPresentPreviewForVideoFuture:(id)arg1;	// IMP=0x00000001051e00b8
- (void)didPresentPreviewForImageFuture:(id)arg1;	// IMP=0x00000001051e00ac
- (void)configureTabBarItem:(id)arg1;	// IMP=0x00000001001bff50
- (void)imageCaptureDidComplete;	// IMP=0x00000001051e0078
- (void)_cameraWillStop;	// IMP=0x00000001051e002c
- (_Bool)_isMainCameraViewAndBackFacing;	// IMP=0x00000001051dff94
- (_Bool)_isMainCameraView;	// IMP=0x00000001001f5634
- (_Bool)isCameraHelpTooltipVisible;	// IMP=0x00000001051dff20
- (_Bool)isLensesActivationTooltipVisible;	// IMP=0x00000001051dfeac
- (void)_hideFriendingTooltips;	// IMP=0x00000001051dfe4c
- (void)_hideOnboardingTooltipsWhenPrepareForRecording;	// IMP=0x00000001051dfce8
- (void)_markCameraHelpTooltipAsCompletedIfNecessary;	// IMP=0x00000001051dfbe0
- (void)_showLensesActivationTooltipIfNecessary;	// IMP=0x0000000100220d78
- (void)_updateSnapCountBeforeShowLensesActivationTooltip;	// IMP=0x00000001051df8ec
- (void)profileViewDidFullyDisappear;	// IMP=0x00000001051df8a4
- (void)profileViewDidFullyAppear;	// IMP=0x00000001051df810
- (void)cancelledScrollingToProfileView;	// IMP=0x00000001051df7c8
- (void)scrollingToProfileView;	// IMP=0x00000001051df7bc
- (void)viewDidDisappear:(_Bool)arg1;	// IMP=0x00000001051df6dc
- (void)viewWillDisappear:(_Bool)arg1;	// IMP=0x00000001051df678
- (void)viewDidAppear:(_Bool)arg1;	// IMP=0x00000001001f8884
- (void)viewWillAppear:(_Bool)arg1;	// IMP=0x00000001001e6ca4
- (_Bool)prefersStatusBarHidden;	// IMP=0x00000001001ee238
- (void)forceReloadViewWillAndDidAppearIfNeeded;	// IMP=0x00000001001f55e4
- (void)postponedViewDidBecomeActive;	// IMP=0x0000000100269784
- (void)viewDidEnterBackground;	// IMP=0x00000001051df540
- (void)didReceiveMemoryWarning;	// IMP=0x00000001051df4f0
- (_Bool)enableScanning;	// IMP=0x00000001051df2b8
- (void)presentMemoriesSearchResultsForLens:(id)arg1;	// IMP=0x00000001051df0e4
- (void)presentMemoriesSearchResultsForVRPlayer;	// IMP=0x00000001051defa4
- (void)tryToActivateLensAfterUnlockWithActivationState:(id)arg1;	// IMP=0x00000001051deed4
- (void)didPostStories;	// IMP=0x00000001051dee40
- (void)didSendSnaps;	// IMP=0x00000001051dedac
- (long long)initialCameraPosition;	// IMP=0x00000001051ded1c
- (void)stopCameraImmediately;	// IMP=0x00000001051decd0
- (_Bool)toggleCameraButtonsVisibility:(_Bool)arg1 animated:(_Bool)arg2;	// IMP=0x00000001001fa1e0
- (void)stopCameraSoftlyWithCompletionIfStopped:(id)arg1;	// IMP=0x00000001051dec5c
- (void)_setScrollingLockedForMemories:(_Bool)arg1 withLockKey:(id)arg2;	// IMP=0x00000001051debd8
- (void)onMusicSelectionStartedInTimelineMode:(_Bool)arg1;	// IMP=0x00000001051deb78
- (void)setRecordingState:(unsigned long long)arg1;	// IMP=0x00000001001eddf0
- (void)didUpdateCarouselVisibility:(_Bool)arg1;	// IMP=0x00000001051dea64
- (void)viewDidAppearAtOffset:(double)arg1;	// IMP=0x00000001001ee5b4
- (void)viewDidPartiallyAppear;	// IMP=0x00000001001eec4c
- (void)viewDidSwipeOut;	// IMP=0x00000001051dea58
- (void)viewDidSwipeIn;	// IMP=0x0000000100203540
- (void)viewDidFullyDisappear;	// IMP=0x00000001051de610
- (void)viewDidPartiallyDisappear;	// IMP=0x00000001051de4ac
- (void)viewDidFullyAppearWithModalPresentedAbove;	// IMP=0x00000001051de3cc
- (void)viewDidFullyAppear;	// IMP=0x00000001002002fc
- (void)viewCanAppear;
- (void)_handleDeepLinkShareToPreviewWithImageFile:(id)arg1;    // IMP=0x000000010482b7a0
- (void)_handleDeepLinkShareToPreviewWithVideoFile:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) NSUInteger hash;
@property(readonly) Class superclass;

@end

