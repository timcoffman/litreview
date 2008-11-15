//
//  TDToken.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	TDTT_EOF,
	TDTT_NUMBER,
	TDTT_QUOTED,
	TDTT_SYMBOL,
	TDTT_WORD
} TDTokenType;

@interface TDToken : NSObject {
	CGFloat floatValue;
	NSString *stringValue;
	TDTokenType tokenType;
	
	BOOL number;
	BOOL quotedString;
	BOOL symbol;
	BOOL word;
	
	id value;
}
+ (TDToken *)EOFToken;
+ (id)tokenWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n;

// designated initializer
- (id)initWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n;

- (BOOL)isEqualIgnoringCase:(id)obj;

- (NSString *)debugDescription;

@property (nonatomic, readonly, getter=isNumber) BOOL number;
@property (nonatomic, readonly, getter=isQuotedString) BOOL quotedString;
@property (nonatomic, readonly, getter=isSymbol) BOOL symbol;
@property (nonatomic, readonly, getter=isWord) BOOL word;

@property (nonatomic, readonly) TDTokenType tokenType;
@property (nonatomic, readonly) CGFloat floatValue;
@property (nonatomic, readonly, copy) NSString *stringValue;
@property (nonatomic, readonly, copy) id value;
@end
