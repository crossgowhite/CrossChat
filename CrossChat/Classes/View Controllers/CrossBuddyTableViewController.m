//
//  CrossBuddyTableViewController.m
//  CrossChat
//
//  Created by chaobai on 15/10/26.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossBuddyTableViewController.h"
#import "String.h"
#import "CrossProtocolManager.h"
#import "CrossBuddy.h"

#import "YAPDatabaseViewMappings.h"
#import "YapDatabase.h"
#import "YapDatabaseView.h"
#import "YAPDatabaseConnection.h"

#import "CrossDataBaseView.h"
#import "CrossBuddyDataBaseManager.h"
#import "CrossBuddyManager.h"

#import "CrossBuddyViewManager.h"
#import "CrossBuddySetting.h"

#import "CrossBuddyTableViewCell.h"
#import "CrossMessageViewController.h"


#import "CrossMessageManager.h"
#import "CrossMessageDataBaseManager.h"
#import "CrossMessage.h"

@interface CrossBuddyTableViewController () <CrossSettingDelegate>

@property (nonatomic, strong) CrossBuddyViewManager * buddyViewManager;

@end

@implementation CrossBuddyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
     self.title = BUDDY_STRING;
    
    self.buddyViewManager = [[CrossBuddyViewManager alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.buddyViewManager.settingGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.buddyViewManager numberOfSettingsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"BuddyCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[CrossBuddyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    CrossSetting * setting = [self.buddyViewManager settingAtSection:indexPath.section row:indexPath.row];
    setting.delegate = self;
    [(CrossBuddyTableViewCell*)cell setSetting:setting];
    return  cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrossSetting *setting = [self.buddyViewManager settingAtSection:indexPath.section row:indexPath.row];
    CrossSettingActionBlock actionBlock = setting.actionBlock;
    if (actionBlock)
    {
        actionBlock();
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- connection status kvo
- (void)viewWillAppear:(BOOL)animated
{
    if([CrossProtocolManager sharedInstance].numberOfConnectedAccount)
    {
        [self refreshTableView];
    }
    else
    {
        [self cleanTableView];
    }
    
    [[CrossProtocolManager sharedInstance] addObserver:self forKeyPath:NSStringFromSelector(@selector(numberOfConnectedAccount)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[CrossProtocolManager sharedInstance] removeObserver:self forKeyPath:NSStringFromSelector(@selector(numberOfConnectedAccount))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUInteger numberConnectedAccounts = [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
    //alredy connected
    if (numberConnectedAccounts)
    {
        [self refreshTableView];
    }
    
    else
    {
        [self cleanTableView];
    }
}

- (void)refreshTableView
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.buddyViewManager refreshSettingGroup];
        [self.tableView reloadData];
    });
}

- (void)cleanTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.buddyViewManager cleanSettingGroup];
        [self.tableView reloadData];
    });
}



#pragma mark -- action block call back function item
- (void) Setting:(CrossSetting*)setting showDetailViewControllerClass:(Class)viewControllerClass
{
    //show message view controller
    if ([setting isKindOfClass:[CrossBuddySetting class]])
    {
        CrossMessageViewController *viewController = [[viewControllerClass alloc] init];
        CrossBuddySetting * buddySetting = (CrossBuddySetting*)setting;
        viewController.buddy = buddySetting.buddy;
        [viewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}



//- (CrossBuddy *) buddyAtIndexPath: (NSIndexPath *)indexPath
//{
//    __block CrossBuddy *buddy = nil;
//    [self.databaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
//        
//        buddy = [[transaction extension:CrossAllBuddyDatabaseViewExtensionName] objectAtIndexPath:indexPath withMappings:self.mappings];
//    }];
//    
//    return buddy;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//
//
//#pragma mark - yap data base change
//- (void)setupDataBaseView
//{
//    //mare sure all acount view is registered in yap
//    [CrossDataBaseView registerAllBuddysDatabaseView];
//    
//    //yap data base part
//    self.databaseConnection = [[CrossBuddyDataBaseManager sharedInstance] newConnection];
//    [self.databaseConnection beginLongLivedReadTransaction];
//    
//    
//    //Create mappings from allAccountsDatabaseView
//    self.mappings = [[YapDatabaseViewMappings alloc] initWithGroups:@[CrossAllBuddyGroup] view:CrossAllBuddyDatabaseViewExtensionName];
//    
//    [self.databaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction){
//        [self.mappings updateWithTransaction:transaction];
//    }];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(yapDatabaseModified:)
//                                                 name:YapDatabaseModifiedNotification
//                                               object:nil];
//}
//
//- (void)yapDatabaseModified: (NSNotification *)notification
//{
//    // Jump to the most recent commit.
//    // End & Re-Begin the long-lived transaction atomically.
//    // Also grab all the notifications for all the commits that I jump.
//    // If the UI is a bit backed up, I may jump multiple commits.
//    
//    NSArray *notifications = [self.databaseConnection beginLongLivedReadTransaction];
//    
//    // Process the notification(s),
//    // and get the change-set(s) as applies to my view and mappings configuration.
//    
//    NSArray *sectionChanges = nil;
//    NSArray *rowChanges = nil;
//    
//    
//    [ [self.databaseConnection ext:CrossAllBuddyDatabaseViewExtensionName] getSectionChanges:&sectionChanges
//                                                                                    rowChanges:&rowChanges
//                                                                              forNotifications:notifications
//                                                                                  withMappings:self.mappings];
//    // No need to update mappings.
//    // The above method did it automatically.
//    
//    if ([sectionChanges count] == 0 & [rowChanges count] == 0)
//    {
//        // Nothing has changed that affects our tableView
//        return;
//    }
//    
//    // Familiar with NSFetchedResultsController?
//    // Then this should look pretty familiar
//    
//    [self.tableView beginUpdates];
//    
//    for (YapDatabaseViewSectionChange *sectionChange in sectionChanges)
//    {
//        switch (sectionChange.type)
//        {
//            case YapDatabaseViewChangeDelete :
//            {
//                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionChange.index]
//                              withRowAnimation:UITableViewRowAnimationAutomatic];
//                break;
//            }
//            case YapDatabaseViewChangeInsert :
//            {
//                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionChange.index]
//                              withRowAnimation:UITableViewRowAnimationAutomatic];
//                break;
//            }
//        }
//    }
//    
//    for (YapDatabaseViewRowChange *rowChange in rowChanges)
//    {
//        NSIndexPath * actionindex = [NSIndexPath indexPathForRow:rowChange.newIndexPath.row inSection:rowChange.newIndexPath.section];
//        
//        switch (rowChange.type)
//        {
//            case YapDatabaseViewChangeDelete :
//            {
//                [self.tableView deleteRowsAtIndexPaths:@[ actionindex ]
//                                      withRowAnimation:UITableViewRowAnimationAutomatic];
//                break;
//            }
//            case YapDatabaseViewChangeInsert :
//            {
//                [self.tableView insertRowsAtIndexPaths:@[ actionindex ]
//                                      withRowAnimation:UITableViewRowAnimationAutomatic];
//                break;
//            }
//            case YapDatabaseViewChangeMove :
//            {
//                [self.tableView deleteRowsAtIndexPaths:@[ actionindex ]
//                                      withRowAnimation:UITableViewRowAnimationAutomatic];
//                [self.tableView insertRowsAtIndexPaths:@[ actionindex ]
//                                      withRowAnimation:UITableViewRowAnimationAutomatic];
//                break;
//            }
//            case YapDatabaseViewChangeUpdate :
//            {
//                [self.tableView reloadRowsAtIndexPaths:@[ actionindex ]
//                                      withRowAnimation:UITableViewRowAnimationNone];
//                break;
//            }
//        }
//    }
//    
//    [self.tableView endUpdates];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
