//
//  TDSymbolNode.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSymbolNode : NSObject {
	NSString *ancestry;
	TDSymbolNode *parent;
	NSMutableDictionary *children;
	NSInteger character;
}
- (id)initWithParent:(TDSymbolNode *)p character:(NSInteger)c;
@property (nonatomic, readonly, retain) NSString *ancestry;
@property (nonatomic, readonly, assign) TDSymbolNode *parent; // this must be 'assign' to avoid retain loop leak
@property (nonatomic, readonly, retain) NSMutableDictionary *children;
@property (nonatomic, readonly) NSInteger character;
@end
