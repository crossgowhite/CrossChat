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

#import "CrossMessage.h"

#import "CrossConstants.h"
#import "CrossKeyBoardView.h"


#import "CrossArrayDataSource.h"
#import "CrossViewManager.h"
#import "CrossMessageViewManager.h"
#import "CrossChatService.h"

static NSString *MesageCellIdentifier = @"MessageCell";

@interface CrossMessageViewController () <KeyBordViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) CrossKeyBoardView * keyBoardView;

@property (nonatomic, strong) CrossViewManager * messageViewManager;
@property (nonatomic, strong) CrossArrayDataSource * messageArrayDataSource;
@end



@implementation CrossMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTableView];
    self.title = self.buddy.displayName;
    
//    [self.tableView registerClass:[CrossMessageTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.messageViewManager = [[CrossMessageViewManager alloc]initWithCrossBuddy:self.buddy];
    
 #define KEYBOARDHEITHT 68
    //init key board view
    self.keyBoardView= [[CrossKeyBoardView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, KEYBOARDHEITHT)];
    self.keyBoardView.delegate = self;
    
    [self.view addSubview:self.keyBoardView];
    
    TableViewCellConfigureBlock configureCell = ^(CrossMessageTableViewCell *cell, CrossMessageFrame *messageFrame)
    {
        [cell setMessageFrame:messageFrame];
    };
    self.messageArrayDataSource = [[CrossArrayDataSource alloc]initWithViewManager:self.messageViewManager cellIdentifier:MesageCellIdentifier configureCellBlock:configureCell cellClass:[CrossMessageTableViewCell class]];
    self.tableView.dataSource = self.messageArrayDataSource;
    
    [self tableViewScrollLastIndexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrossMessageFrame * messageFrame = [self.messageViewManager itemAtSection:indexPath.section row:indexPath.row];
    return [messageFrame messageHeight];
}

#pragma mark -- init table View
- (void)initTableView
{
    self.tableView.allowsSelection = NO;
}

- (void)refreshTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageViewManager refreshArrayGroup];
        [self.tableView reloadData];
    });
}


#pragma mark -- handle xmpp message
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:CrossMessageReceived object:nil];
   
    //add keyboard view show notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CrossMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self refreshTableView];
    [self tableViewScrollLastIndexPath];
}

- (void)didReceiveMessage:(NSNotification*)notification
{
    [self refreshTableView];
    [self tableViewScrollLastIndexPath];
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
    if([self.messageViewManager numberOfItemsInSection:0] > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[(CrossMessageViewManager*)self.messageViewManager getLastMessageFrameIndexPath] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark -- KeyBordViewDelegate
-(void)KeyBordView:(CrossKeyBoardView *)keyBoardView textFieldReturn:(UITextField *)textField
{
    if (textField.text.length > 0)
    {
        CrossMessage * message = [CrossMessage CrossMessageWithText:textField.text read:[NSNumber numberWithInteger:1] incoming:[NSNumber numberWithInteger:0] owner:self.buddy.userName];
        
        void (^CompleteDispatch_block_t)(void) = ^void(void)
        {
            [self refreshTableView];
            [self tableViewScrollLastIndexPath];
        };
        
        [[CrossChatService sharedInstance] sendMessage:message completeBlock:CompleteDispatch_block_t];
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
