//
//  CrossMessageViewController.m
//  CrossChat
//
//  Created by chaobai on 15/11/3.
//  Copyright © 2015年 chaobai. All rights reserved.
//

#import "CrossMessageViewController.h"
#import "CrossBuddy.h"

#import "CrossMessageViewManager.h"
#import "CrossMessageTableViewCell.h"

#import "CrossMessageFrame.h"
#import "CrossXMPPMessageStatus.h"

#import "XMPPMessage.h"
#import "CrossXMPPMessageDecoder.h"
#import "CrossBuddyDataBaseManager.h"
#import "CrossMessageDataBaseManager.h"
#import "CrossMessage.h"
#import "CrossMessageManager.h"

#import "CrossConstants.h"
#import "CrossKeyBoardView.h"

#import "CrossAccountManager.h"
#import "CrossAccount.h"
#import "CrossProtocol.h"
#import "CrossProtocolManager.h"

static NSString *cellIdentifier = @"MessageCell";

@interface CrossMessageViewController () <KeyBordViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) CrossKeyBoardView * keyBoardView;

@property (nonatomic, strong) CrossMessageViewManager * messageViewManager;
@property (nonatomic, strong) CrossMessage * lastMessage;

@end



@implementation CrossMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTableView];
    self.title = self.buddy.displayName;
    [self.tableView registerClass:[CrossMessageTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.messageViewManager = [[CrossMessageViewManager alloc]initWithCrossBuddy:self.buddy];
    
 #define KEYBOARDHEITHT 68
    //init key board view
    self.keyBoardView= [[CrossKeyBoardView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, KEYBOARDHEITHT)];
    self.keyBoardView.delegate = self;
    
    [self.view addSubview:self.keyBoardView];
    
    [self tableViewScrollLastIndexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.messageViewManager.messageFrameGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messageViewManager numberOfMessageFramesInSection: section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CrossMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[CrossMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    CrossMessageFrame * messageFrame = [self.messageViewManager messageFrameAtSection:indexPath.section row:indexPath.row];
    cell.messageFrame = messageFrame;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrossMessageFrame * messageFrame = [self.messageViewManager messageFrameAtSection:indexPath.section row:indexPath.row];
    return [messageFrame messageHeight];
}

#pragma mark -- init table View
- (void)initTableView
{
    self.tableView.allowsSelection = NO;
    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
}

- (void)refreshTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageViewManager refreshMessageFrameGroup];
        [self.tableView reloadData];
    });
}


#pragma mark -- handle xmpp message
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:CrossXMPPMessageReceived object:nil];
   
    //add keyboard view show notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossXMPPMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self updateBuddy];
}

- (void)didReceiveMessage:(NSNotification*)notification
{
    XMPPMessage * message = notification.object;
    NSString * messageText = [CrossXMPPMessageDecoder getMessageTextWithMessage:message];
    NSString * fromuser = [CrossXMPPMessageDecoder getFromUserNameWithMessage:message];
    if (messageText)
    {
        CrossMessage * message = [CrossMessage CrossMessageWithText:messageText read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:1] owner:fromuser];
        [self persistenceMessageText:message];
    }
}

- (void)persistenceMessageText:(CrossMessage*)message
{
    CrossMessageDataBaseManager * messageDataBaseManager =  [[CrossMessageManager sharedInstance] databaseManagerForBuddy:self.buddy];
    
    
    void (^CompleteDispatch_block_t)(void) = ^void(void)
    {
        [self refreshTableView];
    };
    self.lastMessage = message;
    [messageDataBaseManager persistenceMessage:message completeBlock:CompleteDispatch_block_t];
}

- (void)updateBuddy
{
    if (self.lastMessage && ![self.buddy.statusMessage isEqualToString:self.lastMessage.text])
    {
        [[CrossBuddyDataBaseManager sharedInstance].readWriteDatabaseConnection
         readWriteWithBlock: ^(YapDatabaseReadWriteTransaction *transaction)
         {
             self.buddy.statusMessage = self.lastMessage.text;
             [self.buddy saveWithTransaction:transaction];
         }];
    }
}

#pragma mark -- message view donot support landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)tableViewScrollLastIndexPath
{
    if([self.messageViewManager numberOfMessageFramesInSection:0] > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[self.messageViewManager getLastMessageFrameIndexPath] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark -- KeyBordViewDelegate
-(void)KeyBordView:(CrossKeyBoardView *)keyBoardView textFieldReturn:(UITextField *)textField
{
    [self tableViewScrollLastIndexPath];
    
    if (textField.text.length > 0)
    {
        CrossAccount * connectedAccount = [CrossAccountManager connectedAccount];
        
        if (connectedAccount)
        {
            CrossMessage * message = [CrossMessage CrossMessageWithText:textField.text read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:0] owner:self.buddy.userName];
            [self persistenceMessageText:message];
            
            id <CrossProtocol> protocol = [[CrossProtocolManager sharedInstance]protocolForAccount:connectedAccount];
            
            if (protocol)
            {
                [protocol sendMessage: message];
            }
        }
        textField.text = @"";
    }
    
}

-(void)KeyBordView:(CrossKeyBoardView *)keyBoardView textFieldBegin:(UITextField *)textField
{
    [self tableViewScrollLastIndexPath];
}

-(void)beginRecord
{
    
}

-(void)finishRecord
{
    
}

#pragma mark -- keyboard show & hide observer

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

//hide keyboard
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

-(void)endEdit
{
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
