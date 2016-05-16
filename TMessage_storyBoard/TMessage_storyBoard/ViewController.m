//
//  ViewController.m
//  TMessage_storyBoard
//
//  Created by tarena on 16/5/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"
#import "TRMessage.h"
#import "MessageCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
//记录所有的聊天记录
@property(nonatomic,strong)NSMutableArray* messages;

//定义一个cell 原型
@property(nonatomic,strong)MessageCell* prototypeCell;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController


//懒加载

-(NSMutableArray*)messages{

    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //获取cell原型
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    //从plist文件中读取聊天记录
    NSString* filePath = [[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil];
    //获取所有的聊天记录
    NSArray* array = [NSArray arrayWithContentsOfFile:filePath];
    //从array中取出存储的字典数据
    for (NSDictionary* dic in array) {
        TRMessage* message = [[TRMessage alloc]init];
        [message setValuesForKeysWithDictionary:dic];
        [self.messages addObject:message];
    }
}

-(void)viewDidAppear:(BOOL)animated{

    //向通知中心注册观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)openKeyboard:(NSNotification*)notification {

    //获取键盘弹起的动画类型
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    //获取动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //获取键盘弹起后的高度
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //修改约束让输入框上升的高度和键盘升起的高度一致
    self.bottomConstraint.constant = frame.size.height;
    //创建动画，让输入框和键盘完全一致
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        //让修改后的约束起作用
        [self.view layoutIfNeeded];
        [self scrollToTableViewLastRow];
    } completion:nil];
}


-(void)closeKeyboard:(NSNotification*)notification {
    
    //获取键盘收起的动画类型
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    //获取动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //修改约束让输入框上升的高度和键盘升起的高度一致
    self.bottomConstraint.constant = 0;
    //创建动画，让输入框和键盘完全一致
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        //让修改后的约束起作用
        [self.view layoutIfNeeded];
        [self scrollToTableViewLastRow];
    } completion:nil];


}

- (IBAction)sendText:(UITextField *)sender {
    //回收键盘
    [sender resignFirstResponder];
    //发送消息
    if (sender.text.length == 0) {
        return;
    }
    TRMessage* message = [[TRMessage alloc]init];
    message.content = sender.text;
    message.fromMe = YES;
    [self.messages addObject:message];
    //加载数据之后清空输入框
     sender.text = @"";
    //获取indexPath
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self scrollToTableViewLastRow];
}




-(void)viewDidDisappear:(BOOL)animated{

    //从通知中心删除观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}


#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messages.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    TRMessage* message = self.messages[indexPath.row];
    cell.message = message;
    return cell;
}


#pragma mark - TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //返回cell(会调用message的setter方法)
    self.prototypeCell.message = self.messages[indexPath.row];
    return self.prototypeCell.bounds.size.height;
}

-(void)scrollToTableViewLastRow {

    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];

    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}



@end
