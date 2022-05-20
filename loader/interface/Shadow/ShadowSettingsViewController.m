#include "ShadowSettingsViewController.h"
#include "ShadowData.h"
#include "ShadowInformationViewController.h"
#include "RainbowRoad.h"
#include "ShadowAssets.h"


@interface ShadowSwitch: UISwitch
@property NSString *setting;
@end

@implementation ShadowSwitch
@end

@interface ShadowField: UITextField
@property NSString *setting;
@end

@implementation ShadowField
@end

@implementation ShadowSettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self cofigureTableview];
    [[ShadowData sharedInstance] load];
    self.table.alwaysBounceVertical = NO;
    if([ShadowData enabled:@"darkmode"]){
        self.table.separatorColor = [UIColor colorWithRed: .235 green: .235 blue: .263 alpha: 1];
    }
}

-(void)cofigureTableview{
    NSInteger height = 67;
    
    UINavigationBar *nav = [self makeNav];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, nav.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - nav.bounds.size.height) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    if([ShadowData enabled: @"darkmode"]){
        self.table.backgroundColor = [UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00];
    }
    [self.view addSubview: nav];
    [self.view addSubview:self.table];
}

-(UINavigationBar*)makeNav{
    UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 56)];
    if([ShadowData enabled:@"darkmode"]){
        [nav setTitleTextAttributes: @{
            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:19],
            NSForegroundColorAttributeName:[UIColor whiteColor]
        }];
    }else{
        [nav setTitleTextAttributes: @{
            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:19]
        }];
    }
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"Shadow Settings"];
    UIBarButtonItem* more = [[UIBarButtonItem alloc] initWithTitle: @"More" style:UIBarButtonItemStylePlain target:self action:@selector(morePressed:)];
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle: @"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [more setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Demibold" size:17]} forState:UIControlStateNormal];
    [back setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Demibold" size:17]} forState:UIControlStateNormal];
    navItem.leftBarButtonItem = more;
    navItem.rightBarButtonItem = back;
    [nav setItems:@[navItem]];
    [nav layoutSubviews];
    
    if([ShadowData enabled: @"darkmode"]){
        nav.tintColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
        nav.barTintColor = [UIColor colorWithRed: 18/255.0 green: 18/255.0 blue: 18/255.0 alpha: 1.00];
    }
    return nav;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[ShadowData sharedInstance] layout].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        return 13;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *settings = [[ShadowData sharedInstance] layout ][[[ShadowData sharedInstance] orderedSections][section]];
    return settings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShadowSetting *setting = [[ShadowData sharedInstance] layout ] [ [ [ShadowData sharedInstance] orderedSections] [indexPath.section]][indexPath.row];
    long originalIndex = [[ShadowData sharedInstance] indexForKey: setting.key];
    
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:setting.type];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:setting.type];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        cell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        if([ShadowData enabled:@"darkmode"]){
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            [cell setBackgroundColor:[UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00]];
        }
    }
    
    
    if([setting.type isEqualToString:@"image"]){
        cell = [UITableViewCell new];
        UIImage * header = [UIImage imageWithContentsOfFile:setting.value];
        UIImageView *imageView = [[UIImageView new] initWithImage: header];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.cornerRadius = 15;
        imageView.clipsToBounds = true;
        cell.backgroundView = imageView;
        if([ShadowData enabled:@"darkmode"]){
            [cell setBackgroundColor:[UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00]];
        }
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    if([setting.type isEqualToString:@"switch"]){
        
        ShadowSwitch *switchview = [[ShadowSwitch alloc] initWithFrame:CGRectMake(0,0,0,0)];
        switchview.on = [[ShadowData sharedInstance].settings[setting.key] isEqualToString: @"true"];
        //NSLog(@"DEBUG: Looks like switch should be %@ for key %@",[ShadowData sharedInstance].settings[setting.key], setting.key);
        switchview.setting = setting.key;
        
        if([ShadowData enabled:@"darkmode"])
            switchview.onTintColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
        [switchview addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        switchview.tag = originalIndex;
        if([[ShadowData sharedInstance].server[setting.key] isEqualToString:@"Disable"]){
            switchview.enabled = NO;
            switchview.on = NO;
            [[ShadowData sharedInstance] disable:setting.key];
        }
        cell.accessoryView = switchview;
        
        
    }else if([setting.type isEqualToString:@"button"]){
        UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [resetButton addTarget:objc_getClass("ShadowHelper") action:NSSelectorFromString(setting.key) forControlEvents:UIControlEventTouchUpInside];
        [resetButton setTitle:[ShadowData sharedInstance].settings[setting.key] forState:UIControlStateNormal];
        if([ShadowData enabled:@"darkmode"])
            resetButton.tintColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
        cell.accessoryView = resetButton;
        [resetButton sizeToFit];
    }else if([setting.type isEqualToString:@"text"]){
        
        
        ShadowField *textField = [ShadowField new];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13.5];
        textField.text = [ShadowData sharedInstance].settings[setting.key];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = originalIndex;
        textField.setting = setting.key;
        
        /// IMPORTANT STUFF FOR IOS 12 / DARK MODE TODO
        
        if([ShadowData enabled:@"darkmode"]){
            textField.layer.cornerRadius=8.0f;
            textField.layer.masksToBounds = YES;
            textField.layer.borderColor = [[UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00] CGColor];
            textField.layer.borderWidth = 1.0f;
            textField.textColor = [UIColor whiteColor];
            textField.backgroundColor = [UIColor clearColor];
        }
        if([[ShadowData sharedInstance].server[setting.key] isEqualToString:@"Disable"]){
            textField.enabled = FALSE;
            textField.text = @"";
            textField.placeholder = @"Disabled";
            [[ShadowData sharedInstance] disable:setting.key];
            
        }
        cell.accessoryView = textField;
        [textField sizeToFit];
        [textField setFrame:CGRectMake(textField.frame.origin.x,textField.frame.origin.y,cell.frame.size.width / 2,textField.frame.size.height)];
    }
    cell.textLabel.text = setting.title;
    cell.detailTextLabel.text = setting.text;
    cell.detailTextLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(BOOL)textFieldShouldEndEditing:(ShadowField *)textField{
    [ShadowData sharedInstance].settings[textField.setting] = textField.text;
    [[ShadowData sharedInstance] save];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
/*
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(section == 0){
        [[[ShadowData sharedInstance] layout] allValues][section]
    }
    return [ShadowData sharedInstance].server[@"motd"];
}
 */
/*
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)view;
    footerView.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    footerView.textLabel.textAlignment = NSTextAlignmentCenter;
    footerView.textLabel.numberOfLines = 0;
    if([ShadowData enabled:@"darkmode"]){
        footerView.backgroundView.backgroundColor = [UIColor colorWithRed: 18/255.0 green: 18/255.0 blue: 18/255.0 alpha: 1.00];
    }
    [footerView.textLabel sizeToFit];
    
    if([ShadowData enabled: @"darkmode"]){
        self.table.backgroundColor = [UIColor colorWithRed: 0.12 green: 0.12 blue: 0.12 alpha: 1.00];
    }
     
}
*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section){
        UILabel *title = [UILabel new];
        title.text = [[[ShadowData sharedInstance] orderedSections][section] uppercaseString];
        title.font = [UIFont fontWithName:@"AvenirNext-Bold" size:13];
        title.textAlignment = NSTextAlignmentCenter;
        if([ShadowData enabled:@"darkmode"]){
            title.backgroundColor = [UIColor colorWithRed: 30/255.0 green: 30/255.0 blue: 30/255.0 alpha: 1.00];
            //title.textColor = [UIColor colorWithRed: 255/255.0 green: 252/255.0 blue: 0/255.0 alpha: 1.00];
            title.textColor = [UIColor whiteColor];
        }else{
            title.backgroundColor = [UIColor whiteColor];
        }
        return title;
    }else{
        return nil;
    }
}

-(void)switchChanged:(ShadowSwitch*)sender {
    //NSLog(@"SENDER FOR SWI: %@",sender.setting);
    [ShadowData sharedInstance].settings[sender.setting] = sender.on ? @"true" : @"false";
    [[ShadowData sharedInstance] save];
}
-(void)backPressed:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)morePressed:(UIBarButtonItem*)item{
    [self presentViewController:[ShadowInformationViewController new] animated:true completion:nil];
}
@end

