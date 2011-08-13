//
//  ProductManagerAppDelegate.m
//  ProductManager
//
//  Created by Dylan Sale on 6/08/11.
//  Copyright 2011 Two Lives Left Pty Ltd. All rights reserved.
//

#import "ProductManagerAppDelegate.h"
#import "ProductManager.h"
#import "Product.h"


@implementation ProductManagerAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    

    /*
     * Example code for registering products with the ProductManager
     */
    if([ProductManager sharedInstance].storeEnabled)
    {
        /* you could do it this way if you wanted
        NSDictionary* params = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ExampleProduct" ofType:@"plist"]];
        Product* testProduct = [[[Product alloc] initWithParams:params] autorelease];
         [[ProductManager sharedInstance] registerProduct:testProduct];
         */
        
        //Will load the products out of a Product.plist file which has an array of dictionaries.
        [[ProductManager sharedInstance] registerProductsFromPlist];

        //Start observing as soon as possible
        [[ProductManager sharedInstance] startObserving];
        
        //The store, or whatever you want to react to purchases should use the
        //ProductPurchaseDelegate and set itself on the ProductManager like so:
        //[ProductManager sharedInstance].purchaseDelegate = something; 

    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
