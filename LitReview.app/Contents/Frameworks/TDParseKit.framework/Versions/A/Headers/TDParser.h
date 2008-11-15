//
//  TDParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDAssembly;

@interface NSString (TDParseKitAdditions)
- (NSString *)stringByRemovingFirstAndLastCharacters;
@end

@interface TDParser : NSObject {
	id assembler;
	SEL selector;
	NSString *name;
}
+ (id)parser;
- (void)setAssembler:(id)a selector:(SEL)sel;

- (TDAssembly *)bestMatchFor:(TDAssembly *)inAssembly;
- (TDAssembly *)completeMatchFor:(TDAssembly *)inAssembly;

@property (nonatomic, retain) id assembler;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSString *name;
@end
