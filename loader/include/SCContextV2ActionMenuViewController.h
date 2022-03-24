#import <UIKit/UIViewController.h>

#import "SCContextActionMenuDataSourceDelegate-Protocol.h"

@class SCContextActionMenuOperaDataSource, SCContextActionParams, SCContextLoggingActionSource, SCContextV2ActionsHandler, SCDisposableObserverLifecycle, SCOperaPage, UIStackView;
@protocol SCContextLogging;

@interface SCContextV2ActionMenuViewController : UIViewController <SCContextActionMenuDataSourceDelegate>{
    SCContextActionParams *_actionParams;
    SCContextV2ActionsHandler *_actionHandler;
    id <SCContextLogging> _logger;
    UIStackView *_stackView;
    SCContextActionMenuOperaDataSource *_actionMenuDataSource;
    _Bool _canShowReplyAction;
    _Bool _fromSwipeUp;
    SCOperaPage *_page;
    SCDisposableObserverLifecycle *_operaPageObserverLifecycle;
    SCContextLoggingActionSource *_contextActionSource;
}

@property(retain, nonatomic) SCContextLoggingActionSource *contextActionSource;
- (id)_filteredLaunchSourceAction:(id)arg1;
- (id)_createActionMenuActionSource;
- (void)actionSuggestPlace;
- (void)actionAstrologyLearnMore;
- (void)actionBoombox;
- (void)actionRetryBackup;
- (void)actionBackupNow;
- (void)actionUnfavorite;
- (void)actionFavorite;
- (void)actionDislike;
- (void)actionUnsubcribe;
- (void)actionSubscribe;
- (void)logActionType:(id)arg1;
- (void)actionSubtitles;
- (void)actionToggleMEO;
- (void)actionRemix;
- (void)actionExport;
- (void)actionInfo;
- (void)actionDeleteInChat;
- (void)actionUnsaveInChat;
- (void)actionSaveInChat;
- (void)actionSave;
- (void)actionDelete;
- (void)actionEdit;
- (void)actionReport;
- (void)actionShare;
- (void)_actionReply;
- (void)populateActions:(id)arg1 stackView:(id)arg2;
- (void)actionMenuDataSource:(id)arg1 didUpdateActionMenuItems:(id)arg2;
- (void)addTimestampMenuItem:(id)arg1;
- (void)_setupView:(id)arg1;
- (void)dismissAndPerform:(id)arg1;
- (void)viewDidLoad;
- (id)initWithActionParams:(id)arg1 operaPageObservable:(id)arg2 actionHandler:(id)arg3 logger:(id)arg4 canShowReplyAction:(_Bool)arg5 fromSwipeUpMessagingController:(_Bool)arg6;

@end

