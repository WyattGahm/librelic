#include <UIKit/UIKit.h>
#include "ShadowInformationViewController.h"
#include "RainbowRoad.h"


@interface ShadowSettingsViewController: UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong,nonatomic) UITableView *table;
@end

@implementation ShadowSettingsViewController

-(UITraitCollection *)traitCollection {
    if([[ShadowData sharedInstance] enabled_secure: "darkmode"]){
        NSArray *traits = @[[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark],
                            [UITraitCollection traitCollectionWithUserInterfaceIdiom:UIUserInterfaceIdiomPhone],
        ];
        return [UITraitCollection traitCollectionWithTraitsFromCollections:traits];
    }else{
        NSArray *traits = @[[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight],
                            [UITraitCollection traitCollectionWithUserInterfaceIdiom:UIUserInterfaceIdiomPhone],
        ];
        return [UITraitCollection traitCollectionWithTraitsFromCollections:traits];
    }
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    //self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    [self cofigureTableview];
    [[ShadowData sharedInstance] load];
    self.table.alwaysBounceVertical = NO;
}

-(void)cofigureTableview{
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor colorWithRed: 0.12 green: 0.12 blue: 0.12 alpha: 1.00];
    [self.view addSubview:self.table];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return dataManager.settings.count;
    return [ShadowData sharedInstance].prefs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];
    //setting *entry = dataManager.settings[indexPath.row];
    ShadowSetting *entry = [ShadowData sharedInstance].prefs[indexPath.row];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        cell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        [cell setBackgroundColor:[UIColor colorWithRed: 0.12 green: 0.12 blue: 0.12 alpha: 1.00]];
    }
    if([entry.key isEqualToString:@"reset"]){
        UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        cell.accessoryView = resetButton;
        [resetButton sizeToFit];
    } else if(entry.useEntry){
        //UITextField *textField = [[UITextField alloc] initWithFrame:];
        UITextField *textField = [UITextField new];
        //CGSize size = [textField sizeThatFits:CGSizeMake(cell.frame.size.width , cell.frame.size.height)];
        //[textField setFrame:CGRectMake(size.width,size.height,0,0)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13.5];
        //textField.placeholder = @"Enter stuff";
        textField.text = entry.entry;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = indexPath.row;
        textField.backgroundColor = [UIColor clearColor];

        if([[ShadowData sharedInstance].server[entry.key] isEqualToString:@"Disable"]){
            textField.enabled = FALSE;
            textField.text = @"";
            textField.placeholder = @"Disabled";
            [[ShadowData sharedInstance] disable:entry.key];
            
        }
        //[textField addTarget:self action:@selector(editingEnded:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = textField;
        //[textField.widthAnchor constraintLessThanOrEqualToConstant:cell.frame.size.width / 4].active = YES;
        [textField sizeToFit];
        [textField setFrame:CGRectMake(textField.frame.origin.x,textField.frame.origin.y,cell.frame.size.width / 2,textField.frame.size.height)];
        //[textField sizeThatFits:CGSizeMake(cell.frame.size.width , cell.frame.size.height)];
    }else{
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectMake(0,0,0,0)];
        switchview.on = entry.value;
        [switchview addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        switchview.tag = indexPath.row;
        if([[ShadowData sharedInstance].server[entry.key] isEqualToString:@"Disable"]){
            switchview.enabled = FALSE;
            switchview.on = FALSE;
            [[ShadowData sharedInstance] disable:entry.key];
        }
        cell.accessoryView = switchview;
    }
    
    cell.textLabel.text = entry.name;
    cell.detailTextLabel.text = entry.text;
    cell.detailTextLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    ShadowSetting *entry = [ShadowData sharedInstance].prefs[textField.tag];
    entry.entry = textField.text;
    [[ShadowData sharedInstance] save];
    return TRUE;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [ShadowData sharedInstance].server[@"motd"];
    //return @"Shadow MK7 | Wyatt x Kanji";
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)view;
    footerView.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    footerView.textLabel.textAlignment = NSTextAlignmentCenter;
    footerView.textLabel.numberOfLines = 0;
    [footerView.textLabel sizeToFit];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    [nav setTitleTextAttributes: @{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:19]}];
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"Shadow Settings"];
    UIBarButtonItem* more = [[UIBarButtonItem alloc] initWithTitle: @"More" style:UIBarButtonItemStylePlain target:self action:@selector(morePressed:)];
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle: @"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [more setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Demibold" size:17]} forState:UIControlStateNormal];
    [back setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Demibold" size:17]} forState:UIControlStateNormal];
    navItem.leftBarButtonItem = more;
    navItem.rightBarButtonItem = back;
    [nav setItems:@[navItem]];
    [nav layoutSubviews];
    return nav;
}
-(void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    //setting *entry = dataManager.settings[switchControl.tag];
    ShadowSetting *entry = [ShadowData sharedInstance].prefs[switchControl.tag];
    entry.value = switchControl.on;
    //[dataManager save];
    [[ShadowData sharedInstance] save];
}
-(void)backPressed:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)morePressed:(UIBarButtonItem*)item{
    [self presentViewController:[ShadowInformationViewController new] animated:true completion:nil];
}
-(void)reset{
}
@end
