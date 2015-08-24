//
//  CommonDef.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef __________CommonDef_h
#define __________CommonDef_h

// 屏幕尺寸
#define kNENScreenW [UIScreen mainScreen].bounds.size.width
#define kNENScreenH [UIScreen mainScreen].bounds.size.height

// 颜色相关的宏
#define NENColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define NENandomColor NENColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 通知中心
#define NENNotificationCenter [NSNotificationCenter defaultCenter]

#endif
