//
//  TDSymbolRootNode.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDSymbolNode.h>

@class TDReader;

@interface TDSymbolRootNode : TDSymbolNode {
}
- (void)add:(NSString *)s;
- (NSString *)nextSymbol:(TDReader *)r startingWith:(NSInteger)cin;
@end
