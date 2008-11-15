//
//  TDParseKit.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDToken;
@class TDTokenizerState;
@class TDNumberState;
@class TDQuoteState;
@class TDSlashState;
@class TDSymbolState;
@class TDWhitespaceState;
@class TDWordState;
@class TDReader;

@interface TDTokenizer : NSObject {
	NSString *string;
	TDReader *reader;
	
	NSMutableArray *tokenizerStates;
	
	//states
	TDNumberState *numberState;
	TDQuoteState *quoteState;
	TDSlashState *slashState;
	TDSymbolState *symbolState;
	TDWhitespaceState *whitespaceState;
	TDWordState *wordState;
}
+ (id)tokenizer;
+ (id)tokenizerWithString:(NSString *)s;

- (id)initWithString:(NSString *)s;
- (TDToken *)nextToken;
- (void)setTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end;

@property (nonatomic, copy) NSString *string;

@property (nonatomic, retain) TDNumberState *numberState;
@property (nonatomic, retain) TDQuoteState *quoteState;
@property (nonatomic, retain) TDSlashState *slashState;
@property (nonatomic, retain) TDSymbolState *symbolState;
@property (nonatomic, retain) TDWhitespaceState *whitespaceState;
@property (nonatomic, retain) TDWordState *wordState;
@end
