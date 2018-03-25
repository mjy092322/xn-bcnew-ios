//
//  SearchCurrencyVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchCurrencyVC.h"

//Category
#import "UIBarButtonItem+convience.h"
//Extension
//M
#import "CurrencyModel.h"
//V
#import "SelectScrollView.h"
#import "TLTextField.h"
#import "SearchHistoryTableView.h"
#import "SearchCurrencyTableView.h"
#import "TLPlaceholderView.h"
//C
#import "SearchCurrcneyChildVC.h"
#import "SearchHistoryChildVC.h"

@interface SearchCurrencyVC ()<UITextFieldDelegate, RefreshDelegate>
//
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;
//搜索
@property (nonatomic, strong) TLTextField *searchTF;
//
@property (nonatomic, strong) SearchHistoryTableView *historyTableView;
//行情列表
@property (nonatomic, strong) SearchCurrencyTableView *currencyTableView;
//
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;
//搜索内容
@property (nonatomic, copy) NSString *searchStr;
//
@property (nonatomic, strong) TLPageDataHelper *helper;

@end

@implementation SearchCurrencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消
    [self addCancelItem];
    //搜索
    [self initSearchBar];
    //历史搜索
    [self initHistoryTableView];
    //搜索结果
    [self initResultTableView];
    //搜索结果
    [self requestSearchList];
    //获取历史搜索记录
    [self getHistoryRecords];
//
//    [self initSelectScrollView];
//    //
//    [self addSubViewController];
}

#pragma mark - Init
- (void)addCancelItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"取消" titleColor:kWhiteColor frame:CGRectMake(0, 0, 35, 44) vc:self action:@selector(back)];
}

- (void)initSearchBar {
    
    [UINavigationBar appearance].barTintColor = kAppCustomMainColor;
    CGFloat height = 35;
    //搜索
    UIView *searchBgView = [[UIView alloc] init];
    //    UIView *searchBgView = [[UIView alloc] init];
    
    searchBgView.backgroundColor = kWhiteColor;
    searchBgView.userInteractionEnabled = YES;
    searchBgView.layer.cornerRadius = height/2.0;
    searchBgView.clipsToBounds = YES;

    self.navigationItem.titleView = searchBgView;
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    //搜索输入框
    self.searchTF = [[TLTextField alloc] initWithFrame:CGRectZero
                                             leftTitle:@""
                                            titleWidth:0
                                           placeholder:@"请输入平台/币种"];
    self.searchTF.delegate = self;
    
    [self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBgView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 13, 0, 0));
        
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15 - 13);
    }];
    
}

- (void)initHistoryTableView {
    
    self.historyTableView = [[SearchHistoryTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.historyTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"没有查找到历史搜索" topMargin:100];
    
    self.historyTableView.refreshDelegate = self;
    
    [self.view addSubview:self.historyTableView];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

- (void)initResultTableView {
    
    self.currencyTableView = [[SearchCurrencyTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.currencyTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"没有搜索到币种或平台"];
    self.currencyTableView.refreshDelegate = self;
    
    [self.view addSubview:self.currencyTableView];
    [self.currencyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.currencyTableView.hidden = YES;
}

#pragma mark -
- (void)initSelectScrollView {
    
    self.titles = @[@"热门搜索", @"历史搜索"];
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    [self.view addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        if (i == 0) {
            
            //
            SearchCurrcneyChildVC *childVC = [[SearchCurrcneyChildVC alloc] init];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
        } else {
            
            //
            SearchHistoryChildVC *childVC = [[SearchHistoryChildVC alloc] init];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
        }
    }
}

#pragma mark - Events

- (void)saveSearchRecord {
    
    self.historyTableView.hidden = YES;
    //保存搜索记录
    NSArray *myarray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"HistorySearch"];
    
    NSMutableArray *historyArr = [myarray mutableCopy];
    
    [historyArr addObject:self.searchStr];
    
    if (historyArr==nil) {
        
        historyArr = [[NSMutableArray alloc]init];
        
    }else if ([historyArr containsObject:self.searchStr]) {
        
        [historyArr removeObject:self.searchStr];
    }
    [historyArr insertObject:self.searchStr atIndex:0];
    
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    
    [mydefaults setObject:historyArr forKey:@"HistorySearch"];
    
    [mydefaults synchronize];
    //刷新数据
    [self getHistoryRecords];
    
    self.historyTableView.hidden = YES;
}

- (void)textDidChange:(UITextField *)sender {
    
    self.currencyTableView.hidden = sender.text.length == 0 ? YES: NO;
//    self.historyTableView.hidden = sender.text.length == 0 ?NO: YES;
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data
- (void)getHistoryRecords {
    
    NSArray *myarray = [[NSUserDefaults standardUserDefaults]arrayForKey:@"HistorySearch"];
    
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    
    if (myarray == nil) {
        
        NSArray *historyArr = @[];
        
        [mydefaults setObject:historyArr forKey:@"HistorySearch"];
    }
    
    if (myarray.count == 0) {
        
        self.historyTableView.tableFooterView =         self.historyTableView.placeHolderView;
    } else {
        
        [self.historyTableView.placeHolderView removeFromSuperview];
        self.historyTableView.historyRecords = myarray;
        [self.historyTableView reloadData];
    }
}

/**
 获取搜索结果
 */
- (void)requestSearchList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628340";
    helper.parameters[@"keywords"] = self.searchStr;
    
    if ([TLUser user].userId) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    helper.tableView = self.currencyTableView;
    
    [helper modelClass:[CurrencyModel class]];
    
    self.helper = helper;
    
    [self.currencyTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencys = objs;
            
            weakSelf.currencyTableView.currencys = objs;
            
            [weakSelf.currencyTableView reloadData_tl];
            
            weakSelf.currencyTableView.hidden = NO;

        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.currencyTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencys = objs;
            
            weakSelf.currencyTableView.currencys = objs;
            
            [weakSelf.currencyTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.currencyTableView endRefreshingWithNoMoreData_tl];
}

/**
 添加自选
 */
- (void)addCurrency:(NSInteger)index {
    
    CurrencyModel *currency = self.currencys[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628330";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"exchangeEname"] = currency.exchangeEname;
    http.parameters[@"coin"] = currency.coinSymbol;
    http.parameters[@"toCoin"] = currency.toCoinSymbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"添加成功"];
        
        currency.isChoice = @"1";
        
        if (self.currencyBlock) {
            
            self.currencyBlock();
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    self.searchStr = textField.text;
    
    //保存搜索记录
    [self saveSearchRecord];
    //获取搜索结果
    self.helper.parameters[@"keywords"] = self.searchStr;
    [self.currencyTableView beginRefreshing];
    
    return YES;
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([refreshTableview isKindOfClass:[SearchCurrencyTableView class]]) {
        
        if (![TLUser user].isLogin) {
            
            [TLAlert alertWithInfo:@"添加自选功能需要登录后才能使用"];
            return ;
        };
        
        CurrencyModel *currency = self.currencys[indexPath.row];
        
        if ([currency.isChoice isEqualToString:@"0"]) {
            
            //添加币种
            [self addCurrency:indexPath.row];
            return ;
        }
    }
    //获取搜索结果
    self.helper.parameters[@"keywords"] = self.historyTableView.historyRecords[indexPath.row];
    [self.currencyTableView beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
