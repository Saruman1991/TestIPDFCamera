//
//  AppDelegate.h
//  TestCamera
//
//  Created by Elian Medeiros on 26/05/17.
//  Copyright © 2017 Elian Medeiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

