//
//  TDSlashState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

@class TDSlashSlashState;
@class TDSlashStarState;

@interface TDSlashState : TDTokenizerState {
	TDSlashSlashState *slashSlashState;
	TDSlashStarState *slashStarState;
}
@end
