//
//  Product.mm
//  inCline
//
//  Created by Simeon on 6/4/10.
//  Copyright 2010 Two Lives Left. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize productID, productName, sortOrder, displayProperties;

- (id) initWithParams:(NSDictionary *)params
{
	if( self = [super init] )
	{
		productID = [[params objectForKey:@"ID"] retain];
		productName = [[params objectForKey:@"Name"] retain];
        sortOrder = [[params objectForKey:@"SortOrder"] intValue];
        displayProperties = [[params objectForKey:@"DisplayProperties"] retain];
    }
	return self;
}

- (bool) willStartPurchase
{
	return true;
}

- (void) purchasedWith:(SKPaymentTransaction *)transaction
{
}

- (void) purchaseFailed:(SKPaymentTransaction *)transaction
{
}

- (void) dealloc
{
	[productID release];
	[productName release];	
	[displayProperties release];
	[super dealloc];
}

@end
