//
//  TDNumberState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

@interface TDNumberState : TDTokenizerState {
	BOOL allowsTrailingDot;
	BOOL gotADigit;
	BOOL negative;
	NSInteger c;
	CGFloat floatValue;
}
@property (nonatomic) BOOL allowsTrailingDot;
@end
