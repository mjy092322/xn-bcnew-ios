//
//  activityBottom.h
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
#import "DetailActModel.h"
@interface activityBottom : BaseView
@property (nonatomic, strong) DetailActModel *detailActModel;

//编号
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *content;

@end
