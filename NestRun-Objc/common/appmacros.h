//
//  AppMacros.h
//  App Components
//
//  Created by Dmitry Demenchoock on 11/8/14.
//  Copyright (c) 2014 UAB Mechanikus Ltd. All rights reserved.
//

#ifndef _AppMacros_h
#define _AppMacros_h

// Names declartion macrodefinitions

#define NAME_VALUE(name,value) static NSString*  name=@#value;
#define PARAMETER_NAME(name) static NSString*  name=@#name;
#define KEY_NAME(name) static NSString*  name=@#name;
#define ASSET_NAME(name) static NSString*  name=@#name;
#define EVENT_NAME(name) static NSString*  name=@#name;
#define STRING_NAME(name) static NSString*  name=@#name;
#define FLOAT_CONTS(name,value) static const CGFloat name = value;
#define EQS(str1,str2) [str1 isEqualToString:str2]

// ALIASE MACROS
#define ST_INLINE static __inline__

#endif
