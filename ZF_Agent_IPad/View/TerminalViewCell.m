//
//  TerminalViewCell.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/7.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalViewCell.h"

@implementation TerminalViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        
        CGFloat mainBtnW = 100.f;
        CGFloat mainBtnH = 40.f;
        CGFloat mainBtnX = (SCREEN_WIDTH - 160.f);
        if (iOS7) {
            mainBtnX = SCREEN_HEIGHT - 160.f;
        }
        CGFloat mainBtnY = 20.f;
        
        self.terminalLabel = [[UILabel alloc]init];
        _terminalLabel.font = mainFont;
        _terminalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_terminalLabel];
        
        self.posLabel = [[UILabel alloc]init];
        _posLabel.textAlignment = NSTextAlignmentCenter;
        _posLabel.font = mainFont;
        [self addSubview:_posLabel];
        
        self.payRoad = [[UILabel alloc]init];
        _payRoad.textAlignment = NSTextAlignmentCenter;
        _payRoad.font = mainFont;
        [self addSubview:_payRoad];
        
        self.dredgeStatus = [[UILabel alloc]init];
        _dredgeStatus.font = mainFont;
        _dredgeStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dredgeStatus];
        
        
         //已开通无视频
         if ([reuseIdentifier isEqualToString:@"cell-10"]) {
            
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                    button.layer.masksToBounds=YES;
                    button.layer.borderWidth=1.0;
                    button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                    button.backgroundColor = [UIColor clearColor];
                   // button.tag = 1000+i;
                     button.tag = 1000+i;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX-(i * 115) , mainBtnY, mainBtnW, mainBtnH);
                    [self addSubview:button];
                    if (i == 0) {
                        [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
                    }
                   // if (i == 1) {
                   //     [button setTitle:@"视频认证" forState:UIControlStateNormal];
                   // }
                }
                
         }
        //已开通有视频
        if ([reuseIdentifier isEqualToString:@"cell-11"]) {
        
        
             for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                button.layer.masksToBounds=YES;
                button.layer.borderWidth=1.0;
                button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                button.backgroundColor = [UIColor clearColor];
                button.tag = 1100+i;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX-(i * 115) , mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                  if (i == 0) {
                      [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
                  }
                   if (i == 1) {
                       [button setTitle:@"视频认证" forState:UIControlStateNormal];
                   }
             }
      }
        
        //部分开通无视频
        if ([reuseIdentifier isEqualToString:@"cell-20"]) {
        
                for (int i = 0; i < 3; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                    button.layer.masksToBounds=YES;
                    button.layer.borderWidth=1.0;
                    button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                    button.backgroundColor = [UIColor clearColor];
                    button.tag = i + 2000;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
                    [self addSubview:button];
                    
                    if (i == 0) {
                        [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
                    }
                    if (i == 1) {
                        [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
                    }
                    if (i == 2) {
                        [button setTitle:@"同步" forState:UIControlStateNormal];
                    }
                }
       
        }
        //部分开通有视频
        if ([reuseIdentifier isEqualToString:@"cell-21"]) {
            
            for (int i = 0; i < 4; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                button.layer.masksToBounds=YES;
                button.layer.borderWidth=1.0;
                button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 2100;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                
                if (i == 0) {
                    [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
                }
                if (i == 1) {
                    [button setTitle:@"视频认证" forState:UIControlStateNormal];
                }
                if (i == 2) {
                    [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
                }
                if (i == 3) {
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
            
        }
         //未开通无视频
        if ([reuseIdentifier isEqualToString:@"cell-30"]) {
       
            for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                button.layer.masksToBounds=YES;
                button.layer.borderWidth=1.0;
                button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 3000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                
                    if (i == 0) {
                        [button setTitle:@"申请开通" forState:UIControlStateNormal];
                    }
                    if (i == 1) {
                        [button setTitle:@"同步" forState:UIControlStateNormal];
                    }
        
            }
    
       }
        //未开通有视频
        if ([reuseIdentifier isEqualToString:@"cell-31"]) {
            
                for (int i = 0; i < 3; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                    button.layer.masksToBounds=YES;
                    button.layer.borderWidth=1.0;
                    button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                    button.backgroundColor = [UIColor clearColor];
                    button.tag = i + 3100;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
                    [self addSubview:button];
                    if (i == 0) {
                        [button setTitle:@"视频认证" forState:UIControlStateNormal];
                    }
                    if (i == 1) {
                        [button setTitle:@"申请开通" forState:UIControlStateNormal];
                    }
                    if (i == 2) {
                        [button setTitle:@"同步" forState:UIControlStateNormal];
                    }
                    
                }
            
        }
        //zhuxiiao
        if ([reuseIdentifier isEqualToString:@"cell-40"]||[reuseIdentifier isEqualToString:@"cell-41"])
        {
            
            
        }
        
        //tingyong
      if ([reuseIdentifier isEqualToString:@"cell-50"]||[reuseIdentifier isEqualToString:@"cell-51"]) {
            //for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                button.layer.masksToBounds=YES;
                button.layer.borderWidth=1.0;
                button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                button.backgroundColor = [UIColor clearColor];
               // button.tag = i + 4000;
                button.tag = 5000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
               // button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
                button.frame = CGRectMake(mainBtnX , mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
              //  if (i == 0) {
              //      [button setTitle:@"更新资料" forState:UIControlStateNormal];
              //  }
               // if (i == 0) {
                    [button setTitle:@"同步" forState:UIControlStateNormal];
               // }
            //}
        }
        
        
      
        
        UILabel * line1 = [[UILabel alloc] init];
        [line1 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
        [self.contentView addSubview:line1];
        [line1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.right.equalTo(self.contentView.right);
            make.bottom.equalTo(self.contentView.bottom);
            make.height.equalTo(@1);
        }];
    }
    return self;
}



-(void)buttonClick:(UIButton *)button
{
    [self.TerminalViewCellDelegate terminalCellBtnClicked:button.tag WithSelectedID:_selectedID Withindex:_indexNum];
}


#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainWidth = 160.f;
    CGFloat mainheight = 24.f;
    CGFloat mainY = 30.f;
    
    _terminalLabel.frame = CGRectMake(0, mainY, mainWidth, mainheight);
    
   // _posLabel.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) + 20, mainY, mainWidth * 0.5, mainheight);
    _posLabel.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame)+12, mainY, mainWidth * 0.3, mainheight);
    
    _payRoad.frame = CGRectMake(CGRectGetMaxX(_posLabel.frame) + 66, mainY, mainWidth * 0.5 + 30, mainheight);
    
    _dredgeStatus.frame = CGRectMake(CGRectGetMaxX(_payRoad.frame) + 20, mainY, mainWidth * 0.5, mainheight);
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
