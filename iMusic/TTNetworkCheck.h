//
//  TTNetworkCheck.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 12/1/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
@interface TTNetworkCheck : NSObject
+ (BOOL)hasConnectivity;
@end
