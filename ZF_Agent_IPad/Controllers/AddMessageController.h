//
//  AddMessageController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/5/18.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "CommonViewController.h"

@interface AddMessageController : CommonViewController

@property(nonatomic,assign)BOOL isPhone;

@property(nonatomic,assign)BOOL isEmial;

@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *phone;

@property(nonatomic,strong)NSString *userName;

@end
