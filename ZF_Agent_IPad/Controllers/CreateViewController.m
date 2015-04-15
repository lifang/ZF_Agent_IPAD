//
//  CreateViewController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CreateViewController.h"
#import "RegularFormat.h"
#import "CityHandle.h"
#import "KxMenu.h"

#define kRegisterInputViewTag   100
#define kRegisterImageViewTag   101

@interface RegisterCell : UITableViewCell

@property (nonatomic, strong) NSString *key;

@end

@implementation RegisterCell

@end

@interface RegisterTextField : UITextField

@property (nonatomic, strong) NSString *key;

@end

@implementation RegisterTextField

@end

@interface CreateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列
@property (nonatomic, strong) UIView *scrollView;

@property (nonatomic, strong) NSString *selectedKey; //用于记录点击的是哪一行
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, strong) UIButton *cityField;
@property (nonatomic, assign) BOOL isopen;
@property (nonatomic, assign) BOOL isPorS;
@property(nonatomic,strong) UIPopoverController *popViewController;
@property (nonatomic, strong) NSMutableDictionary *infoDict;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoDict = [[NSMutableDictionary alloc] init];

    // Do any additional setup after loading the view.
    self.title = @"申请成为代理商";
    _agentType = AgentTypeCompany;
    _registerDict = [[NSMutableDictionary alloc] init];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (IBAction)modifyLocation:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [_pickerView selectedRowInComponent:1];
    cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
   cityName = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
    [_tableView reloadData];
    
    
}

- (void)initPickerView {
    //pickerView
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-64;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-64;
        height=SCREEN_HEIGHT;
        
    }
    
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height - 340, wide, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height - 296, wide, 296)];
    
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
}



- (void)pickerScrollOut {
    
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-64;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-64;
        height=SCREEN_HEIGHT;
        
    }
    
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, wide, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, wide, 216);
    }];
}







#pragma mark - Set

- (void)setAgentType:(AgentType)agentType {
    _agentType = agentType;
    [_tableView reloadData];
}
- (void)setHeaderAndFooterView {
    //子类重写
}

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setHeaderAndFooterView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
 
}



#pragma mark - Set


#pragma mark - Request
- (void)parseImageUploadInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSString class]]) {
        return;
    }
    NSString *urlString = [dict objectForKey:@"result"];
    if (urlString && ![urlString isEqualToString:@""]) {
        [_infoDict setObject:urlString forKey:_selectedKey];
    }
    [_tableView reloadData];
}

- (void)uploadPictureWithImage:(UIImage *)image

{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"上传中...";
    [NetworkInterface uploadImageWithImage:image finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"上传成功";
                    [self parseImageUploadInfo:object];
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

#pragma mark - Action
-(void)pictureclick:(UIButton*)send
{
    _selectedKey =[NSString stringWithFormat:@"%d", send.tag];


    [self showImageOption];
    


}
-(void)addressclick
{

    [self initPickerView];




}
- (IBAction)billType:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:@"公司"
                                                image:nil
                                               target:self
                                               action:@selector(selectBillType:)
                                        selectedTitle:nil
                                                  tag:1],
                                 [KxMenuItem menuItem:@"个人"
                                                image:nil
                                               target:self
                                               action:@selector(selectBillType:)
                                        selectedTitle:nil
                                                  tag:2],
                                 nil];
    CGRect factRect = [[_cityField superview] convertRect:_cityField.frame toView:self.view];
    CGRect rect = CGRectMake(factRect.origin.x + factRect.size.width / 2, factRect.origin.y+20, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)selectBillType:(KxMenuItem *)sender {
    if (sender.tag == 1)
    {
        _isPorS=YES;
    
    }
    else
    
    {
        _isPorS=NO;

    }
    [_tableView reloadData];

}




-(void)openclick
{
    _isopen=!_isopen;
    


    [_tableView reloadData];
    

}

#pragma mark - 数据验证

- (void)dataValidation {
    if (self.agentType == AgentTypeCompany) {
        if (![_registerDict objectForKey:key_company] || [[_registerDict objectForKey:key_company] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写公司名称";
            return;
        }
        if (![_registerDict objectForKey:key_license] || [[_registerDict objectForKey:key_license] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写营业执照登记号";
            return;
        }
        if (![_registerDict objectForKey:key_tax] || [[_registerDict objectForKey:key_tax] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写税务登记证号";
            return;
        }
        if (![_registerDict objectForKey:key_licenseImage] || [[_registerDict objectForKey:key_licenseImage] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请上传营业执照照片";
            return;
        }
        if (![_registerDict objectForKey:key_taxImage] || [[_registerDict objectForKey:key_taxImage] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请上传税务登记证照片";
            return;
        }
    }
    if (![_registerDict objectForKey:key_person] || [[_registerDict objectForKey:key_person] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写负责人姓名";
        return;
    }
    if (![_registerDict objectForKey:key_personCardID] || [[_registerDict objectForKey:key_personCardID] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写负责人身份证号";
        return;
    }
    if (![_registerDict objectForKey:key_phone] || [[_registerDict objectForKey:key_phone] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写手机";
        return;
    }
    if (![_registerDict objectForKey:key_email] || [[_registerDict objectForKey:key_email] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮箱";
        return;
    }
    if (![_registerDict objectForKey:key_city] || [[_registerDict objectForKey:key_city] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择城市";
        return;
    }
    if (![_registerDict objectForKey:key_address] || [[_registerDict objectForKey:key_address] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写详细地址";
        return;
    }
    if (![_registerDict objectForKey:key_cardImage] || [[_registerDict objectForKey:key_cardImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传身份证照片";
        return;
    }
    if (!_usernameField.text || [_usernameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写用户名";
        return;
    }
    if (!_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写密码";
        return;
    }
    if (!_confirmField.text || [_confirmField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写确认密码";
        return;
    }
    if (![RegularFormat isMobileNumber:[_registerDict objectForKey:key_phone]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的手机";
        return;
    }
    if (![RegularFormat isCorrectEmail:[_registerDict objectForKey:key_email]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的邮箱";
        return;
    }
    if (![_passwordField.text isEqualToString:_confirmField.text]) {
        if (![_registerDict objectForKey:key_tax] || [[_registerDict objectForKey:key_tax] isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"两次密码输入不一致";
            return;
        }
    }
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
    
   }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

            return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(_isPorS)
    {
     return 1420;
        
    }else
    {
        
        return 1180;
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{ CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }

    
    _scrollView = [[UIView alloc]init];
    
    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60,40,wide/2-270, 40)];
    [_scrollView addSubview:newaddress];
    newaddress.textAlignment = NSTextAlignmentRight;
    newaddress.font=[UIFont systemFontOfSize:18];
    
    newaddress.text=@"代理商类型";
    
    _cityField = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityField.frame = CGRectMake(wide/2-200,40,280, 40);
    
    
    [_cityField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cityField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cityField setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *layer=[_cityField  layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
    _cityField.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    _cityField.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    if(_isPorS)
    {
    
        [_cityField setTitle:@"公司" forState:UIControlStateNormal];
        
        
    
    }
    else{
    
    
        [_cityField setTitle:@"个人" forState:UIControlStateNormal];

    
    
    }
    
    [_cityField addTarget:self action:@selector(billType:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_cityField];
    
    
    
    
    UILabel*openlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-160-90,43,80, 40)];
    [_scrollView addSubview:openlable];
    openlable.textAlignment = NSTextAlignmentRight;
//    newaddress.font=[UIFont systemFontOfSize:18];
    
    openlable.text=@"开通分润";
    UIButton*openbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    openbutton.frame = CGRectMake(wide-160,40,80, 46);
    if(_isopen)
    {
        [openbutton setImage:kImageName(@"open") forState:UIControlStateNormal];

    }else
    {
    
        [openbutton setImage:kImageName(@"close") forState:UIControlStateNormal];

    
    }
    [openbutton addTarget:self action:@selector(openclick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:openbutton];
    
    if(_isPorS)
    {
        NSArray*namesarry=[NSArray arrayWithObjects:@"公司名称",@"公司营业执照登记号",@"公司税务登记号", nil];
        for(int i=0;i<namesarry.count;i++)
        {
            
            
            UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+100,wide/2-270, 40)];
            [_scrollView addSubview:newaddress];
            newaddress.textAlignment = NSTextAlignmentRight;
            newaddress.font=[UIFont systemFontOfSize:18];
            
            newaddress.text=[namesarry objectAtIndex:i];
            
            
            
            
            
            UITextField*neworiginaltextfield=[[UITextField alloc]init];
            neworiginaltextfield.tag=i+404;

            neworiginaltextfield.frame = CGRectMake(wide/2-200,  i*60+100,280, 40);
            
            neworiginaltextfield.delegate=self;
            
            neworiginaltextfield.tag=i+1056;
            neworiginaltextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_scrollView addSubview:neworiginaltextfield];
            //        neworiginaltextfield.delegate=self;
            
            CALayer *layer=[neworiginaltextfield layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            
            
        }

    }else
    {
    
    
    
    
    }
    
    
    
    NSArray*namesarry1=[NSArray arrayWithObjects:@"负责人姓名",@"负责人身份证号",@"手机", @"邮箱",@"所在地",@"详细地址",nil];
    for(int i=0;i<namesarry1.count;i++)
    {
        NSInteger heighth;

        if(_isPorS)
        {
            heighth=400;
            
        }else
        {
        
            heighth=100;

        
        }
        
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+heighth,wide/2-270, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentRight;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry1 objectAtIndex:i];
        
        if(i==4)
        {
           addressbuttons = [UIButton buttonWithType:UIButtonTypeCustom];
            addressbuttons.frame = CGRectMake(wide/2-200,i*60+heighth,280, 40);
            
            [addressbuttons setTitle:cityName forState:UIControlStateNormal];

            [addressbuttons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            addressbuttons.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [addressbuttons setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            CALayer *layer=[addressbuttons  layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            addressbuttons.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            addressbuttons.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [addressbuttons addTarget:self action:@selector(addressclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:addressbuttons];
        
        }else
        {
            UITextField*neworiginaltextfield=[[UITextField alloc]init];
            
            neworiginaltextfield.frame = CGRectMake(wide/2-200,i*60+heighth,280, 40);
            
            neworiginaltextfield.delegate=self;
            neworiginaltextfield.tag=i+408;

            neworiginaltextfield.tag=i+1056;
            neworiginaltextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_scrollView addSubview:neworiginaltextfield];
            //        neworiginaltextfield.delegate=self;
            
            CALayer *layer=[neworiginaltextfield layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];

        
        
        }
        
        
        
        
        
    }

    
    
    
    if(_isPorS)
    {
        NSArray*namesarry2=[NSArray arrayWithObjects:@"身份证照片",@"营业执照照片",@"税务登记照片",nil];
        for(int i=0;i<namesarry2.count;i++)
        {
            
            
            UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+820,wide/2-270, 40)];
            [_scrollView addSubview:newaddress];
            newaddress.textAlignment = NSTextAlignmentRight;
            newaddress.font=[UIFont systemFontOfSize:18];
            
            newaddress.text=[namesarry2 objectAtIndex:i];
            
            
            UIButton* addressbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            addressbutton.frame = CGRectMake(wide/2-200,i*60+820,180, 40);
            
            [addressbutton setTitle:@"上传照片" forState:UIControlStateNormal];
            
            //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [addressbutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
            
            
            [addressbutton addTarget:self action:@selector(pictureclick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:addressbutton];
            
            
            addressbutton.tag=i+418;

            
            
        }
        UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(60, 780,wide-120, 1)];
        
        line.backgroundColor=[UIColor grayColor];
        
        [_scrollView addSubview:line];

    }else
    {
        
        NSArray*namesarry2=[NSArray arrayWithObjects:@"身份证照片",nil];
        for(int i=0;i<namesarry2.count;i++)
        {
            
            
            UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+560,wide/2-270, 40)];
            [_scrollView addSubview:newaddress];
            newaddress.textAlignment = NSTextAlignmentRight;
            newaddress.font=[UIFont systemFontOfSize:18];
            
            newaddress.text=[namesarry2 objectAtIndex:i];
            
            
            UIButton* addressbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            addressbutton.frame = CGRectMake(wide/2-200,i*60+560,180, 40);
            
            [addressbutton setTitle:@"上传照片" forState:UIControlStateNormal];
            
            //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [addressbutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
            
            
            [addressbutton addTarget:self action:@selector(pictureclick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:addressbutton];
            
            
            addressbutton.tag=i+428;

            
            
        }
        
        UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(60, 500,wide-120, 1)];
        
        line.backgroundColor=[UIColor grayColor];
        
        [_scrollView addSubview:line];
        
    }

    
    
    
    
    
    
    NSArray*namesarry3=[NSArray arrayWithObjects:@"登录ID",@"登录密码",@"确认密码", nil];
    for(int i=0;i<namesarry3.count;i++)
    {
        
        NSInteger heighth;
        
        if(_isPorS)
        {
            heighth=1060;
            UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(60,1020,wide-120, 1)];
            
            line.backgroundColor=[UIColor grayColor];
            
            [_scrollView addSubview:line];
            
        }else
        {
            
            heighth=760;
            
            UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(60, 670,wide-120, 1)];
            
            line.backgroundColor=[UIColor grayColor];
            
            [_scrollView addSubview:line];
        }

        
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+heighth,wide/2-270, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentRight;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry3 objectAtIndex:i];
        
        
        
        
        
        UITextField*neworiginaltextfield=[[UITextField alloc]init];
        neworiginaltextfield.tag=i+518;

        neworiginaltextfield.frame = CGRectMake(wide/2-200,  i*60+heighth,280, 40);
        
        neworiginaltextfield.delegate=self;
        
        neworiginaltextfield.tag=i+1056;
        neworiginaltextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_scrollView addSubview:neworiginaltextfield];
        //        neworiginaltextfield.delegate=self;
        
        CALayer *layer=[neworiginaltextfield layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        
        //设置边框线的宽
        //
        [layer setBorderWidth:1];
        //设置边框线的颜色
        [layer setBorderColor:[[UIColor grayColor] CGColor]];
        
        
    }
    

    
    UIButton* savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(wide/2-200,1300,280, 40);
    
    if(_isPorS)
    {
        savebutton.center=CGPointMake(wide/2, 1380);
        
    }else
    {
        
        savebutton.center=CGPointMake(wide/2, 1140);
        
        
    }

    
    [savebutton setTitle:@"保存" forState:UIControlStateNormal];
    
    //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [savebutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
    
    
    [savebutton addTarget:self action:@selector(sexclick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:savebutton];

    
    
//    _scrollView.frame=CGRectMake(0, 0, wide, 1800);
    

    
    return _scrollView;
    
}

#pragma mark - UITextField

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(RegisterTextField *)textField {
    
}


#pragma mark - 图片
//点击图片行调用
- (void)showImageOption {
    UIActionSheet *sheet = nil;
    NSString *value = [_registerDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"查看照片",@"相册上传",@"拍照上传",nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"相册上传",@"拍照上传",nil];
    }
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *value = [_registerDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        if (buttonIndex == 0) {
            //查看大图
            [self scanBigImage];
            return;
        }
        else if (buttonIndex == 1) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 2) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else {
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]&&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        popover.delegate = self;
        self.popViewController = popover;//对局部UIPopoverController对象popover我们赋给了一个全局的UIPopoverController对象popoverController
        // popover.popoverContentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self.popViewController presentPopoverFromRect:CGRectMake(100, 100, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }];
            
        }
        else
        {
            
            [self.popViewController presentPopoverFromRect:CGRectMake(100, 100, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
}

//查看大图
- (void)scanBigImage {
    NSString *urlString = [_registerDict objectForKey:_selectedKey];
    
    
    [self showDetailImageWithURL:urlString imageRect:self.imageRect WithIdentifier:nil];
    
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.popViewController dismissPopoverAnimated:NO];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}


@end