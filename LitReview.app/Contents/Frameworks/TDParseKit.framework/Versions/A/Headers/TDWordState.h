//
//  TDWordState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

@interface TDWordState : TDTokenizerState {
	NSMutableArray *wordChars;
	NSNumber *yesFlag;
	NSNumber *noFlag;
}
- (void)setWordChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;
- (BOOL)isWordChar:(NSInteger)c;
@end
