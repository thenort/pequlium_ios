//
//  Manager.h
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject

+ (instancetype) sharedInstance;

- (void)saveInData:(NSString*)textFromTextField withKey:(NSString*)key;
- (NSString*)getDebitFromData:(NSString*)key;

@end
