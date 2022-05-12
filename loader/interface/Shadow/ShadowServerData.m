#import "ShadowServerData.h"

@implementation ShadowServerData
+(NSDictionary *)dictionaryForURL:(NSURL *)url{
    NSData *data = [NSData dataWithContentsOfURL: url];
    if (data == nil) return @{};
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}
+(void)send:(id)data to:(NSString*)url{
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];//NSJSONWritingPrettyPrinted
    if(postData){
        NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSOperationQueue *queue = [NSOperationQueue mainQueue];//[[NSOperationQueue alloc] init];
        
        [request setHTTPMethod:@"POST"];
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        //[request setValue:@"no-tunnel" forHTTPHeaderField:@"Bypass-Tunnel-Reminder"];
        
        [request setHTTPBody:postData];
        
        /*
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        if([responseCode statusCode] != 200){
            NSLog(@"There was an error somewhere, but there should be a response to the server.");
        }
        */
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
          if (error) {
              NSLog(@"There was an error sending data to the server");
          }else{
              NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
          }
        }];
        
    }else{
        NSLog(@"COULD NOT SERIALIZE PROVIDED OBJECT");
    }
    
    
    

}
@end
