//
//  HMGLog.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/23/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGLog.h"


static void AddStderrOnce()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        asl_add_log_file(NULL, STDERR_FILENO);
    });
}

// Implementing the log functions (making one "template" implementation and then repeating it for each log level)
#define __HMG_MAKE_LOG_FUNCTION(LEVEL, NAME) \
    void NAME (NSString *format, ...) \
    { \
        AddStderrOnce(); \
        va_list args; \
        va_start(args, format); \
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args]; \
        asl_log(NULL, NULL, (LEVEL), "%s", [message UTF8String]); \
        va_end(args); \
    }

#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_ERR
__HMG_MAKE_LOG_FUNCTION(ASL_LEVEL_ERR, HMGLogError)
#endif

#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_WARNING
__HMG_MAKE_LOG_FUNCTION(ASL_LEVEL_WARNING, HMGLogWarning)
#endif

#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_NOTICE
__HMG_MAKE_LOG_FUNCTION(ASL_LEVEL_NOTICE, HMGLogNotice)
#endif

#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_INFO
__HMG_MAKE_LOG_FUNCTION(ASL_LEVEL_INFO, HMGLogInfo)
#endif

#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_DEBUG
__HMG_MAKE_LOG_FUNCTION(ASL_LEVEL_DEBUG, HMGLogDebug)
#endif

//__HMG_MAKE_LOG_FUNCTION(ASL_LEVEL_ALERT, HMGLogAlert)
//__HMG_MAKE_LOG_FUNCTION(ASL_LEVEL_EMERG, HMGLogEmergency)
//__HMG_MAKE_LOG_FUNCTION(ASL_LEVEL_CRIT, HMGLogCritical)

#undef __HMG_MAKE_LOG_FUNCTION
