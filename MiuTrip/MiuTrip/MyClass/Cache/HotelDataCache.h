//
//  HotelCache.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-29.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelCustomerModel.h"

@interface HotelDataCache : NSObject


@property (assign, nonatomic) BOOL                 isPrivte;              //因公 因私
@property (assign, nonatomic) BOOL                 isForSelf;             //为自己 为他人/多人
@property (assign, nonatomic) BOOL                 isPrePay;              //现付 预付

@property (strong, nonatomic) NSString             *checkInCityName;       //目标城市
@property (nonatomic)         int                  checkInCityId;
@property (strong, nonatomic) NSDate               *checkInDate;           //入住时间
@property (strong, nonatomic) NSDate               *checkOutDate;          //离店时间
@property (strong, nonatomic) NSArray              *priceRangeArray;
@property (nonatomic) int                          priceRangeIndex;        //价格区间
@property (strong,nonatomic)  NSString             *lat;
@property (strong,nonatomic)  NSString             *lng;
@property (strong, nonatomic) NSString             *queryCantonName;         //酒店位置
@property (nonatomic) int                          queryCantonId;         //酒店所在区ID
@property (strong, nonatomic) NSString             *keyWord;              //酒店名字

@property (strong, nonatomic) NSMutableArray              *customers;             //入住人


@property (strong, nonatomic) NSString             *orderNum;              //订单号
@property (assign, nonatomic) NSInteger            orderStatus;            //订单状态
@property (assign, nonatomic) NSInteger            returnOrderPayType;     //订单列表支付类型
@property (assign, nonatomic) NSInteger            orderType;              //房间数&入住时间&价格

@property (nonatomic)         int                  contactorId;
@property (strong, nonatomic) NSString             *contactorName;
@property (strong, nonatomic) NSString             *contactorMobile;


@property (nonatomic)         int                  selectedHotelId;
@property (strong, nonatomic) NSString             *selectedHotelName;
@property (strong, nonatomic) NSString             *selectedReasonCode;
@property (strong, nonatomic) NSDictionary         *selectedRoomData;

@property (strong, nonatomic) HotelCustomerModel   *executor;

@property (strong, nonatomic) NSString             *arriveTime;
@property (strong, nonatomic) NSString             *guestMobile;
@property (nonatomic)         int                  roomCount;


+ (HotelDataCache*)sharedInstance;
@end
