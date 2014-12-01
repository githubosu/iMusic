//
//  TTNetworkCheck.m
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 12/1/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTNetworkCheck.h"

@implementation TTNetworkCheck

+ (BOOL)hasConnectivity {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
