//
//  TDSymbol.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

@class TDToken;

@interface TDSymbol : TDTerminal {
	TDToken *symbol;
}
+ (id)symbol;
+ (id)symbolWithString:(NSString *)s;
@end
