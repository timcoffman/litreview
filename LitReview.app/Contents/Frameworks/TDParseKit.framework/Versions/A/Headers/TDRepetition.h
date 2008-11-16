//
//  TDRepetition.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

@interface TDRepetition : TDParser {
	TDParser *subparser;
	id preAssembler;
	SEL preAssemblerSelector;
}
+ (id)repetition;
+ (id)repetitionWithSubparser:(TDParser *)p;

// designated initializer
- (id)initWithSubparser:(TDParser *)p;

@end