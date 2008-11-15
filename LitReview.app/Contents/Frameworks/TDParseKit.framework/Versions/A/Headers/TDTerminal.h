//
//  TDTerminal.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

@class TDToken;

// Abstract class
@interface TDTerminal : TDParser {
	NSString *string;
	BOOL discard;
}
+ (id)terminal;
+ (id)terminalWithString:(NSString *)s;
- (id)initWithString:(NSString *)s;

- (TDTerminal *)discard;

@property (nonatomic, readonly, copy) NSString *string;
@end
