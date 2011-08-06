//
//  CrabuxProduct.m
//  Crabitron
//
//  Created by Dylan Sale on 6/08/11.
//  Copyright 2011 Two Lives Left Pty. Ltd. All rights reserved.
//

#import "CurrencyProduct.h"

@implementation CurrencyProduct

- (id) initWithParams:(NSDictionary*)params
{
    self = [super initWithParams:params];
    if (self) 
    {
        currencyKey = [[params objectForKey:@"CurrencyKey"] retain];
        unlockAmount = [[params objectForKey:@"UnlockAmount"] intValue];
    }
    
    return self;
}

- (void) purchasedWith:(SKPaymentTransaction *)transaction
{
    NSInteger crabux = [[NSUserDefaults standardUserDefaults] integerForKey:currencyKey];
    crabux += unlockAmount;
    [[NSUserDefaults standardUserDefaults] setInteger:crabux forKey:currencyKey];
}

- (void) dealloc
{
    [currencyKey release];
    [super dealloc];
}

@end
