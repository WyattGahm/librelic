//
//  XLLogerView.m
//  XLLogerDemo
//
//  Created by mgfjx on 2021/9/12.
//

#import "XLLogerView.h"
#import "XLLogerManager.h"

#define kStatusBarHeight 44

@interface XLLogerView ()<UITextViewDelegate> {
    CGFloat contentOffsetX;
    CGFloat contentOffsetY;
}

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) BOOL autoScroll ;

@end

@implementation XLLogerView

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}


#pragma mark - init UI
- (void)initViews {
    
    self.autoScroll = YES;
    
    UIView *container = self;
    container.clipsToBounds = YES;
    container.layer.borderColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.0].CGColor;
    container.layer.borderWidth = 1.0f;
    container.layer.cornerRadius = 8;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
    [container addSubview:topView];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topView = topView;
    [self initTopViews];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
    [container addSubview:bottomView];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomView = bottomView;
    [self initBottomViews];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.textColor = [XLLogerManager manager].textColor;
    textView.font = [UIFont systemFontOfSize:[XLLogerManager manager].textSize];
    textView.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0];
    textView.delegate = self;
    [container addSubview:textView];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.text = self.defaultLog;
    self.textView = textView;
    
    CGFloat topBottomRate = 0.07;
    CGFloat topBottomHeight = 30.0f;
    // layout top view
    {
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:topBottomHeight];
        left.active = YES;
        right.active = YES;
        height.active = YES;
        top.active = YES;
    }
    
    // layout bottom view
    {
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:topBottomHeight];
        left.active = YES;
        right.active = YES;
        height.active = YES;
        bottom.active = YES;
    }
    
    // layout text view
    {
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        left.active = YES;
        right.active = YES;
        top.active = YES;
        bottom.active = YES;
    }
    
    __weak __typeof(&*self) weakSelf  = self;
    [XLLogerManager manager].outputCallback = ^(NSString * _Nonnull outPut) {
        [weakSelf getOutPutLog:outPut];
    };
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPanHandle:)];
    [self addGestureRecognizer:pan];
    
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scalePanHandle:)];
    [bottomView addGestureRecognizer:pan2];
}

- (void)initTopViews {
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/logger/close.png"] forState:UIControlStateNormal];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    closeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self.topView addSubview:closeBtn];
    closeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat offset = 3;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:offset];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-offset];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:closeBtn attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    left.active = YES;
    bottom.active = YES;
    width.active = YES;
    top.active = YES;
    
    {
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
        [clearBtn setImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/logger/clear.png"] forState:UIControlStateNormal];
        clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        clearBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [self.topView addSubview:clearBtn];
        clearBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        CGFloat offset = 3;
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:clearBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:clearBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-offset];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:clearBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-offset];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:clearBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:clearBtn attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        right.active = YES;
        bottom.active = YES;
        width.active = YES;
        top.active = YES;
    }
    
}
    
- (void)initBottomViews {
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn addTarget:self action:@selector(turnOff:) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/logger/radio_uncheck.png"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/shadowx/logger/radio_checked.png"] forState:UIControlStateSelected];
    checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    checkBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self.bottomView addSubview:checkBtn];
    checkBtn.translatesAutoresizingMaskIntoConstraints = NO;
    checkBtn.selected = ![XLLogerManager manager].enable;
    
    CGFloat offset = 3;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:checkBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:checkBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:offset];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:checkBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-offset];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:checkBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:checkBtn attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    left.active = YES;
    bottom.active = YES;
    width.active = YES;
    top.active = YES;
    
    {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = @"Don't intercept logs the next starts.";
        textLabel.font = [UIFont systemFontOfSize:10];
        [self.bottomView addSubview:textLabel];
        textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        CGFloat offset = 3;
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:checkBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-offset];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:checkBtn attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5];
        right.active = YES;
        left.active = YES;
        centerY.active = YES;
    }
}

- (void)turnOff:(UIButton *)sender {
    sender.selected = !sender.selected;
    [XLLogerManager manager].enable = !sender.selected;
}

#pragma mark - event func
/// never log anything in this method!
- (void)getOutPutLog:(NSString *)outPut {
    self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text, outPut];// logTextView 就是要将日志输出的视图（UITextView）
    if (![self.textView isTracking] && self.autoScroll) {
        NSRange range;
        range.location = [self.textView.text length] - 1;
        range.length = 0;
        [self.textView scrollRangeToVisible:range];
    }
}

- (void)closeSelf {
    if (self.closeCallback) {
        self.closeCallback();
    }
    [self removeFromSuperview];
}

- (void)clearText {
    self.textView.text = @"";
    self.autoScroll = YES;
}

/// drag gesture
- (void)dragPanHandle:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint origin = [pan locationInView:pan.view];
        
        contentOffsetX = origin.x;
        contentOffsetY = origin.y;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan locationInView:self.superview];
        CGRect frame = pan.view.frame;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat x = point.x - contentOffsetX;
        CGFloat y = point.y - contentOffsetY;
        CGFloat offset = 50;
        if (x + self.frame.size.width <= offset) {
            x = offset - self.frame.size.width;
        }
        if (x >= width - offset) {
            x = width - offset;
        }
        if (y + self.frame.size.height <= kStatusBarHeight + offset) {
            y = kStatusBarHeight + offset - self.frame.size.height;
        }
        if (y >= height - offset) {
            y = height - offset;
        }
        frame.origin = CGPointMake(x, y);
        pan.view.frame = frame;
    }
}


/// scale gesture
- (void)scalePanHandle:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint origin = [pan locationInView:self];
        contentOffsetX = origin.x;
        contentOffsetY = origin.y;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan locationInView:self];
        CGRect frame = self.frame;
        CGFloat changeX = point.x - contentOffsetX;
        CGFloat changeY = point.y - contentOffsetY;
        frame.size.width = frame.size.width + changeX;
        frame.size.height = frame.size.height + changeY;
        self.frame = frame;
        contentOffsetX = point.x;
        contentOffsetY = point.y;
    }
}

- (UIImage *)imageForResourcePath:(NSString *)path ofType:(NSString *)type inBundle:(NSBundle *)bundle {
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:path ofType:type]];
}

#pragma mark - UITextViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        self.autoScroll = YES;
    } else {
        self.autoScroll = NO;
    }
}

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates {
    BOOL shouldReceiveTouch = NO;
    if (CGRectContainsPoint(self.frame, pointInWindowCoordinates)) {
        shouldReceiveTouch = YES;
    }
    return shouldReceiveTouch;
}

@end
