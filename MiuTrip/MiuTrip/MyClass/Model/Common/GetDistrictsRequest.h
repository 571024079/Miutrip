//
//  GetDistrictsRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"

@interface GetDistrictsRequest : BaseRequestModel

@property (nonatomic , strong) NSNumber  *CityID;
@end
