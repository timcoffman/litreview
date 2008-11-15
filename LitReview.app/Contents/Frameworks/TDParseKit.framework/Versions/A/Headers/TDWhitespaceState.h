//
//  TDWhitespaceState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

@interface TDWhitespaceState : TDTokenizerState {
	NSInteger c;
	NSMutableArray *whitespaceChars;
	NSNumber *yesFlag;
	NSNumber *noFlag;
}
- (BOOL)isWhitespaceChar:(NSInteger)cin;
- (void)setWhitespaceChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;
@end
