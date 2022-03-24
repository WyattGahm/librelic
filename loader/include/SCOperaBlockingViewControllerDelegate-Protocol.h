#import <Foundation/Foundation.h>

@protocol SCOperaBlockingViewController;

@protocol SCOperaBlockingViewControllerDelegate <NSObject>
- (void)blockingViewDidStartHiding:(id <SCOperaBlockingViewController>)arg1;
- (void)blockingViewWasHidden:(id <SCOperaBlockingViewController>)arg1;
@end

