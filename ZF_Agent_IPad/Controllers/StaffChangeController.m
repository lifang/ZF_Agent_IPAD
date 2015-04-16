//
//  StaffChangeController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/16.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StaffChangeController.h"
#import "StaffButton.h"
#import "NetworkInterface.h"
#import "StaffManagerController.h"

@interface StaffChangeController ()<UITextFieldDelegate,StaffBtnClickedDelegate>
@property(nonatomic,strong)UITextField *loginIDField;

@property(nonatomic,strong)UITextField *nameField;

@property(nonatomic,strong)UITextField *passwordField;

@property(nonatomic,strong)UITextField *makeSureField;

@property(nonatomic,strong)UIButton *bottomBtn;

@property(nonatomic,strong)UILabel *passwordLabel;
@property(nonatomic,strong)UILabel *makeSurePasswordLabel;

/** 状态选中Btn */
@property(nonatomic,strong)StaffButton *firstBtn;
@property(nonatomic,strong)StaffButton *secondBtn;
@property(nonatomic,strong)StaffButton *thirdBtn;
@property(nonatomic,strong)StaffButton *fourthBtn;
@property(nonatomic,strong)StaffButton *fifthBtn;
@property(nonatomic,strong)StaffButton *sixBtn;
@property(nonatomic,strong)StaffButton *seventhBtn;
@property(nonatomic,strong)StaffButton *eighthBtn;

@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,strong)NSMutableArray *statusArray;

@property(nonatomic,strong)NSMutableString *statusStr;
@end

@implementation StaffChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"员工信息修改";
    _statusStr = [[NSMutableString alloc]init];
    _statusArray = [[NSMutableArray alloc]init];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    CGFloat topSpaceBig = 20.f;
    CGFloat topSpaceLittle = 10.f;
    
    UILabel *loginIDLabel = [[UILabel alloc]init];
    loginIDLabel.text = @"登录ID";
    [self setLabel:loginIDLabel WithTopSapce:topSpaceBig * 4 WithTopView:self.view WithLabelTag:1];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"姓名";
    [self setLabel:nameLabel WithTopSapce:topSpaceBig WithTopView:loginIDLabel WithLabelTag:0];
    
    _passwordLabel = [[UILabel alloc]init];
    _passwordLabel.text = @"登录密码";
    [self setLabel:_passwordLabel WithTopSapce:topSpaceBig WithTopView:nameLabel WithLabelTag:0];
    
    _makeSurePasswordLabel = [[UILabel alloc]init];
    _makeSurePasswordLabel.text = @"确认密码";
    [self setLabel:_makeSurePasswordLabel WithTopSapce:topSpaceBig WithTopView:_passwordLabel WithLabelTag:0];
    
    _loginIDField = [[UITextField alloc]init];
    _loginIDField.text = _loginID;
    [self setTextField:_loginIDField WithTopSapce:topSpaceBig * 4 WithTopView:self.view WithfieldTag:1];
    
    _nameField = [[UITextField alloc]init];
    _nameField.text = _name;
    [self setTextField:_nameField WithTopSapce:topSpaceBig WithTopView:_loginIDField WithfieldTag:0];
    
    _passwordField = [[UITextField alloc]init];
    [self setTextField:_passwordField WithTopSapce:topSpaceBig WithTopView:_nameField WithfieldTag:3];
    
    _makeSureField = [[UITextField alloc]init];
    [self setTextField:_makeSureField WithTopSapce:topSpaceBig WithTopView:_passwordField WithfieldTag:4];
    
    UILabel *chooseStaff = [[UILabel alloc]init];
    chooseStaff.text = @"选择员工权限:";
    chooseStaff.font = [UIFont systemFontOfSize:20];
    chooseStaff.backgroundColor = [UIColor clearColor];
    chooseStaff.frame = CGRectMake(CGRectGetMaxX(_loginIDField.frame) + 180, _loginIDField.frame.origin.y, 180, 30);
    [self.view addSubview:chooseStaff];
    
    UILabel *first = [[UILabel alloc]init];
    first.text = @"批购";
    [self setLabel:first WithTopSapce:topSpaceBig WithTopView:self.view WithLabelTag:4];
    
    UILabel *second = [[UILabel alloc]init];
    second.text = @"代购";
    [self setLabel:second WithTopSapce:topSpaceLittle WithTopView:first WithLabelTag:2];
    
    UILabel *third = [[UILabel alloc]init];
    third.text = @"终端管理/售后记录查看";
    [self setLabel:third WithTopSapce:topSpaceLittle WithTopView:second WithLabelTag:2];
    
    UILabel *fouth = [[UILabel alloc]init];
    fouth.text = @"交易分润查询";
    [self setLabel:fouth WithTopSapce:topSpaceLittle WithTopView:third WithLabelTag:2];
    
    UILabel *fifth = [[UILabel alloc]init];
    fifth.text = @"下级代理商管理";
    [self setLabel:fifth WithTopSapce:topSpaceLittle WithTopView:fouth WithLabelTag:2];
    
    UILabel *sixth = [[UILabel alloc]init];
    sixth.text = @"用户管理";
    [self setLabel:sixth WithTopSapce:topSpaceLittle WithTopView:fifth WithLabelTag:2];
    
    UILabel *seventh = [[UILabel alloc]init];
    seventh.text = @"员工账号管理";
    [self setLabel:seventh WithTopSapce:topSpaceLittle WithTopView:sixth WithLabelTag:2];
    
    UILabel *eighth = [[UILabel alloc]init];
    eighth.text = @"代理商资料/收货地址管理";
    [self setLabel:eighth WithTopSapce:topSpaceLittle WithTopView:seventh WithLabelTag:2];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(211, 211, 211, 1.0);
    line.frame = CGRectMake(30, CGRectGetMaxY(eighth.frame) + 50, kScreenWidth - 60, 0.7);
    if (iOS7) {
        line.frame = CGRectMake(30, CGRectGetMaxY(eighth.frame) + 50, kScreenHeight - 60, 0.7);
    }
    [self.view addSubview:line];
    
    _bottomBtn = [[UIButton alloc]init];
    [_bottomBtn addTarget:self action:@selector(bottomClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBtn setBackgroundColor:kMainColor];
    [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
    _bottomBtn.frame = CGRectMake(CGRectGetMaxX(_loginIDField.frame) - 40, CGRectGetMaxY(line.frame) + 40, 260, 40);
    [self.view addSubview:_bottomBtn];
    
    //创建状态Btn
    _firstBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_firstBtn WithTopSpace:topSpaceLittle + 7 WithTopView:chooseStaff WithButtonTag:1];
    
    CGFloat mainMargin = topSpaceLittle * 2 + 5;
    
    _secondBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_secondBtn WithTopSpace:mainMargin WithTopView:_firstBtn WithButtonTag:2];
    
    _thirdBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_thirdBtn WithTopSpace:mainMargin WithTopView:_secondBtn WithButtonTag:3];
    
    _fourthBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_fourthBtn WithTopSpace:mainMargin WithTopView:_thirdBtn WithButtonTag:4];
    
    _fifthBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_fifthBtn WithTopSpace:mainMargin WithTopView:_fourthBtn WithButtonTag:5];
    
    _sixBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_sixBtn WithTopSpace:mainMargin WithTopView:_fifthBtn WithButtonTag:6];
    
    _seventhBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_seventhBtn WithTopSpace:mainMargin WithTopView:_sixBtn WithButtonTag:7];
    
    _eighthBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_eighthBtn WithTopSpace:mainMargin WithTopView:_seventhBtn WithButtonTag:8];
    
    
    [self setcontentBtnStatus];
    
}

-(void)setSelectedBtn:(StaffButton *)button WithTopSpace:(CGFloat)topSpace WithTopView:(UIView *)topButton WithButtonTag:(NSInteger)buttonTag
{
    CGFloat originX = CGRectGetMaxX(_loginIDField.frame) + 190.f;
    CGFloat buttonWidth = 25.f;
    CGFloat buttonHeight = 25.f;
    button.delegate = self;
    button.tag = 5000 + buttonTag;
    [button setImage:kImageName(@"noSelected") forState:UIControlStateNormal];
    button.frame = CGRectMake(originX, CGRectGetMaxY(topButton.frame) + topSpace, buttonWidth, buttonHeight);
    [self.view addSubview:button];
}

-(void)setLabel:(UILabel *)label WithTopSapce:(CGFloat)topSpace WithTopView:(UIView *)toplabel WithLabelTag:(NSInteger)labelTag
{
    CGFloat originX = 60.f;
    CGFloat labelWidth = 100.f;
    CGFloat labelHeight = 40.f;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:20];
    if (labelTag == 2) {
        originX = CGRectGetMaxX(_loginIDField.frame) + 230.f;
        labelWidth = 300.f;
        label.textAlignment = NSTextAlignmentLeft;
    }
    if (labelTag == 4) {
        originX = CGRectGetMaxX(_loginIDField.frame) + 230.f;
        labelWidth = 300.f;
        label.textAlignment = NSTextAlignmentLeft;
    }
    if (labelTag == 1) {
        label.frame = CGRectMake(originX,50 + topSpace, labelWidth, labelHeight);
    }else{
        if (labelTag == 4) {
            label.frame = CGRectMake(originX,150 + topSpace, labelWidth, labelHeight);
        }else{
            label.frame = CGRectMake(originX, CGRectGetMaxY(toplabel.frame) + topSpace, labelWidth, labelHeight);
        }
    }
    [self.view addSubview:label];
}

-(void)setTextField:(UITextField *)textfield WithTopSapce:(CGFloat)topSpace WithTopView:(UIView *)topField WithfieldTag:(NSInteger)fieldTag
{
    CGFloat textWidth = 240.f;
    CGFloat textHeight = 40.f;
    CGFloat originX = 170.f;
    if (fieldTag >= 3) {
        textfield.secureTextEntry = YES;
    }
    textfield.borderStyle = UITextBorderStyleLine;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textfield setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    textfield.delegate = self;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    textfield.leftView = placeholderV;
    CALayer *readBtnLayer = [textfield layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    if (fieldTag == 1) {
        textfield.frame = CGRectMake(originX,50 + topSpace, textWidth, textHeight);
    }else{
        textfield.frame = CGRectMake(originX, CGRectGetMaxY(topField.frame) + topSpace, textWidth, textHeight);
    }
    [self.view addSubview:textfield];
    
}

-(void)setcontentBtnStatus
{
    NSLog(@"_statusDetailArray 有 %@",_statusDetailArray);
    for (int i = 0; i < [_statusDetailArray count]; i++) {
        int statusNum = [[_statusDetailArray objectAtIndex:i] intValue];
        switch (statusNum) {
            case 1:
                [_firstBtn BtnClickedWithButton:_firstBtn];
                break;
            case 2:
                [_secondBtn BtnClickedWithButton:_secondBtn];
                break;
            case 3:
                [_thirdBtn BtnClickedWithButton:_thirdBtn];
                break;
            case 4:
                [_fourthBtn BtnClickedWithButton:_fourthBtn];
                break;
            case 5:
                [_fifthBtn BtnClickedWithButton:_fifthBtn];
                break;
            case 6:
                [_sixBtn BtnClickedWithButton:_sixBtn];
                break;
            case 7:
                [_seventhBtn BtnClickedWithButton:_seventhBtn];
                break;
            case 8:
                [_eighthBtn BtnClickedWithButton:_eighthBtn];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - staffBtn Delegate
-(void)staffClickedWithButton:(StaffButton *)button
{
    if (button.tag == 5001) {
        NSLog(@"点击了第一个空格 并且状态为%d",_firstBtn.isSelected);
        if (_firstBtn.isSelected) {
            [_statusArray addObject:@"1"];
        }else{
            [_statusArray removeObject:@"1"];
        }
    }
    if (button.tag == 5002) {
        NSLog(@"点击了第2个空格 并且状态为%d",_secondBtn.isSelected);
        if (_secondBtn.isSelected) {
            [_statusArray addObject:@"2"];
        }else{
            [_statusArray removeObject:@"2"];
        }
    }
    if (button.tag == 5003) {
        NSLog(@"点击了第3个空格 并且状态为%d",_thirdBtn.isSelected);
        if (_thirdBtn.isSelected) {
            [_statusArray addObject:@"3"];
        }else{
            [_statusArray removeObject:@"3"];
        }
    }
    if (button.tag == 5004) {
        NSLog(@"点击了第4个空格 并且状态为%d",_fourthBtn.isSelected);
        if (_fourthBtn.isSelected) {
            [_statusArray addObject:@"4"];
        }else{
            [_statusArray removeObject:@"4"];
        }
    }
    if (button.tag == 5005) {
        NSLog(@"点击了第5个空格 并且状态为%d",_fifthBtn.isSelected);
        if (_fifthBtn.isSelected) {
            [_statusArray addObject:@"5"];
        }else{
            [_statusArray removeObject:@"5"];
        }
    }
    if (button.tag == 5006) {
        NSLog(@"点击了第6个空格 并且状态为%d",_sixBtn.isSelected);
        if (_sixBtn.isSelected) {
            [_statusArray addObject:@"6"];
        }else{
            [_statusArray removeObject:@"6"];
        }
    }
    if (button.tag == 5007) {
        NSLog(@"点击了第7个空格 并且状态为%d",_seventhBtn.isSelected);
        if (_seventhBtn.isSelected) {
            [_statusArray addObject:@"7"];
        }else{
            [_statusArray removeObject:@"7"];
        }
    }
    if (button.tag == 5008) {
        NSLog(@"点击了第8个空格 并且状态为%d",_eighthBtn.isSelected);
        if (_eighthBtn.isSelected) {
            [_statusArray addObject:@"8"];
        }else{
            [_statusArray removeObject:@"8"];
        }
    }
}

#pragma mark - Action
//保存
-(void)bottomClicked
{
    NSLog(@"_statusArray 有%d个元素",_statusArray.count);
    for (int i = 0; i < _statusArray.count; i++) {
        NSString *str = [_statusArray objectAtIndex:i];
        NSString *statusStr = [NSString stringWithFormat:@",%@",str];
        if (i == 0) {
            statusStr = [NSString stringWithFormat:@"%@",str];
        }
        [_statusStr appendFormat:statusStr];
    }
    
    NSLog(@"~~~~~~%@",_statusStr);
    if (!_loginIDField.text || [_loginIDField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"登录ID不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"姓名不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"密码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_makeSureField.text || [_makeSureField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"确认密码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_makeSureField.text isEqualToString:_passwordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"两次输入密码不一致!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (_statusArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择员工权限!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self changeApply];

}

//#pragma mark - Data
-(void)changeApply
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface changeStaffWithAgentID:delegate.agentID Token:delegate.token LoginID:_loginID Roles:_statusStr Password:_passwordField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES afterDelay:1.f];
                    hud.labelText = @"修改员工信息成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshStaffManagerListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
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
//
}

@end
