//
//  TDAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDAssembly : NSObject <NSCopying> {
	NSMutableArray *stack;
	id target;
	NSInteger index;
	NSString *string;
	NSString *defaultDelimiter;
}
+ (id)assemblyWithString:(NSString *)s;

// designated initializer
- (id)initWithString:(NSString *)s;
- (id)peek;
- (id)next;
- (BOOL)hasMore;

- (NSString *)consumed:(NSString *)delimiter;
- (NSString *)remainder:(NSString *)delimiter;

- (id)pop;
- (void)push:(id)object;
- (BOOL)isStackEmpty;

- (NSArray *)objectsAbove:(id)fence;

@property (nonatomic, readonly) NSInteger length;
@property (nonatomic, readonly) NSInteger objectsConsumed;
@property (nonatomic, readonly) NSInteger objectsRemaining;

@property (nonatomic, readonly, copy) NSString *defaultDelimiter;
@property (nonatomic, readonly, retain) NSMutableArray *stack;
@property (nonatomic, retain) id target;
@end
