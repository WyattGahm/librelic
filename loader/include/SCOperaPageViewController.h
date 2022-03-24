#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SCOperaShareableMedia.h"
#import "SCOperaActionBarContentProviding-Protocol.h"
#import "SCOperaBlockingViewControllerDelegate-Protocol.h"
#import "SCOperaFadeTransitionCompatibleViewController-Protocol.h"
#import "SCOperaLayerViewControllerMediaContainer-Protocol.h"
#import "SCOperaPageGestureRecognizersDelegate-Protocol.h"
#import "SCOperaPageableViewController-Protocol.h"
#import "SCOperaPageableViewControllerDelegate-Protocol.h"
#import "SCOperaPropertyUpdateModerator-Protocol.h"
#import "SCOperaShareableMediaItemsProviding-Protocol.h"
#import "SCTraceEnabled-Protocol.h"
#import "SCViewControllerTransitionAnimatorMaskable-Protocol.h"

@class NSDate, NSDictionary, NSHashTable, NSMutableArray, NSNumber, NSString, NSTimer, SCOperaConfiguration, SCOperaDependencies, SCOperaLayerViewControllerConfiguration, SCOperaPage, SCOperaPageActionBarContentView, SCOperaPageBackdropView, SCOperaPageGestureRecognizers, SCOperaPageLayersSnapshot, SCOperaViewModel, SCStopwatch, UIScrollView, UIView;
@protocol SCOperaEventAnnouncing, SCOperaLayerViewControllerManaging, SCOperaLegacySessionStateContaining, SCOperaPageViewControllerDelegate, SCOperaPageableViewControllerDelegate;

@interface SCOperaPageViewController : UIViewController <SCOperaPageableViewControllerDelegate, SCOperaBlockingViewControllerDelegate, UIScrollViewDelegate, SCTraceEnabled, SCOperaPageGestureRecognizersDelegate, SCOperaPageableViewController, SCOperaPropertyUpdateModerator, SCOperaFadeTransitionCompatibleViewController, SCOperaLayerViewControllerMediaContainer, SCViewControllerTransitionAnimatorMaskable, SCOperaShareableMediaItemsProviding, SCOperaActionBarContentProviding>
{
    id <SCOperaLayerViewControllerManaging> _layerViewControllerManager;
    UIScrollView *_scrollView;
    NSMutableArray *_blockingLayerVCs;
    NSTimer *_autoAdvanceTimer;
    double _autoAdvanceTimerTimeLeft;
    NSDictionary *_lastUpdatedLayerViewProperties;
    _Bool _didSendOpenViewLoadedEvent;
    NSDate *_openViewEventSentDate;
    NSHashTable *_layersNotifiedOfViewWillFullyAppear;
    NSHashTable *_layersNotifiedOfViewDidFullyAppear;
    _Bool _longPressEnabled;
    _Bool _ignoreLayoutForZoom;
    NSNumber *_fullyViewed;
    UIView *_actionMenuMaskLayerView;
    NSString *_mediaPlaybackSessionId;
    _Bool _pausedForAttachment;
    _Bool _isViewerDismissing;
    double _calculatedContainerViewYOffset;
    double _extraContainerViewYOffset;
    double _extraContainerViewXOffset;
    UIView *_attachmentBackgroundView;
    double _currentZoomInScaleForContextMenu;
    struct CGRect _currentContainerViewFrame;
    SCStopwatch *_pauseStopwatch;
    struct UIEdgeInsets _pageSafeAreaInsets;
    UIView *_blurOverlayView;
    SCOperaPageBackdropView *_backdropView;
    SCOperaPageActionBarContentView *_actionBarContentView;
    _Bool _overridePausedState;
    SCOperaPageGestureRecognizers *_operaPageGestureRecognizers;
    SCOperaPageLayersSnapshot *_pageLayersSnapshot;
    id <SCOperaLegacySessionStateContaining> _legacySessionStateContainer;
    SCOperaLayerViewControllerConfiguration *_layerViewControllerConfiguration;
    _Bool _didSendCloseViewEvent;
    _Bool _shouldNotReloadLayers;
    _Bool _hasRoundedCorners;
    SCOperaPage *_page;
    SCOperaViewModel *_viewModel;
    SCOperaConfiguration *_configuration;
    SCOperaDependencies *_operaDependencies;
    id <SCOperaEventAnnouncing> _eventAnnouncer;
    id <SCOperaPageViewControllerDelegate> _delegate;
    id <SCOperaPageableViewControllerDelegate> _pageableViewControllerDelegate;
    NSDictionary *_layerTypeToFloatingLayerVCs;
    UIView *_containerView;
}

+ (id)pageViewControllerWithConfiguration:(id)arg1 layerViewControllerConfiguration:(id)arg2 operaDependencies:(id)arg3 legacySessionStateContainer:(id)arg4 eventAnnouncer:(id)arg5 layerViewControllerManager:(id)arg6 viewModel:(id)arg7 delegate:(id)arg8;	// IMP=0x00000001066b48d4
@property(nonatomic) _Bool hasRoundedCorners; // @synthesize hasRoundedCorners=_hasRoundedCorners;
@property(readonly, nonatomic) UIView *containerView; // @synthesize containerView=_containerView;
@property(nonatomic) _Bool shouldNotReloadLayers; // @synthesize shouldNotReloadLayers=_shouldNotReloadLayers;
@property(nonatomic) _Bool didSendCloseViewEvent; // @synthesize didSendCloseViewEvent=_didSendCloseViewEvent;
@property(nonatomic) __weak NSDictionary *layerTypeToFloatingLayerVCs; // @synthesize layerTypeToFloatingLayerVCs=_layerTypeToFloatingLayerVCs;
@property(nonatomic) __weak id <SCOperaPageableViewControllerDelegate> pageableViewControllerDelegate; // @synthesize pageableViewControllerDelegate=_pageableViewControllerDelegate;
@property(readonly, nonatomic) __weak id <SCOperaPageViewControllerDelegate> delegate; // @synthesize delegate=_delegate;
@property(readonly, nonatomic) id <SCOperaEventAnnouncing> eventAnnouncer; // @synthesize eventAnnouncer=_eventAnnouncer;
@property(readonly, nonatomic) SCOperaDependencies *operaDependencies; // @synthesize operaDependencies=_operaDependencies;
@property(readonly, nonatomic) SCOperaConfiguration *configuration; // @synthesize configuration=_configuration;
@property(readonly, nonatomic) SCOperaViewModel *viewModel; // @synthesize viewModel=_viewModel;
@property(readonly, nonatomic) SCOperaPage *page; // @synthesize page=_page;
- (void)_displayContentBlockingMessageIfNeeded;	// IMP=0x00000001066c15a4
- (id)fadingViewsForFadeTransition;	// IMP=0x00000001066c13f0
- (id)movingViewsForFadeTransition;	// IMP=0x00000001066c123c
- (void)_removeCriticalModeContext;	// IMP=0x00000001066c1118
- (void)_addCriticalModeContext;	// IMP=0x00000001066c0ff4
- (void)_toggleCriticalMode;	// IMP=0x00000001066c0fa0
- (struct UIEdgeInsets)fromView:(id)arg1 edgeInsetsForPointToPageViewBounds:(struct CGPoint)arg2;	// IMP=0x00000001066c0df4
- (struct CGPoint)fromView:(id)arg1 convertPointToContainerView:(struct CGPoint)arg2;	// IMP=0x00000001066c0d4c
- (void)sendViewCloseEvent;	// IMP=0x00000001066c0c78
- (double)visiblityInView:(id)arg1;	// IMP=0x00000001066c0b3c
- (id)gestureDescription;	// IMP=0x00000001066c0a64
- (struct CGSize)_actionMenuContentSize;	// IMP=0x00000001066c0948
- (long long)_actionMenuOptionsNumber;	// IMP=0x00000001066c0790
- (void)_attachActionMenuMaskViewIfNeeded;	// IMP=0x00000001066c05f0
- (void)_removeActionMenuMaskViewIfNeeded;	// IMP=0x00000001066c0568
- (_Bool)_isRotationMediaContent;	// IMP=0x00000001066c04dc
- (double)_mediaContentScaleWithPercentInActionMenu:(double)arg1;	// IMP=0x00000001066c0378
- (void)_zoomToActionMenuV2WithPercent:(double)arg1 animated:(_Bool)arg2 completion:(id)arg3;	// IMP=0x00000001066bfd50
- (void)_zoomScrollViewWithPercent:(double)arg1 animated:(_Bool)arg2 completion:(id)arg3;	// IMP=0x00000001066bf420
- (void)_setupScrollViewForZoomIfNeededWithPercent:(double)arg1;	// IMP=0x00000001066bf2cc
- (void)zoomScrollView:(_Bool)arg1 completion:(id)arg2;	// IMP=0x00000001066bf278
- (void)hideChrome:(_Bool)arg1;	// IMP=0x00000001066bee7c
- (void)_hideBlur;	// IMP=0x00000001066bee64
- (void)_showBlur;	// IMP=0x00000001066bec98
- (void)_notifyLayerOfViewDidFullyAppearIfNeeded:(id)arg1;	// IMP=0x00000001066bec20
- (void)_notifyLayerOfViewWillFullyAppearIfNeeded:(id)arg1;	// IMP=0x00000001066beba8
- (_Bool)_validateFloatingLayerVCs;	// IMP=0x00000001066beae8
- (id)_layerVCsOnPage;	// IMP=0x00000001066bea28
- (_Bool)_shouldSetPinchGestureTargetForLayer:(id)arg1 viewController:(id)arg2;	// IMP=0x00000001066be940
- (_Bool)_shouldUpdateActionMenuStyleVersion;	// IMP=0x00000001066be838
- (void)_updateFloatingLayer:(id)arg1;	// IMP=0x00000001066be444
- (void)_updateFloatingLayersForCurrentDisplayingPage;	// IMP=0x00000001066be2f4
- (void)_updatePropertiesWithPageDidShrink:(_Bool)arg1;	// IMP=0x00000001066bdc68
- (void)updatePropertiesWithViewerIsDismissing:(_Bool)arg1;	// IMP=0x00000001066bdb84
- (void)updatePropertiesWithLooping:(_Bool)arg1;	// IMP=0x00000001066bda74
- (void)restartTimer;	// IMP=0x00000001066bda34
- (void)_resumeAutoAdvanceTimer;	// IMP=0x00000001066bd940
- (void)_pauseAutoAdvanceTimer;	// IMP=0x00000001066bd89c
- (_Bool)_shouldSetupAutoAdvanceTimer;	// IMP=0x00000001066bd830
- (void)pageDidScrollToHorizontalOffset:(double)arg1 isCurrentPage:(_Bool)arg2;	// IMP=0x00000001066bd6f4
- (void)pageDidScrollToVerticalOffset:(double)arg1;	// IMP=0x00000001066bd5c8
- (void)_updatePageSafeInsets:(_Bool)arg1;	// IMP=0x00000001066bd3a0
- (void)didUpdateViewProperties:(id)arg1;	// IMP=0x00000001066bcf2c
- (void)scrollViewDidZoom:(id)arg1;	// IMP=0x00000001066bce60
- (id)viewForZoomingInScrollView:(id)arg1;	// IMP=0x00000001066bce50
- (void)didTryPagingWhenPagingDisabled;	// IMP=0x00000001066bce04
- (id)_topMostBlockingLayerVC;	// IMP=0x00000001066bccb4
- (_Bool)blockingLayerIsBlocking;	// IMP=0x00000001066bcb88
- (_Bool)blockingLayerIsBlockingOtherLayersFromDisplaying;	// IMP=0x00000001066bca1c
- (void)blockingViewDidStartHiding:(id)arg1;	// IMP=0x00000001066bc974
- (void)blockingViewWasHidden:(id)arg1;	// IMP=0x00000001066bc800
- (void)_enumerateActionBarContentProviders:(id)arg1;	// IMP=0x00000001066bc678
- (void)_updateActionBarContentViews;	// IMP=0x00000001066bc46c
- (_Bool)_isExtendedAttachment;	// IMP=0x00000001066bc2d0
- (_Bool)_isAttachment;	// IMP=0x00000001066bc1f8
- (_Bool)shouldHideActionBar;	// IMP=0x00000001066bc0b4
- (id)shareableMediaSnapshotsWithPerformer:(id)arg1;	// IMP=0x00000001066bbdf0
- (id)shareableMedias;	// IMP=0x00000001066bbc08
- (void)autoAdvanceTimerDidFire;	// IMP=0x00000001066bbb34
- (void)rotateBasedOnOrientation;	// IMP=0x00000001066bba18
- (struct UIEdgeInsets)safeInsetsForPage;	// IMP=0x00000001066bba00
- (unsigned long long)relativePositionForPageId:(id)arg1;	// IMP=0x00000001066bb974
- (_Bool)pageIsPartiallyVisible:(id)arg1;	// IMP=0x00000001066bb8e8
- (_Bool)pageIsFullyVisible:(id)arg1;	// IMP=0x00000001066bb85c
- (id)_layerVCForLayer:(id)arg1 inLayerVCs:(id)arg2;	// IMP=0x00000001066bb67c
- (id)currentViewParameters;	// IMP=0x00000001066bb440
- (void)_clearLayerViewControllers:(id)arg1;	// IMP=0x00000001066bb12c
- (void)_addChildLayerVC:(id)arg1;	// IMP=0x00000001066baf88
- (void)_buildLayerVCs;	// IMP=0x00000001066ba794
- (void)_reloadLayersWithProperties:(id)arg1 oldProperties:(id)arg2;	// IMP=0x00000001066ba3ec
- (void)displayMediaLogIfAvailable;	// IMP=0x00000001066ba3e8
- (void)operaPageGestureRecognizers:(id)arg1 didEndGestureWithType:(long long)arg2 recognizer:(id)arg3;	// IMP=0x00000001066ba2d0
- (void)operaPageGestureRecognizers:(id)arg1 didChangeStateWithType:(long long)arg2 recognizer:(id)arg3;	// IMP=0x00000001066ba154
- (void)operaPageGestureRecognizers:(id)arg1 didBeginGestureWithType:(long long)arg2 recognizer:(id)arg3;	// IMP=0x00000001066ba03c
- (_Bool)operaPageGestureRecognizers:(id)arg1 shouldRecognizeGesture:(long long)arg2;	// IMP=0x00000001066b9f58
- (void)_didLongPress:(id)arg1;	// IMP=0x00000001066b9b7c
- (_Bool)isOverlay;	// IMP=0x00000001066b9b74
- (void)_shrinkMediaContainerLayersWithScale:(double)arg1 duration:(double)arg2;	// IMP=0x00000001066b9934
- (double)mediaHeightToWidthAspectRatio;	// IMP=0x00000001066b979c
- (struct CGRect)mediaViewFrame;	// IMP=0x00000001066b9530
- (struct CGRect)maskableFrame;	// IMP=0x00000001066b937c
- (void)_viewDidFullyAppearWithLayerVCs:(id)arg1;	// IMP=0x00000001066b8d0c
- (id)_pageLayersSnapshot;	// IMP=0x00000001066b8cfc
- (void)_logPageProperties;	// IMP=0x00000001066b8cf8
- (void)_announceDidFullyAppearEventIfNeeded;	// IMP=0x00000001066b894c
- (void)didUpdateBottomPageViewProperties:(id)arg1;	// IMP=0x00000001066b8808
- (_Bool)canHandleRoundCorner;	// IMP=0x00000001066b86d8
- (long long)pageabilityForRelativePosition:(unsigned long long)arg1 navigationStyle:(long long)arg2 swipeDirection:(long long)arg3 gestureRecognizer:(id)arg4;	// IMP=0x00000001066b84ac
- (long long)pageabilityForRelativePosition:(unsigned long long)arg1 gestureRecognizer:(id)arg2;	// IMP=0x00000001066b82d4
- (void)dealloc;	// IMP=0x00000001066b8264
- (void)teardown;	// IMP=0x00000001066b8030
- (void)setImageForBackdrop:(id)arg1;	// IMP=0x00000001066b8018
- (void)setVolume:(double)arg1;	// IMP=0x00000001066b7eec
- (_Bool)mediaIsBeingPreparedForDisplay;	// IMP=0x00000001066b7d30
- (void)stop;	// IMP=0x00000001066b7c14
- (void)start;	// IMP=0x00000001066b7af8
- (void)resume;	// IMP=0x00000001066b7980
- (_Bool)isPausedForAttachment;	// IMP=0x00000001066b7970
- (void)setPausedForAttachment:(_Bool)arg1;	// IMP=0x00000001066b7724
- (void)pause;	// IMP=0x00000001066b7560
- (void)viewDidFullyDisappear;	// IMP=0x00000001066b7338
- (void)viewWillFullyDisappear;	// IMP=0x00000001066b7204
- (void)viewDidPartiallyAppearWithCurrentViewRelativePosition:(unsigned long long)arg1;	// IMP=0x00000001066b70d8
- (void)neighborViewDidFullyAppearWithCurrentViewRelativePosition:(unsigned long long)arg1;	// IMP=0x00000001066b6fac
- (void)viewDidFullyAppear;	// IMP=0x00000001066b6e94
- (void)viewWillFullyAppear;	// IMP=0x00000001066b6cf8
- (void)viewDidAppear:(_Bool)arg1;	// IMP=0x00000001066b6ca8
- (void)_reactivateGestureRecognizers;	// IMP=0x00000001066b6b14
- (void)_activatePageGestureRegonizers:(_Bool)arg1;	// IMP=0x00000001066b6804
- (void)_loadPage;	// IMP=0x00000001066b6680
@property(readonly, nonatomic) UIView *attachmentBackgroundView;
- (void)setContainerViewXOffset:(double)arg1;	// IMP=0x00000001066b63d0
- (void)setContainerViewYOffset:(double)arg1;	// IMP=0x00000001066b61f4
- (void)updatePageLayersSnapshot:(id)arg1;	// IMP=0x00000001066b5f20
- (void)_loadContainerView;	// IMP=0x00000001066b5db8
- (void)_loadScrollView;	// IMP=0x00000001066b5bec
- (void)loadView;	// IMP=0x00000001066b5a44
- (void)_resizeSwipeUpViewLayerWithRespectToContentHeight:(double)arg1;	// IMP=0x00000001066b563c
- (_Bool)_responsiveLayoutTypeSupported:(unsigned long long)arg1;	// IMP=0x00000001066b53b0
- (struct CGRect)_baseBounds;	// IMP=0x00000001066b50b4
- (void)viewDidLayoutSubviews;	// IMP=0x00000001066b4c8c
- (id)initWithConfiguration:(id)arg1 layerViewControllerConfiguration:(id)arg2 operaDependencies:(id)arg3 legacySessionStateContainer:(id)arg4 eventAnnouncer:(id)arg5 layerViewControllerManager:(id)arg6 viewModel:(id)arg7 delegate:(id)arg8;	// IMP=0x00000001066b4a0c

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) NSUInteger hash;
@property(readonly) Class superclass;

@end

