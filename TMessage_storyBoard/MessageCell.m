//
//  MessageCell.m
//  TMessage_storyBoard
//
//  Created by tarena on 16/5/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

//气泡图片
@property(strong,nonatomic)UIImageView* popImageView;
//显示聊天内容
@property(nonatomic,strong)UILabel* popLabel;

@end




@implementation MessageCell

-(UIImageView*)popImageView {
    if (!_popImageView) {
        _popImageView = [[UIImageView alloc]init];
    }
    return _popImageView;
}


-(UILabel*)popLabel {
    if (!_popLabel) {
        _popLabel = [[UILabel alloc]init];
        _popLabel.numberOfLines = 0;
    }
    return _popLabel;
}

//定义宏数据
#define CELL_MARGIN_TB 4.0 //上下间距
#define CELL_MARGIN_LR 10.0 //左右间距
#define CELL_CORNER 18.0 //圆角半径
#define CELL_TAIL_WIDTH 16.0 //气泡尾长
#define MAX_WIDTH_OF_TEXT 200.0 //文本最大的宽度
#define CELL_PADDING 8.0 //内边距

-(void)setMessage:(TRMessage *)message {
    //将传进来的形参赋值给实例变量
    _message = message;
    self.popLabel.text = message.content;
    
    //开始布局，设置气泡的大小，颜色，方向以及label的位置
    if (message.fromMe) {//蓝色气泡，在视图的右边
        self.popLabel.textColor = [UIColor whiteColor];
        self.popImageView.image = [UIImage imageNamed:@"message_i"];
        
        //设置label的frame
        CGRect rectOfText = [self.popLabel textRectForBounds:CGRectMake(0, 0, MAX_WIDTH_OF_TEXT, 999) limitedToNumberOfLines:0];
        CGRect popLabelFrame = rectOfText;
        popLabelFrame.origin.x = self.bounds.size.width -CELL_MARGIN_LR-CELL_TAIL_WIDTH-CELL_PADDING-rectOfText.size.width;
        popLabelFrame.origin.y = CELL_MARGIN_TB + CELL_PADDING;
        self.popLabel.frame = popLabelFrame;
    
        //设置气泡的frame
        CGRect popImageViewFrame = popLabelFrame;
        popImageViewFrame.origin.x -= CELL_PADDING;
        popImageViewFrame.origin.y -= CELL_MARGIN_TB;
        popImageViewFrame.size.width += CELL_PADDING*2 + CELL_TAIL_WIDTH;
        popImageViewFrame.size.height += CELL_MARGIN_TB*2;
        self.popImageView.frame = popImageViewFrame;
        //更新cell的bounds
        CGRect bounds = self.popImageView.bounds;
        bounds.size.height += CELL_MARGIN_TB*2;
        self.bounds = bounds;
        
    
    }else {//灰色气泡，在视图的左边
    
        self.popLabel.textColor = [UIColor blackColor];
        self.popImageView.image = [UIImage imageNamed:@"message_other"];
        
        //布局左边的气泡和label的位置
        //设置label的frame
        CGRect rectOfText = [self.popLabel textRectForBounds:CGRectMake(0, 0, MAX_WIDTH_OF_TEXT, 999) limitedToNumberOfLines:0];
        CGRect popLabelFrame = rectOfText;
        popLabelFrame.origin.x = CELL_TAIL_WIDTH+CELL_MARGIN_LR+CELL_PADDING;
        popLabelFrame.origin.y = CELL_MARGIN_TB+CELL_PADDING;
        self.popLabel.frame = popLabelFrame;
        
        //设置气泡的frame
        CGRect popImageViewFrame = popLabelFrame;
        popImageViewFrame.origin.x -= (CELL_PADDING+CELL_TAIL_WIDTH);
        popImageViewFrame.origin.y -= CELL_PADDING;
        popImageViewFrame.size.width += CELL_PADDING*2+CELL_TAIL_WIDTH;
        popImageViewFrame.size.height += CELL_PADDING*2;
        self.popImageView.frame = popImageViewFrame;
        //更新cell的bounds
        CGRect bounds = self.popImageView.bounds;
        bounds.size.height += CELL_MARGIN_TB*2;
        self.bounds = bounds;
        
        
    }
    //添加内容
    [self.contentView addSubview:self.popImageView];
    [self.contentView addSubview:self.popLabel];
}











- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
