//
//  NRNestCameraFetcher.m
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "appmacros.h"
#import "NRNestCameraFetcher.h"
#import "NRNestAccessService.h"
#import "NREventSource.h"
#import "NRCommonExtensions.h"

@interface CameraEvent()

    @property(nonatomic,readwrite) NSDate* eventStart;
    @property(nonatomic,readwrite) NSDate* eventStop;

@end

@implementation CameraEvent

+ (instancetype) cameraEventStarted:( NSDate* _Nonnull )start stopped:(NSDate* _Nullable)stop motion:(BOOL)motion sound:(BOOL)sound person:(BOOL)person
{
    CameraEvent* event = [[CameraEvent alloc] init];
    event.eventStart = start;
    event.eventStop  = stop;
    event.type = (motion ? cet_motion : cet_nothing) | (sound ? cet_sound : cet_nothing) | (person ? cet_person : cet_nothing);
    return event;
}

@end

@interface NRNestCameraFetcher()

    @property(readonly) NSMutableDictionary<NSString*,CameraEventHandler>* cameraEventListeners;
    @property(readonly) NSMutableDictionary<NSString*,NSDate*>* cameraRegisterDates;

    @property(readonly) NSMutableDictionary<NSString*,NSDate*>* cameraEventStarts;
    @property(readonly) NSMutableDictionary<NSString*,NSDate*>* cameraEventStops;

@end

@implementation NRNestCameraFetcher
{
    NREventSource* sseSource;
    NSDictionary* _cameras;   // full json
    NSDictionary* _cameraIDs; // {name:id}
    
    NSMutableDictionary<NSString*,CameraEventHandler>* _cameraEventListeners;
    NSMutableDictionary<NSString*,NSDate*>* _cameraRegisterDates;
    NSMutableDictionary<NSString*,NSDate*>* _cameraEventStarts;
    NSMutableDictionary<NSString*,NSDate*>* _cameraEventStops;
}

- (NSMutableDictionary<NSString*,CameraEventHandler>*) cameraEventListeners
{
    if(_cameraEventListeners == nil ) _cameraEventListeners = [[NSMutableDictionary alloc] init];
    return _cameraEventListeners;
}
- (NSMutableDictionary<NSString*,NSDate*>*) cameraRegisterDates
{
    if(_cameraRegisterDates == nil ) _cameraRegisterDates = [[NSMutableDictionary alloc] init];
    return _cameraRegisterDates;
}
- (NSMutableDictionary<NSString*,NSDate*>*) cameraEventStarts
{
    if(_cameraEventStarts == nil ) _cameraEventStarts = [[NSMutableDictionary alloc] init];
    return _cameraEventStarts;
}
- (NSMutableDictionary<NSString*,NSDate*>*) cameraEventStops
{
    if(_cameraEventStops == nil ) _cameraEventStops = [[NSMutableDictionary alloc] init];
    return _cameraEventStops;
}

#pragma mark - ACCESS INTERFACE

- (NSDictionary*) cameraIDs
{
    return _cameraIDs;
}
- (NSArray*) cameraNames
{
    return [_cameraIDs allKeys];
}

- (void) switchOnListenerForCameraID:(NSString*)cid handler:(CameraEventHandler)eventHandler
{
    [self.cameraEventListeners setObject:eventHandler forKey:cid];
    [self.cameraRegisterDates setObject:[NSDate date] forKey:cid];
    [self.cameraEventStarts setObject:[NSDate date] forKey:cid];
    [self.cameraEventStops setObject:[NSDate date] forKey:cid];
}
- (void) switchOffListenerForCameraID:(NSString*)cid
{
    if(self.cameraEventListeners.count == 0 ) return;
    [self.cameraEventListeners removeObjectForKey:cid];
    [self.cameraRegisterDates removeObjectForKey:cid];
    [self.cameraEventStarts removeObjectForKey:cid];
    [self.cameraEventStops removeObjectForKey:cid];
}

#pragma mark - CONTROL INTERFACE

- (void) startSimulatedCamerasObserving:(NSString*)eventName
{
    sseSource = [NREventSource eventSourceWithEventListener:eventName];
    [self addCameraEventListener];
}

- (void) startCamerasObserving
{
    sseSource = [NREventSource eventSourceWithURL:[NRNestAccessService shared].camerasURL];
    [self addCameraEventListener];
}

- (void) addCameraEventListener
{
    NRNestCameraFetcher* __weak wself = self;
    [sseSource addEventListener:@"put" handler:^(Event *e) 
     {
         NSData* json_data = [e.data dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:json_data
                                                              options:NSJSONReadingMutableContainers
                                                                error:nil];
         NSDictionary* events_data = json[@"data"];
         if(events_data!=nil)
         {
             [wself updateCameraEventListenersWith:events_data];
         }
     }];
    
    // ALL EVENTS: very messy, do not uncomment
    //    [source onMessage:^(Event *e) {
    //        NSLog(@"%@: %@", e.event, e.data);
    //    }];
}
- (void) fetchCameras:(FetcherCompletionHandler)handler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:[NRNestAccessService shared].camerasPollRequest
    completionHandler:
    ^(NSData *data, NSURLResponse *response, NSError *error) 
    {
        if(error) 
        {
            NSLog(@"%@", error);
            handler(NO);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"%@", httpResponse);
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        if(!json)                 
        {
            [self handleAccessError:@"invalide responce data" description:@""];
            handler(NO);
            return;
        }
        else if(json[@"error"] != nil) 
        {
            [self handleAccessError:json[@"error"] description:json[@"error_description"]];
            handler(NO);
            return;
        }
        
        _cameras = json;
        [self validateCameraNames];
        handler(YES);
    }];
    [dataTask resume];
}

#pragma mark - ROUTINES

- (void) updateCameraEventListenersWith:(NSDictionary<NSString*,NSDictionary*>*)data
{
    if(_cameraEventListeners.count <= 0) return;
    
    [data enumerateKeysAndObjectsUsingBlock:
     ^(NSString* _Nonnull cid, NSDictionary* _Nonnull event, BOOL* _Nonnull stop) 
    {
        NSLog(@"NestCameraFetches: event received");
        CameraEventHandler handler = _cameraEventListeners[cid];
        if(handler == nil)
        {
            NSLog(@"NestCameraFetches: event not handled - no handler registersd for the cam id: %@",cid);
            return;
        }
        
        NSDictionary* cam_event_dict = event[@"last_event"];
        if(cam_event_dict == nil) return;
        
        NSString* event_start_string = cam_event_dict[@"start_time"];
        NSString* event_stop_string = cam_event_dict[@"end_time"];
        if(EMPTY(event_start_string) || EMPTY(event_stop_string))
        {
            NSLog(@"NestCameraFetches: event not handled - event start or stop date or both are empty");
            return;
        };
        
        NSDate* event_start = [NSDate getDateFromDateString: event_start_string];
        NSDate* event_stop  = [NSDate getDateFromDateString: event_stop_string];
        NSDate* last_start  = self.cameraEventStarts[cid];
        NSDate* last_stop   = self.cameraEventStops[cid];
        NSDate* register_date = self.cameraRegisterDates[cid];
        
        BOOL startstopped_earlier = ([event_start compare:register_date] == NSOrderedAscending) && ([event_stop compare:register_date] == NSOrderedAscending);
        if(startstopped_earlier)
        {
            NSLog(@"NestCameraFetches: event not handled - event earlier than handler registered");
            return;
        };
        
        BOOL stop_earlier_than_start = [event_start compare:event_stop] == NSOrderedDescending;
        BOOL start_not_changed       = [event_start compare:last_start] == NSOrderedSame;
        BOOL stop_not_changed        = [event_stop compare:last_stop] == NSOrderedSame;
        if(start_not_changed && (stop_not_changed || stop_earlier_than_start))
        {
            NSLog(@"NestCameraFetches: event not handled - duplicate event or stoped earlier than started");
            return;
        };
        
        self.cameraEventStarts[cid] = event_start;
        self.cameraEventStops[cid]  = event_stop;
        
        CameraEvent* cam_event = [CameraEvent cameraEventStarted:event_start 
                                                         stopped:(stop_earlier_than_start)?nil:event_stop 
                                                          motion:((NSNumber*)cam_event_dict[@"has_motion"]).boolValue 
                                                           sound:((NSNumber*)cam_event_dict[@"has_sound"]).boolValue 
                                                          person:((NSNumber*)cam_event_dict[@"has_person"]).boolValue];
        
        handler(cam_event);
        NSLog(@"NestCameraFetches: event handled and sent to camera observer");
    }];
}

- (void) validateCameraNames
{
    NSMutableDictionary* camera_ids = [[NSMutableDictionary alloc] init];
    [_cameras enumerateKeysAndObjectsUsingBlock:
    ^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) 
    {
        NSString* name = obj[@"name"];
        NSString* cid = key;
        [camera_ids setValue:cid forKey:name];
    }];
    _cameraIDs = camera_ids;
}

- (void) handleAccessError:(NSString*)name description:(NSString*)description
{
    NSLog(@"NRNestCameraFetcher Response ERROR: %@ %@", name, description);
}

#pragma mark - PERSISTANCE

+ (instancetype) shared
{
    static dispatch_once_t pred;
    static NRNestCameraFetcher* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init];});
    return _instance;
}

@end
