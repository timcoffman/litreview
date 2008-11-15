//
//  TDParseKitState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDToken;
@class TDTokenizer;
@class TDReader;

@interface TDTokenizerState : NSObject {
	NSMutableString *stringbuf;
}
- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t;
@end
