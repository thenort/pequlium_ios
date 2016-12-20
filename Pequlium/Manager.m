//
//  Manager.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "Manager.h"

@implementation Manager

#pragma mark - Singletone Methods -

+ (instancetype) sharedInstance {
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

- (void)saveInData:(NSString*)textFromTextField withKey:(NSString*)key {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    double monthDebitDouble = [textFromTextField doubleValue];
    [userDefault setDouble:monthDebitDouble forKey:key];
    [userDefault synchronize];

}

- (NSString*)getDebitFromData:(NSString*)key {
    
    double monthDebitFromData = [[NSUserDefaults standardUserDefaults]doubleForKey:key];
    return [NSString stringWithFormat:@"%g", monthDebitFromData];
    
}


@end
