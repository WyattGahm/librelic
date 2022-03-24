





#import <Foundation/Foundation.h>

@class SCContextLoggingActionSource, SCContextV2ActionsHandler;

@protocol SCContextV2ActionsHandlerDelegate <NSObject>
@property(retain, nonatomic) SCContextLoggingActionSource *contextActionSource;
- (void)contextActionsHandlerWantsToDismissCurrentModalOverlay:(SCContextV2ActionsHandler *)arg1 completion:(void (^)(void))arg2;
- (void)contextActionsHandlerWantsToOpenChat:(SCContextV2ActionsHandler *)arg1 source:(SCContextLoggingActionSource *)arg2;
- (void)contextActionsHandler:(SCContextV2ActionsHandler *)arg1 didLeaveAppSuccessfully:(_Bool)arg2;
- (void)contextActionsHandlerWillTryToLeaveApp:(SCContextV2ActionsHandler *)arg1;
- (void)contextActionsHandlerDidFinishPresentingMedia:(SCContextV2ActionsHandler *)arg1;
- (void)contextActionsHandlerDidBeginPresentingMedia:(SCContextV2ActionsHandler *)arg1;
- (void)contextActionsHandlerDidDismissModalContent:(SCContextV2ActionsHandler *)arg1 source:(SCContextLoggingActionSource *)arg2;
- (void)contextActionsHandlerDidPresentModalContent:(SCContextV2ActionsHandler *)arg1 source:(SCContextLoggingActionSource *)arg2;
- (void)contextActionsHandler:(SCContextV2ActionsHandler *)arg1 wantsToDismissContextCardsWithCompletion:(void (^)(void))arg2;

@optional
- (void)contextActionsHandlerWantsToExpandFromCollapsedState:(SCContextV2ActionsHandler *)arg1;
- (void)contextActionsHandler:(SCContextV2ActionsHandler *)arg1 wantsToRegisterExpansionStateListener:(void (^)(_Bool))arg2;
- (_Bool)contextActionsHandlerCardsShouldBeCollapsed:(SCContextV2ActionsHandler *)arg1;
@end

