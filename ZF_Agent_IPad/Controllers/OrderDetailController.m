//
//  OrderDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailController.h"
#import "AppDelegate.h"
#import "OrderDetailModel.h"
#import "RecordView.h"
#import "StringFormat.h"
#import "OrderDetailCell.h"
#import "OrderManagerController.h"

typedef enum {
    OrderDetailBtnStyleFirst = 1,
    OrderDetailBtnStyleSecond,
}OrderDetailBtnStyle; //按钮样式

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OrderDetailModel *orderDetail;

@property (nonatomic, strong) UIView *detailFooterView;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_supplyType == SupplyGoodsWholesale) {
        self.title = @"批购订单详情";
    }
    else {
        self.title = @"代购订单详情";
    }
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    [self downloadDetail];
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

    //追踪记录
    if ([_orderDetail.recordList count] > 0) {
        CGFloat leftSpace = 50.f;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 20, wide - leftSpace * 2 , 14)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:10.f];
        tipLabel.text = @"追踪记录：";
        RecordView *recordView = [[RecordView alloc] initWithRecords:_orderDetail.recordList
                                                               width:(wide - leftSpace * 2)];
        CGFloat recordHeight = [recordView getHeight];
        recordView.frame = CGRectMake(leftSpace, 34, wide - leftSpace * 2, recordHeight);
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, recordHeight + 40)];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:tipLabel];
        [footerView addSubview:recordView];
        _tableView.tableFooterView = footerView;
        [recordView initAndLayoutUI];
    }
}

- (void)footerViewAddSubview {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = kColor(135, 135, 135, 1);
    [_detailFooterView addSubview:line];
   }

- (void)initAndLayoutUI {
    CGFloat footerHeight = 0.f;
    if ((_supplyType == SupplyGoodsWholesale && (_orderDetail.orderStatus == WholesaleStatusUnPaid ||
                                                 _orderDetail.orderStatus == WholesaleStatusPartPaid ||
                                                 _orderDetail.orderStatus == WholesaleStatusFinish)) ||
        (_supplyType == SupplyGoodsProcurement && (_orderDetail.orderStatus == ProcurementStatusUnPaid ||
                                                   _orderDetail.orderStatus == ProcurementStatusSend ||
                                                   _orderDetail.orderStatus == ProcurementStatusCancel ||
                                                   _orderDetail.orderStatus == ProcurementStatusClosed))) {
        footerHeight = 60.f;
        //底部按钮
       
        
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    if (kDeviceVersion >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
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
                                                           constant:-0]];
}

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action
                        style:(OrderDetailBtnStyle)style {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (style == OrderDetailBtnStyleFirst) {
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = kMainColor.CGColor;
        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        [button setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
    }
    else {
        [button setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setLabel:(UILabel *)label withString:(NSString *)string {
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.f];
    label.text = string;
}

#pragma mark - Request

- (void)downloadDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getOrderDetailWithToken:delegate.token orderType:_supplyType orderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    [self parseOrderDetailWithDictionary:object];
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

//取消批购订单
- (void)cancelWholesaleOrder {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface cancelWholesaleOrderWithToken:delegate.token orderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"订单取消成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshOrderListNotification object:nil];
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
}

//取消代购订单
- (void)cancelProcurementOrder {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface cancelProcurementOrderWithToken:delegate.token orderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"订单取消成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshOrderListNotification object:nil];
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
}

#pragma mark - Data

- (void)parseOrderDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _orderDetail = [[OrderDetailModel alloc] initWithParseDictionary:[dict objectForKey:@"result"]];
    [self initAndLayoutUI];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 3;
            break;
        case 1:
            row = [_orderDetail.goodList count] + 2;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UITableViewCell *cell = nil;
    CGFloat originX = 50.f;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, 18, 18)];
                    statusView.image = kImageName(@"order.png");
                    [cell.contentView addSubview:statusView];
                    //状态
                    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 30, 10, wide / 2, 20.f)];
                    statusLabel.backgroundColor = [UIColor clearColor];
                    statusLabel.font = [UIFont boldSystemFontOfSize:16.f];
                    statusLabel.text = [_orderDetail getStatusStringWithSupplyType:_supplyType];
                    [cell.contentView addSubview:statusLabel];
                    //批购
                    if (_supplyType == SupplyGoodsWholesale) {
                        //实付
                        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2, 20.f)];
                        [self setLabel:payLabel withString:[NSString stringWithFormat:@"实付金额：￥%.2f",_orderDetail.actualPrice]];
                        [cell.contentView addSubview:payLabel];
                        //定金总额
                        UILabel *totalDepositLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, wide / 2 - originX, 20.f)];
                        [self setLabel:totalDepositLabel withString:[NSString stringWithFormat:@"定金总额：￥%.2f",_orderDetail.totalDeposit]];
                        [cell.contentView addSubview:totalDepositLabel];
                        //已发货数量
                        UILabel *shipmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide / 2, 50, wide / 2 - originX, 20)];
                        [self setLabel:shipmentLabel withString:[NSString stringWithFormat:@"已发货数量：%d",_orderDetail.shipmentCount]];
                        [cell.contentView addSubview:shipmentLabel];
                        //已付定金
                        UILabel *paidDepositLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 70, wide / 2 - originX, 20)];
                        [self setLabel:paidDepositLabel withString:[NSString stringWithFormat:@"已付定金：￥%.2f",_orderDetail.paidDeposit]];
                        [cell.contentView addSubview:paidDepositLabel];
                        //剩余货品数量
                        UILabel *remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide / 2, 70, wide / 2 - originX, 20)];
                        [self setLabel:remainLabel withString:[NSString stringWithFormat:@"剩余货品总数：%d",_orderDetail.totalCount - _orderDetail.shipmentCount]];
                        [cell.contentView addSubview:remainLabel];
                    }
                    else {
                        //实付
                        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide * 0.6 - originX, 20.f)];
                        [self setLabel:payLabel withString:[NSString stringWithFormat:@"实付金额：￥%.2f",_orderDetail.actualPrice]];
                        [cell.contentView addSubview:payLabel];
                        
                        UIImageView *vLine = [[UIImageView alloc] initWithFrame:CGRectMake(wide * 0.4, 15, 1, 30)];
                        vLine.image = kImageName(@"gray.png");
                        [cell.contentView addSubview:vLine];
                        
                        //归属用户
                        UILabel *belongLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide * 0.4 + 5, 10, wide * 0.4 - originX, 20)];
                        [self setLabel:belongLabel withString:@"归属用户："];
                        [cell.contentView addSubview:belongLabel];
                        
                        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide * 0.4 + 5, 30, wide * 0.4 - originX, 20)];
                        [self setLabel:userLabel withString:_orderDetail.belongUser];
                    }
                    
                    
                    
                    
                    
                    CGFloat middleSpace = 10.f;
                    CGFloat btnWidth = (kScreenWidth - 4 * middleSpace) / 2;
                    CGFloat btnHeight = 36.f;
                    if (_supplyType == SupplyGoodsWholesale) {
                        //批购
                        if (_orderDetail.orderStatus == WholesaleStatusUnPaid) {
                            //未付款
                            UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesaleOrder:) style:OrderDetailBtnStyleFirst];
                            cancelBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                            UIButton *depositBtn = [self buttonWithTitle:@"支付定金" action:@selector(payDeposit:) style:OrderDetailBtnStyleSecond];
                            depositBtn.frame = CGRectMake(wide-150-120, 12, 100, 40);
                            [cell.contentView addSubview:depositBtn];
                            [cell.contentView addSubview:cancelBtn];
                        }
                        else if (_orderDetail.orderStatus == WholesaleStatusPartPaid) {
                            //已付定金
                            UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesaleOrder:) style:OrderDetailBtnStyleFirst];
                            cancelBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                            UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payWholesaleOrder:) style:OrderDetailBtnStyleSecond];
                            payBtn.frame = CGRectMake(wide-150-120, 12, 100, 40);
                            [cell.contentView addSubview:payBtn];
                            [cell.contentView addSubview:cancelBtn];
                        }
                        else if (_orderDetail.orderStatus == WholesaleStatusFinish) {
                            //再次批购
                            UIButton *repeatBtn = [self buttonWithTitle:@"再次批购" action:@selector(repeatWholesale:) style:OrderDetailBtnStyleSecond];
                            repeatBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                            [cell.contentView addSubview:repeatBtn];
                        }
                    }
                    else {
                        //代购
                        if (_orderDetail.orderStatus == ProcurementStatusUnPaid) {
                            //未付款
                            UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelProcurementOrder:) style:OrderDetailBtnStyleFirst];
                            cancelBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                            UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payProcurementOrder:) style:OrderDetailBtnStyleSecond];
                            payBtn.frame = CGRectMake(wide-150-120, 12, 100, 40);
                            [cell.contentView addSubview:payBtn];
                            [cell.contentView addSubview:cancelBtn];
                        }
                        else if (_orderDetail.orderStatus == ProcurementStatusSend ||
                                 _orderDetail.orderStatus == ProcurementStatusCancel ||
                                 _orderDetail.orderStatus == ProcurementStatusClosed) {
                            //再次批购
                            UIButton *repeatBtn = [self buttonWithTitle:@"再次批购" action:@selector(repeatProcurement:) style:OrderDetailBtnStyleSecond];
                            repeatBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                            [cell.contentView addSubview:repeatBtn];
                        }
                    }

                    
                    
                    
                    
                    
                    
                    
                }
                    break;
                case 1: {
                    //60
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    //收件人
                    UILabel *receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, wide - originX * 2, 20.f)];
                    [self setLabel:receiverLabel withString:[NSString stringWithFormat:@"收件人：%@  %@",_orderDetail.receiver,_orderDetail.phoneNumber]];
                    [cell.contentView addSubview:receiverLabel];
                    //地址
                    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2, 20.f)];
                    [self setLabel:addressLabel withString:[NSString stringWithFormat:@"收件地址：%@",_orderDetail.address]];
                    [cell.contentView addSubview:addressLabel];
                }
                    break;
                case 2: {
                    
                    CGFloat btnWidth = 80.f;
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    //订单
                    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, wide - originX * 2 - btnWidth, 20)];
                    orderLabel.backgroundColor = [UIColor clearColor];
                    orderLabel.font = [UIFont systemFontOfSize:15.f];
//                    orderLabel.textColor = kColor(116, 116, 116, 1);
                    orderLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderDetail.orderNumber];
                    [cell.contentView addSubview:orderLabel];
                    
                    //支付方式
                    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2 - btnWidth, 20.f)];
                    typeLabel.backgroundColor = [UIColor clearColor];
                    typeLabel.font = [UIFont systemFontOfSize:15.f];
//                    typeLabel.textColor = kColor(116, 116, 116, 1);
                    typeLabel.text = [NSString stringWithFormat:@"支付方式：%@",_orderDetail.payType];
                    [cell.contentView addSubview:typeLabel];
                    //订单日期
                    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, wide - originX * 2 - btnWidth, 20)];
                    dateLabel.backgroundColor = [UIColor clearColor];
                    dateLabel.font = [UIFont systemFontOfSize:15.f];
//                    dateLabel.textColor = kColor(116, 116, 116, 1);
                    dateLabel.text = [NSString stringWithFormat:@"订单日期：%@",_orderDetail.createTime];
                    [cell.contentView addSubview:dateLabel];

                    //留言
                    NSString *comment = [NSString stringWithFormat:@"留言：%@",_orderDetail.comment];
                    CGFloat height = [StringFormat heightForComment:comment withFont:[UIFont systemFontOfSize:15.f] width:wide - originX * 2];
                    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 10, wide/2, height)];
                    commentLabel.numberOfLines = 0;
                    [self setLabel:commentLabel withString:comment];
                    [cell.contentView addSubview:commentLabel];
                    //发票
                   
                    UILabel *invoceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 10 + height, wide/2, 20.f)];
                    [self setLabel:invoceTypeLabel withString:[NSString stringWithFormat:@"发票类型：%@",_orderDetail.invoceType]];
                    [cell.contentView addSubview:invoceTypeLabel];
                    UILabel *invoceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 30 + height, wide/2, 20.f)];
                    [self setLabel:invoceTitleLabel withString:[NSString stringWithFormat:@"发票抬头：%@",_orderDetail.invoceTitle]];
                    
                    [cell.contentView addSubview:invoceTitleLabel];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                //100
                CGFloat btnWidth = 80.f;
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                UIView*rootview  = [[UIView alloc] initWithFrame:CGRectMake(50, 10, wide-100, 20)];
                rootview.backgroundColor = kColor(235, 233, 233, 1);
                [cell.contentView addSubview: rootview];
                
                
                UILabel*goodslable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 60, 20)];
                [rootview addSubview:goodslable];
                goodslable.textAlignment = NSTextAlignmentCenter;
                goodslable.text=@"商品";
                
                
                UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-35, 0, 60, 20)];
                [rootview addSubview:phonelable];
                //                phonelable.textAlignment = NSTextAlignmentCenter;
                UILabel*numberlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-200, 0, 80, 20)];
                [rootview addSubview:numberlable];
                //                numberlable.textAlignment = NSTextAlignmentCenter;
                
               
                    numberlable.text=@"购买数量";
                    
                    phonelable.text=@"单价";
                    
               
                
                
        
            }
            else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                int goodCount = _orderDetail.totalCount;
                if (_supplyType == SupplyGoodsProcurement) {
                    goodCount = _orderDetail.proTotalCount;
                }
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                UILabel* linlable0  = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, wide-100, 1)];
                
                
                linlable0.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
                
                
                [cell.contentView addSubview:linlable0];
                UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 15, wide / 2 - originX, 30)];
                totalLabel.backgroundColor = [UIColor clearColor];
                totalLabel.font = [UIFont systemFontOfSize:15.f];
                totalLabel.textAlignment = NSTextAlignmentRight;
                totalLabel.text = [NSString stringWithFormat:@"共计%d件商品",goodCount];
                [cell.contentView addSubview:totalLabel];
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide / 2, 15, wide / 2 - originX, 30)];
                priceLabel.backgroundColor = [UIColor clearColor];
                priceLabel.font = [UIFont systemFontOfSize:15.f];
                priceLabel.textAlignment = NSTextAlignmentRight;
                priceLabel.text = [NSString stringWithFormat:@"实付金额:%.2f",_orderDetail.actualPrice];
                [cell.contentView addSubview:priceLabel];
            }
            else {
                static NSString *orderIdentifier = @"orderIdentifier";
                cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
                if (cell == nil) {
                    cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier supplyType:_supplyType];
                }
                OrderGoodModel *model = [_orderDetail.goodList objectAtIndex:indexPath.row - 1];
                [(OrderDetailCell *)cell setContentsWithData:model];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    height = 100.f;
                    if (_supplyType == SupplyGoodsProcurement) {
                        height = 60.f;
                    }
                }
                    break;
                case 1:
                    height = 60.f;
                    break;
                case 2: {
                    NSString *comment = [NSString stringWithFormat:@"留言：%@",_orderDetail.comment];
                    CGFloat commentHeight = [StringFormat heightForComment:comment withFont:[UIFont systemFontOfSize:13.f] width:kScreenWidth - 40];
                    height = commentHeight + 60;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                height = 50.f;
            }
            else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                height = 60.f;
            }
            else {
                height = kOrderDetailCellHeight;
            }
        }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001f;
    }
    else {
        return 1.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Action
//批购
- (IBAction)cancelWholesaleOrder:(id)sender {
    [self cancelWholesaleOrder];
}

//支付定金
- (IBAction)payDeposit:(id)sender {
    
}

//付款
- (IBAction)payWholesaleOrder:(id)sender {
    
}

//再次批购
- (IBAction)repeatWholesale:(id)sender {
    
}

//代购
- (IBAction)cancelProcurementOrder:(id)sender {
    [self cancelProcurementOrder];
}

//付款
- (IBAction)payProcurementOrder:(id)sender {
    
}

//再次代购
- (IBAction)repeatProcurement:(id)sender {
    
}

@end