//
//  CrabuxProduct.h
//  Crabitron
//
//  Created by Dylan Sale on 6/08/11.
//  Copyright 2011 Two Lives Left Pty. Ltd. All rights reserved.
//

#import "Product.h"

@interface CurrencyProduct : Product
{
    NSString* currencyKey;
    int unlockAmount; //number of Crabux to unlock when this product is purchased
}

@end
