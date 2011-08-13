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
    NSInteger amount = [[NSUserDefaults standardUserDefaults] integerForKey:currencyKey];
    amount += unlockAmount;
    [[NSUserDefaults standardUserDefaults] setInteger:amount forKey:currencyKey];
}

- (void) spend:(NSUInteger)amount
{
    [CurrencyProduct spend:amount ofCurrency:currencyKey];
}

- (NSInteger) amountLeft
{
    return [CurrencyProduct amountLeftForCurrency:currencyKey];
}


- (void) dealloc
{
    [currencyKey release];
    [super dealloc];
}

#pragma - Static Methods
+ (void) spend:(NSUInteger)amount ofCurrency:(NSString*) currencyKey
{
    NSInteger currentAmount = [[NSUserDefaults standardUserDefaults] integerForKey:currencyKey];
    currentAmount -= amount;
    [[NSUserDefaults standardUserDefaults] setInteger:currentAmount forKey:currencyKey];
}

+ (NSInteger) amountLeftForCurrency:(NSString*) currencyKey
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:currencyKey];
}



@end
