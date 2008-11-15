//
//  TDLiteral.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

@class TDToken;

@interface TDLiteral : TDTerminal {
	TDToken *literal;
}
+ (id)literal;
+ (id)literalWithString:(NSString *)s;
@end
