//
//  AFGoogleAPIClient.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "AFGoogleAPIClient.h"
#import "CommonHeaderFile.h"
#import "ImageRecord.h"

// https://www.googleapis.com/customsearch/v1?q=laura&key=&cx=&searchtype=image
static NSString * const kAFGoogleAPIBaseURLString = @"https://www.googleapis.com";

//static NSString * const kAFGoogleAPIBaseURLString = @"https://www.google.com/search?tbm=isch&q=%@";



#warning Add your own Google API key and Google Custom Search Engine ID here first
static NSString * const kAFGoogleAPIKeyString = @"AIzaSyDs2ECIAsEK1y658ZpdG8ZPFjNjc_ZZUXU";
static NSString * const kAFGoogleAPIEngineIDString = @"AIzaSyBSSl1K4ykOJQmNnFH4oYWNA0AeK8ayLqw";

// https://www.googleapis.com/customsearch/v1?key=AIzaSyC5Mf_LqMqcMwiLAlgx3EG7VJ_FjKU_9GM&cx=014852980787483500975:in98jqthluy&searchType=image&fileType=jpg&alt=json&q=water


@implementation AFGoogleAPIClient

+ (NSString *)title
{
    return @"Google Images";
}

+ (AFGoogleAPIClient *)sharedClient
{
    static AFGoogleAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFGoogleAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFGoogleAPIBaseURLString]];
    });

    return _sharedClient;
}

- (void)findImagesForQuery:(NSString *)query withOffset:(int)offset success:(ISSuccessBlock)success failure:(ISFailureBlock)failure
{
    NSDictionary *parameterDict = @{
        @"key": kAFGoogleAPIKeyString,
        @"cx": kAFGoogleAPIEngineIDString,
        @"searchtype": @"image",
        @"fields" : @ "items",
        @"start": [@(offset + 1) stringValue],
        @"q": query
    };
    
   // https://www.googleapis.com/customsearch/v1?q=love&key=&cx=&searchtype=image
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    int startIndex;
    //startIndex = 0;
    startIndex =[[userD objectForKey:kGoogleInageStartIndex] intValue];
    
    NSString *originalSearchStr = query;
    NSString *encodeString = [originalSearchStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *restUrl = [NSString stringWithFormat:@"customsearch/v1?key=%@&cx=014852980787483500975:in98jqthluy&searchType=image&fileType=jpg&alt=json&q=%@&start=%d",kAFGoogleAPIKeyString,encodeString,startIndex];
    [[AFGoogleAPIClient sharedClient] GET:restUrl parameters:nil
        success:^(NSURLSessionDataTask *dataTask, id responseObject) {
            if ([responseObject objectForKey:@"items"] == [NSNull null]) {
                return;
            }
            
            NSArray *jsonObjects = [responseObject objectForKey:@"items"];
            NSLog(@"jsonObjects>>>>%@",jsonObjects);
            NSLog(@"Found %lu objects...", (unsigned long)[jsonObjects count]);
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:jsonObjects.count];
            for (NSDictionary *jsonDict in jsonObjects) {
                ImageRecord *imageRecord = [[ImageRecord alloc] init];
                
                imageRecord.title = [jsonDict objectForKey:@"title"];
                imageRecord.details = [jsonDict objectForKey:@"displayLink"];

               // imageRecord.thumbnailURL = [NSURL URLWithString:[(NSArray *)[jsonDict valueForKeyPath:@"pagemap.cse_thumbnail.src"] firstObject]];
                

                //imageRecord.imageURL = [NSURL URLWithString:[(NSArray *)[jsonDict valueForKeyPath:@"pagemap.cse_image.src"] firstObject]];
                
                imageRecord.thumbnailURL = [NSURL URLWithString: [[jsonDict objectForKey:@"image"] valueForKey:@"thumbnailLink"]];
                
               // imageRecord.thumbnailSize = CGSizeMake([[[jsonDict objectForKey:@"image"] valueForKey:@"thumbnailWidth"] floatValue],[[[jsonDict objectForKey:@"image"] valueForKey:@"thumbnailHeight"] floatValue]);
                
                
                imageRecord.imageURL = [NSURL URLWithString: [jsonDict objectForKey:@"link"]];
                [imageArray addObject:imageRecord];
            }
            NSLog(@"image-Array----%@",imageArray);
            success(dataTask, imageArray);
        } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
            failure(dataTask, error);
        }];
    
}

@end
