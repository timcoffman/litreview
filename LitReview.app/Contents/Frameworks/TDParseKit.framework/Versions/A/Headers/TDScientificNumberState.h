//
//  TDScientificNumberState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <TDParseKit/TDNumberState.h>

@interface TDScientificNumberState : TDNumberState {
	CGFloat exp;
	BOOL negativeExp;
}

@end
