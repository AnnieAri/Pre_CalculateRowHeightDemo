//
//  User.h
//  05-Runtime(字典转模型)
//
//  Created by yz on 15/10/14.
//  Copyright © 2015年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *profile_image_url;

@property (nonatomic, assign) BOOL vip;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int mbrank;

@property (nonatomic, assign) int mbtype;


@end
