
#import <Foundation/Foundation.h>
#import "RainbowRoad.h"
#import <UIKit/UIKit.h>
#import "ShadowHelper.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>



@interface ShadowInformationViewController: UIViewController
@property (nonatomic, strong) UITextView *body;
@property (nonatomic, strong) UINavigationBar *nav;
@property (nonatomic, strong) UILabel * label;
@end
@implementation ShadowInformationViewController

-(void)buildBody{
    self.body = [[UITextView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height )];
    self.body.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [ShadowData enabled:@"darkmode"] ? [UIColor whiteColor] : [UIColor blackColor]};
    
    NSMutableAttributedString *body = [[NSMutableAttributedString alloc] initWithString:
                                       @"[Audio Note Directory]\n[Assets Directory]\nDonate\n\nLead Developers:\nKanji\nWyatt\n\nTesters:\nwybie#7142\nDalton Dial\nDreamPanda\nCodey Moore\nStuxSec\n\nDonators:\nBou3addis\nseÃ±orbuttplug#0784\nRyan - rslider#5171\nRiot#4444 ( UAE 🇦🇪 )\nXoral#0001\nd3ibis\n\nImportant Stuff:\nShadow Documentation\nDiscord Server\n\nSpecial Thanks:\nu/Jailbrick3d\n||4151||\nr/SnapchatTweaks2 Discord Server" attributes: attributes];
    
    [self setLinkForStr:body link:[@"filza://view/" stringByAppendingString:[ShadowData fileWithName:@"audionotes/"]] string:@"[Audio Note Directory]"];
    [self setLinkForStr:body link:@"filza://view/Library/Application Support/shadowx/default/" string:@"[Assets Directory]"];
    [self setLinkForStr:body link:@"https://paypal.me/WhosKanji" string:@"Donate"];
    [self setLinkForStr:body link:@"https://www.instagram.com/wyattgahm/" string:@"no5up"];
    [self setLinkForStr:body link:@"https://www.twitter.com/kanjishere" string:@"Kanji"];
    [self setLinkForStr:body link:@"https://www.twitter.com/CodeyMooreDev" string:@"Codey Moore"];
    [self setLinkForStr:body link:@"https://twitter.com/StuxSec" string:@"StuxSec"];
    [self setLinkForStr:body link:@"https://whoskanji.com/Shadow-Documentation" string:@"Shadow Documentation"];
    [self setLinkForStr:body link:@"https://discord.gg/kanji" string:@"Discord Server"];
    [self setLinkForStr:body link:@"https://discord.gg/X2hrxdV" string:@"r/SnapchatTweaks2 Discord Server"];
    self.body.editable = false;
    [self.body setAttributedText:body];
    if([ShadowData enabled: @"darkmode"]){
        [self.body setBackgroundColor:[UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00]];
    }
    self.body.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    [self.body setTextContainerInset: UIEdgeInsetsMake(10,10,10,10)];
    [self.view addSubview:self.body];
}



-(void)viewDidLoad{
    [super viewDidLoad];
    [self buildBody];
    [self buildNav];
    if([ShadowData enabled: @"darkmode"]){
        [self.view setBackgroundColor:[UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00]];
    }
    
}

-(void)setLinkForStr:(NSMutableAttributedString *)str link:(NSString *)link string:(NSString *)substr{
    [str addAttribute:NSLinkAttributeName value:link range:[str.string rangeOfString:substr]];
}

-(void)buildNav{
    self.nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    if([ShadowData enabled:@"darkmode"]){
        [self.nav setTitleTextAttributes: @{
            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:19],
            NSForegroundColorAttributeName:[UIColor whiteColor]
        }];
    }else{
        [self.nav setTitleTextAttributes: @{
            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:19]
        }];
    }
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"Shadow Credits"];
    
    UIBarButtonItem* token = [[UIBarButtonItem alloc] initWithTitle: @"Token" style:UIBarButtonItemStylePlain target:self action:@selector(tokenPressed:)];
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle: @"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    
    [token setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Demibold" size:17]} forState:UIControlStateNormal];
    [back setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Demibold" size:17]} forState:UIControlStateNormal];
    
    navItem.leftBarButtonItem = token;
    navItem.rightBarButtonItem = back;
    
    if([ShadowData enabled: @"darkmode"]){
        self.nav.tintColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
        self.nav.barTintColor = [UIColor colorWithRed: 18/255.0 green: 18/255.0 blue: 18/255.0 alpha: 1.00];
    }
    
    [self.nav setItems:@[navItem]];
    [self.view addSubview:self.nav];
}

-(void)backPressed:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)tokenPressed:(UIBarButtonItem*)item{
    NSMutableDictionary *data = [ShadowHelper identifiers];
    NSString *tokeninfo = [NSString stringWithFormat:@"Username: %@\nUser ID: %@\nToken: %@", data[@"username"], data[@"user_id"], data[@"token"]];
    [ShadowHelper dialogWithTitle: @"Session Data" text: tokeninfo];
    
}
@end
