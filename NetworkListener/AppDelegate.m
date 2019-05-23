//
//  AppDelegate.m
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "AppDelegate.h"
#import "PMURLProtocol.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [PMURLProtocol networkListener:YES];
    
//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[MailViewController alloc]init]];
    
    return YES;
}





@end
