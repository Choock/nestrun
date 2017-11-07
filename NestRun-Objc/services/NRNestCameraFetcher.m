//
//  NRNestCameraFetcher.m
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRNestCameraFetcher.h"
#import "NRNestAccessService.h"

@implementation NRNestCameraFetcher
{
    NSDictionary* _cameras;   // full json
    NSDictionary* _cameraIDs; // {name:id}
    NSDictionary* _lastEvents;// {name:event_dictionary}
}

#pragma mark - INTERFACE

- (NSDictionary*) cameraIDs
{
    return _cameraIDs;
}
- (NSDictionary*) cameraLatEvents
{
    return _lastEvents;
}
- (NSArray*) cameraNames
{
    return [_cameraIDs allKeys];
}

- (void) fetchCameras:(FetcherCompletionHandler)handler
{
    // TODO: move this boilerplate to access service in method createRequestFor:
    NSURL* cameras_url = [NSURL URLWithString:@"https://firebase-apiserver04-tah01-iad01.dapi.production.nest.com:9553/devices/cameras/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:cameras_url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    NSString* bearer = [NRNestAccessService shared].accessToken.bearer;
    NSDictionary* headers = @{ 
                               @"authorization":bearer,
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache"
                            };
    
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
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

- (void) fetchEventForCamera:(NSString*)spotName completion:(FetcherCompletionHandler)handler
{
    
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
