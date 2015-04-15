//
//  TerminalDetailViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalDetailViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "RateModel.h"
#import "OpeningModel.h"
#import "FormView.h"
#import "OpeningDetailsModel.h"
#import "RecordModel.h"
#import "RecordView.h"
#import "ApplyDetailController.h"

@interface TerminalDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *records; //保存追踪记录

@property (nonatomic, strong) NSMutableArray *ratesItems; //保存费率

@property (nonatomic, strong) NSMutableArray *openItems;   //保存开通资料

/**终端信息*/
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *terminalNum;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantPhone;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) int page;

@property(nonatomic,strong)UIImageView *findPosView;

@property(nonatomic,strong)OpeningModel *openModel;
@property(nonatomic,strong)OpeningDetailsModel *openDetails;

@property(strong,nonatomic) UIButton * frontIMGBtn;
@property(strong,nonatomic) UIButton * backIMGBtn;
@property(strong,nonatomic) UIButton * bodyIMGBtn;
@property(strong,nonatomic) UIButton * licenseIMGBtn;
@property(strong,nonatomic) UIButton * taxIMGBtn;
@property(strong,nonatomic) UIButton * organzationIMGBtn;
@property(strong,nonatomic) UIButton * bankIMGBtn;
@property(strong,nonatomic) UIButton * personIMGBtn;
@property(strong,nonatomic) UIButton * privatebankIMGBtn;

@property(nonatomic,assign) float recordHeight;


@end

@implementation TerminalDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"终端详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化数据
    _records = [[NSMutableArray alloc] init];
    _ratesItems = [[NSMutableArray alloc] init];
    _openItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
   [self downloadDataWithPage:self.page isMore:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI

-(void)initAndLayoutUI
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = kColor(255, 254, 254, 1.0);
    
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initBtn];
    [self initSubViews];
    
    [_scrollView layoutSubviews];
    if (iOS8) {
        
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _privatebankIMGBtn.frame.origin.y+100+_recordHeight)];
    }
    
}

-(void)initBtn
{
    CGFloat mainBtnW = 110.f;
    CGFloat mainBtnH = 40.f;
    CGFloat mainBtnX = (SCREEN_WIDTH - 180.f);
    if (iOS7) {
        mainBtnX = SCREEN_HEIGHT - 180.f;
    }
    CGFloat mainBtnY = 60.f;
    if ([_dealStatus isEqualToString:@"1"]) {
        //已开通
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor colorWithHexString:@"006df5"] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.borderWidth=1.0;
            button.layer.borderColor=[UIColor colorWithHexString:@"006df5"].CGColor;
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 3333;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
            if (i == 0) {
                [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"视频认证" forState:UIControlStateNormal];
            }
        }
        
    }
    if ([_dealStatus isEqualToString:@"2"]) {
        //部分开通
        for (int i = 0; i < 4; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor colorWithHexString:@"006df5"] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.borderWidth=1.0;
            button.layer.borderColor=[UIColor colorWithHexString:@"006df5"].CGColor;
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 4444;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
            if (i == 0) {
                [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"视频认证" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
            }
            if (i == 2) {
                [button setTitle:@"同步" forState:UIControlStateNormal];
            }
            
        }
        
    }
    if ([_dealStatus isEqualToString:@"3"]) {
        //未开通
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor colorWithHexString:@"006df5"] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.borderWidth=1.0;
            button.layer.borderColor=[UIColor colorWithHexString:@"006df5"].CGColor;
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 5555;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
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
    if ([_dealStatus isEqualToString:@"4"]) {
        //已注销
        
    }
    if ([_dealStatus isEqualToString:@"5"]) {
        //已停用
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor colorWithHexString:@"006df5"] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.borderWidth=1.0;
            button.layer.borderColor=[UIColor colorWithHexString:@"006df5"].CGColor;
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 7777;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
            if (i == 0) {
                [button setTitle:@"更新资料" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"同步" forState:UIControlStateNormal];
            }
        }
    }
}

-(void)initSubViews
{
    CGFloat topSpace = 30.f;
    CGFloat leftSpace = 70.f;
    CGFloat rightSpace = 70.f;
    CGFloat labelHeight = 20.f;
    CGFloat space = 4.f; //label间垂直间距
    CGFloat lineSpace = 20.f;
    CGFloat titleLabelHeight = 40.f;
    
    //开通状态
    UILabel *statusTitleLabel = [[UILabel alloc]init];
    statusTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusTitleLabel.backgroundColor = [UIColor clearColor];
    statusTitleLabel.font = [UIFont systemFontOfSize:18];
    statusTitleLabel.text = @"开通状态：";
    [self.scrollView addSubview:statusTitleLabel];
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
    
    //状态
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.scrollView addSubview:statusLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace * 1.6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:80]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight * 1.4]];
    statusLabel.text = @"部分开通";
    
    //划线
    UIView *firstLine = [[UIView alloc]init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(218, 218, 218, 1.0);
    [self.scrollView addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:statusLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    
    //终端信息
    UILabel *terminalTitleLabel = [[UILabel alloc]init];
    terminalTitleLabel.text = @"终端信息";
    terminalTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    terminalTitleLabel.backgroundColor = [UIColor clearColor];
    terminalTitleLabel.textColor = kColor(68, 68, 68, 1.0);
    terminalTitleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.scrollView addSubview:terminalTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace + 10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
    //划线蓝色
    UIView *secondLine = [[UIView alloc]init];
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    secondLine.backgroundColor = [UIColor colorWithHexString:@"006df5"];
    [self.scrollView addSubview:secondLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    
    //终端号136
    UILabel *terminalNumberLabel = [[UILabel alloc] init];
    [self setLabel:terminalNumberLabel withTopView:secondLine middleSpace:space titleName:@"终 端 号"];
    //POS品牌
    UILabel *brandLabel = [[UILabel alloc] init];
    [self setLabel:brandLabel withTopView:terminalNumberLabel middleSpace:space titleName:@"POS品牌"];
    //POS型号
    UILabel *modelLabel = [[UILabel alloc] init];
    [self setLabel:modelLabel withTopView:brandLabel middleSpace:space titleName:@"POS型号"];
    //支付平台
    UILabel *channelLabel = [[UILabel alloc] init];
    [self setLabel:channelLabel withTopView:modelLabel middleSpace:space titleName:@"支付平台"];
    //商户名
    UILabel *merchantNameLabel = [[UILabel alloc] init];
    [self setLabel:merchantNameLabel withTopView:channelLabel middleSpace:space titleName:@"商 户 名"];
    //商户电话 236
    UILabel *merchantPhoneLabel = [[UILabel alloc] init];
    [self setLabel:merchantPhoneLabel withTopView:merchantNameLabel middleSpace:space titleName:@"商户电话"];
    //订单号
    UILabel *orderLabel = [[UILabel alloc] init];
    [self setLabel:orderLabel withTopView:merchantPhoneLabel middleSpace:space titleName:@"订 单 号"];
    //订购时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self setLabel:timeLabel withTopView:orderLabel middleSpace:space titleName:@"订购时间"];


    //费率表
#pragma mark 改表格时记得改View里的宽度 传左右限制值
    CGFloat rateHeight = [FormView heightWithRowCount:[_ratesItems count] hasTitle:NO];
    FormView *formView = [[FormView alloc] init];
    formView.translatesAutoresizingMaskIntoConstraints = NO;
    [formView setRateData:_ratesItems];
    [_scrollView addSubview:formView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:secondLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space * 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:500.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-50.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                          constant:rateHeight]];
    
    
    //开通信息
    UILabel *openTitleLabel = [[UILabel alloc] init];
    openTitleLabel.text = @"开通详情";
    openTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    openTitleLabel.backgroundColor = [UIColor clearColor];
    openTitleLabel.textColor = kColor(68, 68, 68, 1.0);
    openTitleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.scrollView addSubview:openTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:timeLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线
    UIView *thirdLine = [[UIView alloc] init];
    thirdLine.translatesAutoresizingMaskIntoConstraints = NO;
    thirdLine.backgroundColor = [UIColor colorWithHexString:@"006df5"];
    [self.scrollView addSubview:thirdLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:openTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    
    
    
    //开通类型
    UILabel *typeLB = [[UILabel alloc] init];
    typeLB.text=@"开通类型";
    typeLB.font = FONT18;
    typeLB.textColor = kColor(68, 68, 68, 1.0);
    typeLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:typeLB];
    [typeLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdLine.left);
        make.top.equalTo(thirdLine.bottom).offset(18);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    UILabel *typeDetailLB = [[UILabel alloc] init];
    typeDetailLB.font = FONT18;
    typeDetailLB.textColor = kColor(68, 68, 68, 1.0);
    typeDetailLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:typeDetailLB];
    [typeDetailLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB.right);
        make.top.equalTo(thirdLine.bottom).offset(18);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    ///商户资料
    UILabel *inforLB = [[UILabel alloc] init];
    inforLB.text=@"商户资料";
    inforLB.font = FONT18;
    inforLB.textColor = kColor(68, 68, 68, 1.0);
    inforLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:inforLB];
    [inforLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB.left);
        make.top.equalTo(typeLB.bottom).offset(4);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    UILabel *inforDetailLB = [[UILabel alloc] init];
    inforDetailLB.font = FONT18;
    inforDetailLB.textColor = kColor(68, 68, 68, 1.0);
    inforDetailLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:inforDetailLB];
    [inforDetailLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inforLB.right);
        make.top.equalTo(typeLB.bottom).offset(4);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];

    //名    称
    UILabel *nameLB = [[UILabel alloc] init];
    nameLB.text=@"名       称";
    nameLB.font = FONT18;
    nameLB.textColor = kColor(68, 68, 68, 1.0);
    nameLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:nameLB];
    [nameLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB.left);
        make.top.equalTo(inforLB.bottom).offset(4);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    UILabel *nameDetailLB = [[UILabel alloc] init];
    nameDetailLB.font = FONT18;
    nameDetailLB.textColor = kColor(68, 68, 68, 1.0);
    nameDetailLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:nameDetailLB];
    [nameDetailLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLB.right);
        make.top.equalTo(inforLB.bottom).offset(4);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    //商户电话
    UILabel *phoneLB = [[UILabel alloc] init];
    phoneLB.text=@"商户电话";
    phoneLB.font = FONT18;
    phoneLB.textColor = kColor(68, 68, 68, 1.0);
    phoneLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:phoneLB];
    [phoneLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB.left);
        make.top.equalTo(nameLB.bottom).offset(4);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    //商户电话
    UILabel *phoneDetailLB = [[UILabel alloc] init];
    phoneDetailLB.font = FONT18;
    phoneDetailLB.textColor = kColor(68, 68, 68, 1.0);
    phoneDetailLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:phoneDetailLB];
    [phoneDetailLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLB.right);
        make.top.equalTo(nameLB.bottom).offset(4);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];

    
    //营业执照
    UILabel *licenseImageLB=[[UILabel alloc ] init];
    licenseImageLB.font = FONT20;
    licenseImageLB.text=@"营业执照照片";
    licenseImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    licenseImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:licenseImageLB];
    [licenseImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLB.left);
        make.top.equalTo(phoneLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];

    
    _licenseIMGBtn=[[UIButton alloc] init];
    [_licenseIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_licenseIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_licenseIMGBtn setHidden:YES];
    [_scrollView addSubview:_licenseIMGBtn];
    [_licenseIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(licenseImageLB.top);
        make.left.equalTo(licenseImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
    
    UILabel *frontImageLB=[[UILabel alloc ] init];
    frontImageLB.font = FONT20;
    frontImageLB.text=@"法人身份证照正面";
    frontImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    frontImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:frontImageLB];
    [frontImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_licenseIMGBtn.right).offset(64);
        make.top.equalTo(licenseImageLB.top);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    _frontIMGBtn=[[UIButton alloc] init];
    [_frontIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_frontIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_frontIMGBtn setHidden:YES];
    [_scrollView addSubview:_frontIMGBtn];
    [_frontIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(frontImageLB.top);
        make.left.equalTo(frontImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];


    
    UILabel *organzationImageLB=[[UILabel alloc ] init];
    organzationImageLB.font = FONT20;
    organzationImageLB.text=@"组织机构照片";
    organzationImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    organzationImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:organzationImageLB];
    [organzationImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(licenseImageLB.left);
        make.top.equalTo(licenseImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    _organzationIMGBtn=[[UIButton alloc] init];
    [_organzationIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_organzationIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_organzationIMGBtn setHidden:YES];
    [_scrollView addSubview:_organzationIMGBtn];
    [_organzationIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(organzationImageLB.top);
        make.left.equalTo(organzationImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
    
    
    UILabel *backImageLB=[[UILabel alloc ] init];
    backImageLB.font = FONT20;
    backImageLB.text=@"法人身份证照背面";
    backImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    backImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:backImageLB];
    [backImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_organzationIMGBtn.right).offset(64);
        make.top.equalTo(organzationImageLB.top);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    

    
    _backIMGBtn=[[UIButton alloc] init];
    [_backIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_backIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backIMGBtn setHidden:YES];
    [_scrollView addSubview:_backIMGBtn];
    [_backIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageLB.top);
        make.left.equalTo(backImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
///
    
    ///银行开户许可证照片
    UILabel *bankImageLB=[[UILabel alloc ] init];
    bankImageLB.font = FONT20;
    bankImageLB.text=@"对公银行卡照片";
    bankImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    bankImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:bankImageLB];
    [bankImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(organzationImageLB.mas_left);
        make.top.equalTo(organzationImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    

    
    _bankIMGBtn=[[UIButton alloc] init];
    [_bankIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_bankIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bankIMGBtn setHidden:YES];
    [_scrollView addSubview:_bankIMGBtn];
    [_bankIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankImageLB.top);
        make.left.equalTo(bankImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];

    
    
    UILabel *bodyImageLB=[[UILabel alloc ] init];
    bodyImageLB.font = FONT20;
    bodyImageLB.text=@"个人上半身照片";
    bodyImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    bodyImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:bodyImageLB];
    [bodyImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bankIMGBtn.right).offset(64);
        make.top.equalTo(bankImageLB.top);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    
    _bodyIMGBtn=[[UIButton alloc] init];
    [_bodyIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_bodyIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bodyIMGBtn setHidden:YES];
    [_scrollView addSubview:_bodyIMGBtn];
    [_bodyIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyImageLB.top);
        make.left.equalTo(bodyImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
    
    //
    UILabel *taxImageLB=[[UILabel alloc ] init];
    taxImageLB.font = FONT20;
    taxImageLB.text=@"税务登记证照片";
    taxImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    taxImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:taxImageLB];
    [taxImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankImageLB.left);
        make.top.equalTo(bankImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    _taxIMGBtn=[[UIButton alloc] init];
    [_taxIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_taxIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_taxIMGBtn setHidden:YES];
    [_scrollView addSubview:_taxIMGBtn];
    [_taxIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taxImageLB.top);
        make.left.equalTo(taxImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
    
    UILabel *personImageLB=[[UILabel alloc ] init];
    personImageLB.font = FONT20;
    personImageLB.text=@"个人签名照片";
    personImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    personImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:personImageLB];
    [personImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_taxIMGBtn.right).offset(64);
        make.top.equalTo(taxImageLB.top);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    _personIMGBtn=[[UIButton alloc] init];
    [_personIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_personIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_personIMGBtn setHidden:YES];
    [_scrollView addSubview:_personIMGBtn];
    [_personIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taxImageLB.top);
        make.left.equalTo(personImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
    
    ///银行开户许可证照片
    UILabel *privatebankImageLB=[[UILabel alloc ] init];
    privatebankImageLB.font = FONT20;
    privatebankImageLB.text=@"对私银行卡照片";
    privatebankImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    privatebankImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:privatebankImageLB];
    [privatebankImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(taxImageLB.left);
        make.top.equalTo(taxImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    
    _privatebankIMGBtn=[[UIButton alloc] init];
    [_privatebankIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_privatebankIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_privatebankIMGBtn setHidden:YES];
    [_scrollView addSubview:_privatebankIMGBtn];
    [_privatebankIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(privatebankImageLB.top);
        make.left.equalTo(privatebankImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];

    
    UILabel *otherImageLB=[[UILabel alloc ] init];
    otherImageLB.font = FONT20;
    otherImageLB.text=@"其他照片";
    otherImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    otherImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:otherImageLB];
    [otherImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_privatebankIMGBtn.right).offset(64);
        make.top.equalTo(privatebankImageLB.top);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    _personIMGBtn=[[UIButton alloc] init];
    [_personIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_personIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_personIMGBtn setHidden:YES];
    [_scrollView addSubview:_personIMGBtn];
    [_personIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(privatebankImageLB.top);
        make.left.equalTo(personImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
    //跟踪记录
     _recordHeight = 0.f;
    if ([self.records count] > 0) {
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = kColor(108, 108, 108, 1);
        tipLabel.font = [UIFont systemFontOfSize:18];
        tipLabel.text = @"追踪记录：";
        [_scrollView addSubview:tipLabel];
        [tipLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(privatebankImageLB.bottom).offset(40);
            make.left.equalTo(privatebankImageLB.left);
            make.height.equalTo(@42);
            make.width.equalTo(@(120));
            
        }];

        
        RecordView *recordView = [[RecordView alloc] initWithRecords:self.records
                                                               width:(kScreenWidth - leftSpace * 2)];
        recordView.translatesAutoresizingMaskIntoConstraints = NO;
        _recordHeight = [recordView getHeight];
        [self.scrollView addSubview:recordView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:tipLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:4.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:_recordHeight]];
        [recordView initAndLayoutUI];

    
    }
    
  


    
    terminalTitleLabel.text = @"终端信息";
    openTitleLabel.text = @"开通详情";
    statusLabel.text = [self getStatusString];
    terminalNumberLabel.text = _terminalNum;
    brandLabel.text = _brand;
    modelLabel.text = _model;
    channelLabel.text = _channel;
    merchantNameLabel.text = _merchantName;
    merchantPhoneLabel.text = _merchantPhone;
    orderLabel.text = _orderNumber;
    timeLabel.text = _createTime;
    
    typeDetailLB.text=_openModel.openType;
    inforDetailLB.text=_openModel.infor;
    nameDetailLB.text=_openModel.name;
    phoneDetailLB.text=_openModel.phone;
    
}


-(void)BtnImagePressed:(id)sender
{


}


- (NSString *)getStatusString {
    NSString *statusString = nil;
    int index = [_dealStatus intValue];
    switch (index) {
        case TerminalStatusOpened:
            statusString = @"已开通";
            break;
        case TerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case TerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case TerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}


#pragma mark - Layout

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
       titleName:(NSString *)title {
    CGFloat leftSpace = 70.f;
    CGFloat rightSpce = 20.f;
    CGFloat labelHeight = 18.f;
    CGFloat vSpace = 4.f;
    CGFloat titleWidth = 120.f;
    
    //标题label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textColor = kColor(68, 68, 68, 1.0);
    titleLabel.text = title;
    [_scrollView addSubview:titleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:titleWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.f];
    label.textColor = kColor(68, 68, 68, 1.0);
    [_scrollView addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:vSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
}


#pragma mark - Request

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"_tm_ID:%@",_tm_ID);
    [NetworkInterface getTerminalDetailWithToken:delegate.token terminalsId:_tm_ID finished:^(BOOL success, NSData *response) {
        NSLog(@"请求结果：%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseTerminalDetailDataWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseTerminalDetailDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    NSLog(@"infoDict:%@",infoDict);
    
    
    //开通详情
    if ([[infoDict objectForKey:@"openingInfos"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *openInfosDict = [infoDict objectForKey:@"openingInfos"];
        _openModel = [[OpeningModel alloc] initWithParseDictionary:openInfosDict];
        NSLog(@"kaitong:::%@",_openModel);

    }
    
    
    if ([[infoDict objectForKey:@"applyDetails"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *applyDict = [infoDict objectForKey:@"applyDetails"];
        if ([applyDict objectForKey:@"status"]) {
            _status = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"status"]];
        }
        if ([applyDict objectForKey:@"serial_num"]) {
            _terminalNum = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"serial_num"]];
        }
        if ([applyDict objectForKey:@"brandName"]) {
            _brand = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"brandName"]];
        }
        
        if ([applyDict objectForKey:@"model_number"]) {
            _model = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"model_number"]];
        }
        
        if ([applyDict objectForKey:@"channelName"]) {
            _channel = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"channelName"]];
        }
        if ([applyDict objectForKey:@"title"]) {
            _merchantName = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"title"]];
        }
        if ([applyDict objectForKey:@"phone"]) {
            _merchantPhone = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"phone"]];
        }
        if ([applyDict objectForKey:@"order_number"]) {
            _orderNumber = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"order_number"]];
        }
        if ([applyDict objectForKey:@"createdAt"]) {
            _createTime = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"createdAt"]];
        }
    }
    //费率
    id rateObject = [infoDict objectForKey:@"rates"];
    if ([rateObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [rateObject count]; i++) {
            id dict = [rateObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RateModel *model = [[RateModel alloc] initWithParseDictionary:dict];
                [self.ratesItems addObject:model];
            }
        }
    }
    
    //开通资料
    id openObject = [infoDict objectForKey:@"openingDetails"];
    NSLog(@"opemObject:%@",openObject);
    if ([openObject isKindOfClass:[NSArray class]]) {
        NSLog(@"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
        for (int i = 0; i < [openObject count]; i++) {
            id dict = [openObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                _openDetails= [[OpeningDetailsModel alloc] initWithParseDictionary:dict];
                [self.openItems addObject:_openDetails];
                NSLog(@"opemItems:%@",self.openItems);
            }
        }
    }
 
 
    
    //跟踪记录
    id recordObject = [infoDict objectForKey:@"trackRecord"];
    if ([recordObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [recordObject count]; i++) {
            id dict = [recordObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RecordModel *model = [[RecordModel alloc] initWithParseTerminalDictionary:dict];
                [self.records addObject:model];
            }
        }
    }
    [self initSubViews];
    [self get];
}


-(void)get
{
   for (int i = 0; i < [_openItems count]; i++) {
        id dict = [_openItems objectAtIndex:i];
        if ([dict isKindOfClass:[NSDictionary class]]) {
    
     if ([dict objectForKey:@"头像照片wm"]) {
        [_frontIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"营业执照wm"]) {
        [_backIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"头像照片wm"]) {
        [_bodyIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"头像照片wm"]) {
        [_licenseIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"头像照片wm"]) {
        [_taxIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"头像照片wm"]) {
        [_bankIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"头像照片wm"]) {
        [_organzationIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"头像照片wm"]) {
        [_organzationIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"头像照片wm"]) {
        [_organzationIMGBtn setHidden:NO];
    }
    if ([dict objectForKey:@"头像照片wm"]) {
        [_organzationIMGBtn setHidden:NO];
    }
     }
   }
}


#pragma mark ---按钮点击时间

-(void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 3333:
            NSLog(@"点击了找回POS密码（已开通）");
            [self initFindPosViewWithSelectedID];
            break;
        case 3334:
            NSLog(@"点击了视频认证（已开通）");
            break;
        case 4444:
            NSLog(@"点击了找回POS密码（部分开通）");
            break;
        case 4445:
            NSLog(@"点击了视频认证（部分开通）");
            break;
        case 4446:
            NSLog(@"点击了重新申请通（部分开通）");
            [self pushApplyVCWithSelectedID:_tm_ID];
            break;
        case 4447:
            NSLog(@"点击了同步（部分开通）");
            break;
        case 5555:
            NSLog(@"点击了视频认证（未开通）");
            break;
        case 5556:
            NSLog(@"点击了申请开通（未开通）");
            [self pushApplyNewVCWithSelectedID:_tm_ID];
            break;
        case 5557:
            NSLog(@"点击了同步（未开通）");
            break;
        case 6666:
            NSLog(@"点击了租凭退换（已注销）");
            break;
        case 7777:
            NSLog(@"点击了更新资料（已停用）");
            break;
        case 7778:
            NSLog(@"点击了同步（已停用）");
            break;
            
        default:
            break;
    }
}
//重新申请开通
-(void)pushApplyNewVCWithSelectedID:(NSString *)selectedID
{
    
    ApplyDetailController *detailVC = [[ApplyDetailController alloc] init];
    detailVC.terminalID = selectedID;
    detailVC.openStatus = OpenStatusReopen;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


//新开通
-(void)pushApplyVCWithSelectedID:(NSString *)selectedID
{
    
    ApplyDetailController *detailVC = [[ApplyDetailController alloc] init];
    detailVC.terminalID = selectedID;
    detailVC.openStatus = OpenStatusNew;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - Action

/*
- (void)scanImage:(id)sender {
    UIButton *btn = (UIButton *)sender;
    CGRect convertRect = [[btn superview] convertRect:btn.frame toView:self.view];
    for (OpeningModel *model in _openItems) {
        if (model.type == ResourceImage && btn.tag == model.index + 1) {
            [self showDetailImageWithURL:model.resourceValue imageRect:convertRect];
            break;
        }
    }
}
*/

-(void)initFindPosViewWithSelectedID
{
    CGFloat width;
    CGFloat height;
    if(iOS7)
    {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
    }
    else
    {
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
    }
    _findPosView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:_findPosView];
    _findPosView.image=[UIImage imageNamed:@"backimage"];
    _findPosView.userInteractionEnabled=YES;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 220)];
    whiteView.center = CGPointMake(width / 2, (height - 100) / 2);
    whiteView.backgroundColor = [UIColor whiteColor];
    [_findPosView addSubview:whiteView];
    
    UIButton *leftXBtn = [[UIButton alloc]init];
    [leftXBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftXBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    leftXBtn.frame = CGRectMake(15, 15, 25, 25);
    [whiteView addSubview:leftXBtn];
    
    UILabel *FindPOSLable = [[UILabel alloc]init];
    FindPOSLable.text = @"找回POS密码";
    FindPOSLable.textColor = kColor(38, 38, 38, 1.0);
    FindPOSLable.font = [UIFont systemFontOfSize:22];
    FindPOSLable.frame = CGRectMake(150, 10, 200, 40);
    [whiteView addSubview:FindPOSLable];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(128, 128, 128, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(FindPOSLable.frame) + 10, whiteView.frame.size.width, 1);
    [whiteView addSubview:line];
    
    UILabel *POSLable = [[UILabel alloc]init];
    POSLable.text = @"POS机密码";
    POSLable.textColor = kColor(56, 56, 56, 1.0);
    POSLable.font = [UIFont systemFontOfSize:20];
    POSLable.frame = CGRectMake(FindPOSLable.frame.origin.x - 40, CGRectGetMaxY(line.frame) + 50, 120, 30);
    [whiteView addSubview:POSLable];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.textColor = kColor(132, 132, 132, 1.0);
    passwordLabel.font = [UIFont systemFontOfSize:20];
    NSLog(@"点了第%@个ID",_tm_ID);
    passwordLabel.text = @"asdasdas";
    passwordLabel.frame = CGRectMake(CGRectGetMaxX(POSLable.frame), POSLable.frame.origin.y, 300, 30);
    [whiteView addSubview:passwordLabel];
    
}

-(void)leftClicked
{
    [_findPosView removeFromSuperview];
}

-(void)viewDidLayoutSubviews
{
    if (iOS8) {
        
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _privatebankIMGBtn.frame.origin.y+200+_recordHeight)];
    }

    if (iOS7) {
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.height,  _privatebankIMGBtn.frame.origin.y+200+_recordHeight);
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    if (iOS8) {
        
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _privatebankIMGBtn.frame.origin.y+200+_recordHeight)];
    }
    if (iOS7) {
        
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.height, _privatebankIMGBtn.frame.origin.y+200+_recordHeight)];
    }

}


@end