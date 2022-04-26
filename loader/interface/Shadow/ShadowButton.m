#include "ShadowButton.h"
#include "ShadowData.h"
#include "ShadowLayout.h"

@implementation ShadowButton
-(instancetype)initWithPrimaryImage:(UIImage*)primary secondaryImage:(UIImage*)secondary identifier:(NSString*)key target:(id)cls action:(SEL)action{
    self.primary = primary;
    self.secondary = secondary ? secondary : primary;
    self.identifier = key;
    self = [super initWithImage:primary];
    if([ShadowData sharedInstance].positions.layout[key]){
        //self.frame = [[ShadowData sharedInstance].positions frameForID: key];
        long btnsz = [ShadowData enabled: @"buttonsize"] ? [[ShadowData sharedInstance].settings[@"buttonsize"] intValue] : 40;
        self.frame = CGRectMake(btnsz,btnsz,btnsz,btnsz);
        self.center = [[ShadowData sharedInstance].positions centerForID: key];
    }else{
        self.frame = CGRectMake(40,40,40,40);
        double x = [UIScreen mainScreen].bounds.size.width * 0.85; //tweak me? dynamic maybe?
        double y = [UIScreen mainScreen].bounds.size.height * 0.70;//tweak me? dynamic maybe?
        self.center = CGPointMake(x, y);
    }
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wasDragged:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:cls action:action];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    tap1.delegate = tap2.delegate = pan.delegate = swipe.delegate = self;
    [self addGestureRecognizer:tap1];
    [self addGestureRecognizer:tap2];
    [self addGestureRecognizer:swipe];
    [self addGestureRecognizer:pan];
    return self;
}
-(void)changeImage{
    self.image = self.secondary;
}
- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    UIImageView *button = (UIImageView *)recognizer.view;
    CGPoint translation = [recognizer translationInView:button];
    if(![ShadowData enabled:@"lockbuttons"]){
        button.center = CGPointMake(button.center.x + translation.x, button.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:button];
        NSLog(@"DEBUG 1: %@",self.identifier);
        [[ShadowData sharedInstance].positions setCenterForID: self.identifier value: button.center];
    }
}
-(void)handlePinch:(UISwipeGestureRecognizer *)recognizer{
    NSLog(@"PINCHING: %ld",recognizer.direction);
}
-(void)addToVC:(UIViewController *)vc{
    [vc.view addSubview: self];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gr1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)gr2{
    return YES;
    //return [gr1.class isEqual: gr2.class];
}
@end
