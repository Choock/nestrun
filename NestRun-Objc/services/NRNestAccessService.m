//
//  NRNestAccessService.m
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "appmacros.h"
#import "NRNestAccessService.h"

@interface NestAccessToken()
    @property(nonatomic, readwrite) NSString* string;
@end 

@implementation NestAccessToken
{
    NSDate* _expiresOn;
}

- (NSString*) string
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"natString"];
}
- (void) setString:(NSString*) value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"natString"];
}

- (BOOL) isValid
{
    if (self.string != nil)
    {
        if ([[NSDate date] compare:_expiresOn] == NSOrderedAscending) {return YES;}
    }
    return NO;
}

- (void) resetWith: (NSDictionary*) json
{
    NSNumber* interval = json[@"expires_in"];
    NSString* token    = json[@"access_token"];
    if(interval != nil) {_expiresOn = [[NSDate date] dateByAddingTimeInterval:[interval doubleValue]];}
    if(token != nil)    {self.string = token;}
}

@end

static NSString* NEST_HOST           = @"home.nest.com";
static NSString* NEST_PRODICT_ID     = @"e68c8ac7-2708-449a-a7e4-b008a63ef820";
static NSString* NEST_PRODUCT_SECRET = @"jyxn6RuIwTF5LmRS1oInREc08";
static NSString* NEST_AUTH_URL       = @"https://home.nest.com/login/oauth2?client_id=e68c8ac7-2708-449a-a7e4-b008a63ef820&state=STATE";
static NSString* PRODUCT_REDIR_HOST  = @"https://localhost:8080";
static NSString* PRODUCT_REDIR_PATH  = @"/auth/nest/callback";

@interface NRNestAccessService() <UIWebViewDelegate>
@end

@implementation NRNestAccessService
{
    AccessReceived _accessCallback;
}

#pragma mark - INTERFACE

- (BOOL) accessGranted
{
    return [_accessToken isValid];
}

- (void) loginIn:(UIWebView*)view callback:(AccessReceived) block
{
    _accessCallback = block;
    [self loadNestAuthUIInWebView:view];
}

#pragma mark - AUTHRIZATION CODE

- (void) loadNestAuthUIInWebView:(UIWebView*) view
{
    view.delegate = self;
    [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NEST_AUTH_URL]]];
}

- (void) getNestAccessWith:(NSString*) url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    [[session dataTaskWithRequest:request completionHandler:
    ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) 
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"AuthManager Token Response Status Code: %ld", (long)[httpResponse statusCode]);

        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        if(!json) 
        {
            NSLog(@"NestAuthService Token Response ERROR: invalide responce data" );
            _accessCallback(NO);
            _accessCallback = nil;
            return;
        }
        if(!_accessToken) _accessToken = [[NestAccessToken alloc] init];
        [_accessToken resetWith:json];
        _accessCallback(YES);
        _accessCallback = nil;
    }] resume];
}

#pragma mark - WEBVIEW DELEGATE

/// Intercept the requests to get the authorization code before the webView loads.
/// First request goes to Nest with the redirect-url as parameter, then Nest tries to load content with the redirect-url
/// and here the method catches this attempt and takes the pin-code from parameters
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* request_url = [request URL];
    if(!request_url || !EQS(request_url.path,PRODUCT_REDIR_PATH)) return YES;
   
    NSArray<NSURLQueryItem*>* querry_items = [NSURLComponents componentsWithString:[request_url absoluteString]].queryItems;
    NSString* code = nil;
    for( NSURLQueryItem* querry in querry_items)
    {
        if(!EQS(querry.name,@"code")) continue;
        code = querry.value;
        break;
    }
    if(!code) return YES;
    
    NSString* request_token_url = [NSString stringWithFormat:@"https://api.%@/oauth2/access_token?code=%@&client_id=%@)&client_secret=%@&grant_type=authorization_code", NEST_HOST, code, NEST_PRODICT_ID, NEST_PRODUCT_SECRET];
    [self getNestAccessWith:request_token_url];
    return NO;
}

#pragma mark - PERSISTANCE

+ (instancetype) shared
{
    static dispatch_once_t pred;
    static NRNestAccessService* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init];});
    return _instance;
}

@end
