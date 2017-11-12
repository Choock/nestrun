//
//  EventSource.h
//  NestRun-Objc
//
//  Added by Dima Choock on 06/11/2017.
//
//  Copyright (c) 2013 Neil Cowburn (http://github.com/neilco/)
//
//  MIT License (https://neil.mit-license.org/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this 
//  software and associated documentation files (the "Software"), to deal in the Software 
//  without restriction, including without limitation the rights to use, copy, modify, merge, 
//  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
//  to whom the Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all copies or 
//  substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

typedef enum {
    kEventStateConnecting = 0,
    kEventStateOpen = 1,
    kEventStateClosed = 2,
} EventState;

// ---------------------------------------------------------------------------------------------------------------------

/// Describes an Event received from an EventSource
@interface Event : NSObject

/// The Event ID
@property (nonatomic, strong) id id;
/// The name of the Event
@property (nonatomic, strong) NSString *event;
/// The data received from the EventSource
@property (nonatomic, strong) NSString *data;

/// The current state of the connection to the EventSource
@property (nonatomic, assign) EventState readyState;
/// Provides details of any errors with the connection to the EventSource
@property (nonatomic, strong) NSError *error;

@end

// ---------------------------------------------------------------------------------------------------------------------

typedef void (^EventSourceEventHandler)(Event *event);

// ---------------------------------------------------------------------------------------------------------------------

/// Connect to and receive Server-Sent Events (SSEs).
@interface NREventSource : NSObject

/// Returns a new instance of EventSource with the specified URL.
///
/// @param URL The URL of the EventSource.
+ (instancetype)eventSourceWithURL:(NSURL *)URL;

/// Returns a new instance of EventSource with the specified URL.
///
/// @param URL The URL of the EventSource.
/// @param timeoutInterval The request timeout interval in seconds. See <tt>NSURLRequest</tt> for more details. Default: 5 minutes.
+ (instancetype)eventSourceWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval;

/// Creates a new instance of EventSource with the specified URL.
///
/// @param URL The URL of the EventSource.
- (instancetype)initWithURL:(NSURL *)URL;

/// Creates a new instance of EventSource with the specified URL.
///
/// @param URL The URL of the EventSource.
/// @param timeoutInterval The request timeout interval in seconds. See <tt>NSURLRequest</tt> for more details. Default: 5 minutes.
- (instancetype)initWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval;

/// Registers an event handler for the Message event.
///
/// @param handler The handler for the Message event.
- (void)onMessage:(EventSourceEventHandler)handler;

/// Registers an event handler for the Error event.
///
/// @param handler The handler for the Error event.
- (void)onError:(EventSourceEventHandler)handler;

/// Registers an event handler for the Open event.
///
/// @param handler The handler for the Open event.
- (void)onOpen:(EventSourceEventHandler)handler;

- (void)onReadyStateChanged:(EventSourceEventHandler)handler;

/// Registers an event handler for a named event.
///
/// @param eventName The name of the event you registered.
/// @param handler The handler for the Message event.
- (void)addEventListener:(NSString *)eventName handler:(EventSourceEventHandler)handler;

/// Closes the connection to the EventSource.
- (void)close;

@end

// ---------------------------------------------------------------------------------------------------------------------

extern NSString *const MessageEvent;
extern NSString *const ErrorEvent;
extern NSString *const OpenEvent;
extern NSString *const ReadyStateEvent;
