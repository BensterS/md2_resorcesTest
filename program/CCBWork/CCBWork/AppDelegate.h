//
//  AppDelegate.h
//  CCBWork
//
//  Created by Benster on 14-9-9.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSComboBox* _choseComBox;            //执行按钮
    
    IBOutlet NSTextField* _ccbResPathTF;   //ccb源目录
    
    IBOutlet NSTextField* _ccbDesPathTF;   //cbb目标目录
    
    IBOutlet NSTextField* _imgResPathTF;   //图片资源源目录
    
    IBOutlet NSTextField* _imgDesPathTF;   //图片资源目标目录
    
    IBOutlet NSTextField* _logPathTF;      //日志输出目录
}
@property (assign) IBOutlet NSWindow *window;

@end
