//
//  GetCorpSeverCardList.h
//  MiuTrip
//
//  Created by Y on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCorpServerCardListResponse.h"
///////////////GetServerCaardRequest//////////////////////////////////////


@interface GetCorpServerCardListRequest : BaseRequestModel

@property (strong, nonatomic) NSString      *CorpID;

@end

