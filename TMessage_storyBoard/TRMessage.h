//
//  TRMessage.h
//  TMessage_storyBoard
//
//  Created by tarena on 16/5/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息模型
@interface TRMessage : NSObject
@property(nonatomic,strong)NSString* content;
@property(nonatomic,getter=isFromMe)BOOL fromMe;
@end
