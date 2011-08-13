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
	if( (self = [super init]) )
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

#pragma - Static Methods
+ (Product*) productWithDict:(NSDictionary*)dict
{
    NSString* type = [dict objectForKey:@"Type"];
    NSAssert(type, @"No type given for product");
    if(!type) 
    { 
        type = @"Product"; 
    }
    
    return [[[NSClassFromString(type) alloc] initWithParams:dict] autorelease];
}

+ (Product*) productWithPlist:(NSString *)file
{
    NSDictionary* params = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"plist"]];
    return [Product productWithDict:params];
}

@end
