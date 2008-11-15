//
//  TDTokenAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDAssembly.h>

@class TDTokenizer;

@interface TDTokenAssembly : TDAssembly <NSCopying> {
	TDTokenizer *tokenizer;
	NSMutableArray *tokens;
}
@property (nonatomic, retain) TDTokenizer *tokenizer;
@end
