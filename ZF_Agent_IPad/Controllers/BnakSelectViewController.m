//
//  BnakSelectViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "BnakSelectViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"


@interface BnakSelectViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *bankField;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) NSMutableArray *searchItem; //搜索结果


@end

@implementation BnakSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择银行";
    if (!_bankItems) {
        _bankItems = [[NSMutableArray alloc] init];
        [self getBankList];
    }
    _searchItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    CGFloat wide;
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
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 84)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    CGFloat backHeight = 44.f;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, wide, backHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backView];
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, kLineHeight)];
    firstLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:firstLine];
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, backHeight - kLineHeight, wide, kLineHeight)];
    secondLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:secondLine];
    
    _bankField = [[UITextField alloc] init];
    _bankField.frame = CGRectMake(20, 0, wide - 100, backHeight);
    _bankField.font = [UIFont systemFontOfSize:15.f];
    _bankField.placeholder = @"请输入银行名称";
    _bankField.delegate = self;
    _bankField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:_bankField];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(wide - 40, 10, 24, 24);
    [_searchBtn setBackgroundImage:kImageName(@"search.png") forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchBank:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_searchBtn];
}

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
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

#pragma mark - Request

- (void)getBankList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface chooseBankWithToken:delegate.token bankName:nil finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    [self parseBankListWithDictionary:object];
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

- (void)parseBankListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *bankList = [dict objectForKey:@"result"];
    for (int i = 0; i < [bankList count]; i++) {
        id bankDict = [bankList objectAtIndex:i];
        if ([bankDict isKindOfClass:[NSDictionary class]]) {
            BankModel *model = [[BankModel alloc] initWithParseDictionary:bankDict];
            [_bankItems addObject:model];
        }
    }
}

- (void)clearStatus {
    for (BankModel *model in _searchItem) {
        model.isSelected = NO;
    }
}

#pragma mark - Action

- (void)searchBank:(id)sender {
    [_searchItem removeAllObjects];
    for (BankModel *model in _bankItems) {
        if ([model.bankName rangeOfString:_bankField.text].length != 0) {
            [_searchItem addObject:model];
        }
    }
    [_tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_searchItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Terminal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    BankModel *model = [_searchItem objectAtIndex:indexPath.row];
    cell.textLabel.text = model.bankName;
    cell.imageView.image = kImageName(@"btn_selected");
    if (model.isSelected) {
        cell.imageView.hidden = NO;
    }
    else {
        cell.imageView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clearStatus];
    BankModel *model = [_searchItem objectAtIndex:indexPath.row];
    model.isSelected = YES;
    [_tableView reloadData];
   // if (_delegate && [_delegate respondsToSelector:@selector(getSelectedBank:)]) {
   //    [_delegate getSelectedBank:model];
   // }
    [_delegate getSelectedBank:model];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([_searchItem count] <= 0) {
            return nil;
        }
        else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 30)];
            view.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenHeight - 20, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.text = @"搜索结果";
            [view addSubview:label];
            return view;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchBank:nil];
    return YES;
}




@end
