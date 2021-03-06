//
//  signUpUsersListV.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "signUpUsersListV.h"
#import "signUpUsersListCell.h"
@interface signUpUsersListV() <UITableViewDataSource,UITableViewDelegate>

@end
@implementation signUpUsersListV

static NSString *identifierCell = @"signUpUsersListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kClearColor;
        
        [self registerClass:[signUpUsersListCell class] forCellReuseIdentifier:identifierCell];
        
        
        //适配
        if (@available(iOS 11.0, *)) {
            
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.approvedList.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   signUpUsersListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
#warning 有问题
    for (int i=0; i<self.signUpUsersListM.count; i++) {
//        self.approvedList = self.signUpUsersListM[i].approvedList;
        [self.approvedList arrayByAddingObjectsFromArray:self.signUpUsersListM[i].approvedList];
    }
    

    
    //    new.isShowDate = [self isShowDateWithIndexPath:indexPath];
    
    cell.approvedList = self.approvedList[indexPath.section];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return  70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
