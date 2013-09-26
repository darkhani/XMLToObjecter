//
//  AppDelegate.m
//  XMLToObjecter
//
//  Created by 한인택 on 13. 9. 25..
//  Copyright (c) 2013년 tegine. All rights reserved.
//
// Myname is Intaek, Han. [KOREAN MAN]

#define ADDRESS @"http://openAPI.seoul.go.kr:8088/4150495f3230383364616e647968616e69/xml/GeoInfoShelterWGS/1/5/1"

#import "AppDelegate.h"
#import "FileLoader.h"

//Lib
#import "XMLReader.h"

#import <Quartz/Quartz.h>
@implementation AppDelegate
@synthesize kLabel;
@synthesize kCopyTF,kOrgTF,kURLTF;
//@synthesize kAboutWindow;

#pragma mark - applicationDidFinishLaunching Management - Start Point

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    keyArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSLog(@"Here??");
    kOrgTF.delegate = self;
    kCopyTF.delegate = self;
    [kOrgTF setTextColor:[NSColor blueColor]];
    kURLTF.delegate = self;
    
    [self initialFileLoader];
    
}

#pragma mark - IBAction Management
- (IBAction)kWhatIsThisMenu:(id)sender {
    NSLog(@"MenuClick!");
//     [self.window.contentView addSubview:kAboutWindow];
}

- (IBAction)kXmlToJsonButtonClick:(id)sender {
   NSString *str = [self XmlToJsonLogic];
    [kCopyTF setStringValue:str];
    [kCopyTF setTextColor:[NSColor redColor]];
}

- (IBAction)kXmlToXcodeObjButtonClick:(id)sender {
    NSString *str = [self XmlToXcodeObjectLogic];
    [kCopyTF setStringValue:str];
    [kCopyTF setTextColor:[NSColor orangeColor]];
}


- (IBAction)kPassButtonClick:(id)sender {
    [kCopyTF setStringValue:[kOrgTF stringValue]];
    [kCopyTF setTextColor:[NSColor blackColor]];
}
- (IBAction)kURLGetButtonClick:(id)sender {
    [self requestLogic];
}

- (IBAction)kHfileToClipButtonClick:(id)sender {
    [self copyToClipboard:hFileString];
}

- (IBAction)kMfileToClipButtonClick:(id)sender {
    [self copyToClipboard:mFileString];
}

#pragma mark - TextField delegate Method Management

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    NSLog(@"should end editing....");
    [self kPassButtonClick:nil];
}

//- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
//{
//    BOOL result = NO;
//    
//    if (commandSelector == @selector(insertNewline:))
//    {
//        // new line action:
//        // always insert a line-break character and don’t cause the receiver to end editing
//        [textView insertNewlineIgnoringFieldEditor:self];
//        result = YES;
//    }
//    else if (commandSelector == @selector(insertTab:))
//    {
//        // tab action:
//        // always insert a tab character and don’t cause the receiver to end editing
//        [textView insertTabIgnoringFieldEditor:self];
//        result = YES;
//    }
//    
//    return result;
//}

#pragma mark - Custom Method - FOR URL, REQuest Management

- (void) requestLogic {
    NSString *reqString;
    NSString *retValue;
    
    if ([keyArr count] > 0){
        [keyArr removeAllObjects];
    }
    
    reqString = [kURLTF stringValue];

    if ([reqString isEqual:@""]){
        reqString = ADDRESS;
        [kURLTF setStringValue:ADDRESS];
    }
//    [[self window].contentView setLayer:[CALayer new]];
//    [[self window].contentView setWantsLayer:YES];     // the order of setLayer and setWantsLayer is crucial!
  
    
    retValue = [self stringWithUrl:[NSURL URLWithString:reqString]];
    
    [kOrgTF setStringValue:retValue];
    
}
- (NSString *)stringWithUrl:(NSURL *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a String around the Data from the response
    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

#pragma mark - Custom Method Management

-(void)copyToClipboard:(NSString*)str
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray     arrayWithObjects:NSStringPboardType, nil];
    [pb declareTypes:types owner:self];
    [pb setString:str forType:NSStringPboardType];
}

- (NSString*)createHeaderFile:(NSMutableArray*)arr{
    NSString *retString;
    retString = [NSString stringWithFormat:@"%@",@"//.h file from XML\n"];
    retString = [NSString stringWithFormat:@"%@%@",retString,@"//Copyright (c) 20xx Your Company. All rights reserved.\n\n"];
    retString = [NSString stringWithFormat:@"%@%@",retString,@"#import <Cocoa/Cocoa.h>//For Mac\n"];
    retString = [NSString stringWithFormat:@"%@%@",retString,@"//#import <Foundation/Foundation.h>//For iOS\n\n"];
    retString = [NSString stringWithFormat:@"%@%@",retString,@"@interface DataValueObject : NSObject \n\n"];

    for (NSString *str in arr) {
        
        NSString *capitalisedSentence = [str stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                withString:[[str  substringToIndex:1] capitalizedString]];
        
       retString = [NSString stringWithFormat:@"%@%@\n",retString,[NSString stringWithFormat:@"@property (nonatomic, retain) NSString *k%@;",capitalisedSentence]];
    }
    
    /* Here is!!!
     - (id) initWithData:(NSMutableArray*)data;
     - (id) initWithCoder: (NSCoder *)coder;
     - (void) encodeWithCoder: (NSCoder *)coder;
     
     */
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\n - (id) initWithData:(NSMutableArray*)data;\n- (id) initWithCoder: (NSCoder *)coder;\n- (void) encodeWithCoder: (NSCoder *)coder;"];
    
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\n@end"];
    return retString;
}

- (NSString*)createMFile:(NSMutableArray*)arr{
    NSString *retString;
    retString = [NSString stringWithFormat:@"%@",@"//.m file from XML\n"];
    retString = [NSString stringWithFormat:@"%@%@",retString,@"//Copyright (c) 20xx Your Company. All rights reserved.\n\n"];
    retString = [NSString stringWithFormat:@"%@%@",retString,@"@implementation DataValueObject\n\n\n"];
    
    // make @synthesize part
    
    for (NSString *str in arr) {
        
        NSString *capitalisedSentence = [str stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                     withString:[[str  substringToIndex:1] capitalizedString]];
        
        retString = [NSString stringWithFormat:@"%@%@\n",retString,[NSString stringWithFormat:@"@synthesize k%@;",capitalisedSentence]];
    }
    
    // make initWith ... logic here.
    /*- (id) initWithData:(NSMutableArray*)data{
     self = [super init];
     if (self != nil){
     [self createOBJ:data];
     }
     return self;
     }*/
    
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\n\n- (id) initWithData:(NSMutableArray*)data\n{\n\tself = [super init];\n\tif (self != nil){\n\t\t[self createOBJ:data];\n\t}\n\treturn self;\n}\n  "];
   
    /* HERE is!!!
    - (void) createOBJ:(NSMutableArray*)arr{
        
        self.kCreateStaffCode = [arr objectAtIndex:0];
        self.kCreateStaffName = [arr objectAtIndex:1];
        self.kUpdateStaffCode = [arr objectAtIndex:2];
    }
    */
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\n\n- (void) createOBJ:(NSMutableArray*)arr\n{\n"];
    int idx=0;
    for (NSString *str in arr) {
        
        NSString *capitalisedSentence = [str stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                     withString:[[str  substringToIndex:1] capitalizedString]];
        
        retString = [NSString stringWithFormat:@"%@%@\n",retString,[NSString stringWithFormat:@"\tself.k%@ = [arr objectAtIndex:%d];",capitalisedSentence,idx]];
        idx++;
    }
    retString = [NSString stringWithFormat:@"%@%@",retString,@"}\n"];
    
    /* HERE is This!!!
     - (id) initWithCoder: (NSCoder *)coder {
     if (self = [super init]) {
     self.kCreateStaffCode = [coder decodeObjectForKey:@"kCreateStaffCode"];
     self.kCreateStaffName = [coder decodeObjectForKey:@"kCreateStaffName"];
     self.kUpdateStaffCode = [coder decodeObjectForKey:@"kUpdateStaffCode"];
     
     }
     return self;
     }*/
    
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\n\n- (id) initWithCoder: (NSCoder *)coder \n{\n\tif (self = [super init]) {\n"];
    
    for (NSString *str in arr) {
        
        NSString *capitalisedSentence = [str stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                     withString:[[str  substringToIndex:1] capitalizedString]];
        
        retString = [NSString stringWithFormat:@"%@%@\n",retString,[NSString stringWithFormat:@"\t\tself.k%@ = [coder decodeObjectForKey:@\"%@\"];",capitalisedSentence,capitalisedSentence]];
    }
    
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\t}\n\treturn self;\n}\n"];
    
    
    /*
     - (void) encodeWithCoder: (NSCoder *)coder {
     
     [coder encodeObject:self.kCreateStaffCode forKey:@"kCreateStaffCode"];
     [coder encodeObject:self.kCreateStaffName forKey:@"kCreateStaffName"];
     [coder encodeObject:self.kUpdateStaffCode forKey:@"kUpdateStaffCode"];
     }
     */
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\n\n- (void) encodeWithCoder: (NSCoder *)coder\n{\n"];
    
    for (NSString *str in arr) {
        
        NSString *capitalisedSentence = [str stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                     withString:[[str  substringToIndex:1] capitalizedString]];
        
        retString = [NSString stringWithFormat:@"%@%@\n",retString,[NSString stringWithFormat:@"\t[coder encodeObject:self.k%@ forKey:@\"%@\"];",capitalisedSentence,capitalisedSentence]];
    }
    
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\n}\n@end"];
    return retString;
}

- (NSString*) XmlToXcodeObjectLogic{
    NSMutableDictionary *dic;
    NSError *error;
    NSData *retJsonData;
    NSString *retString;
    
//    NSString *hFileString;
//    NSString *mFileString;
    
    if (![kOrgTF.stringValue isEqualToString:@""]){
        dic = (NSMutableDictionary*)[XMLReader dictionaryForXMLString:kOrgTF.stringValue error:&error];
        dic = [self extractXML:dic];
        retJsonData = [self getJsonDataFromNSDic:dic];
    }
    
    // Remove duplicated item in Key Array.
    
    
    NSMutableArray *kFilterArr = [NSMutableArray array];
    
    for (id obj in keyArr) {
        if (![kFilterArr containsObject:obj]) {
            [kFilterArr addObject:obj];
        }
    }
    
    
    NSLog(@"new key exclude duplicated : %@",kFilterArr);

    
    hFileString = [self createHeaderFile:kFilterArr];
    mFileString = [self createMFile:kFilterArr];
    
    retString = [NSString stringWithFormat:@"%@",hFileString];
    retString = [NSString stringWithFormat:@"%@%@",retString,@"\n\n ======================================== \n\n"];
    retString = [NSString stringWithFormat:@"%@\n%@",retString,mFileString];
    
    return retString;
}
- (NSString*) XmlToJsonLogic {
    
    NSMutableDictionary *dic;
    NSError *error;
    NSString *retJsonString;
    
    if (![kOrgTF.stringValue isEqualToString:@""]){
        dic = (NSMutableDictionary*)[XMLReader dictionaryForXMLString:kOrgTF.stringValue error:&error];
        dic = [self extractXML:dic];
        retJsonString = [self getJsonFromNSDic:dic];
    }else{
        retJsonString = @"{} or nil;";
    }
    return retJsonString;
}

- (NSMutableDictionary *)extractXML:(NSMutableDictionary *)XMLDictionary
{
    for (NSString *key in [XMLDictionary allKeys]) {
        // get the current object for this key
        id object = [XMLDictionary objectForKey:key];
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            if ([[object allKeys] count] == 1 &&
                [[[object allKeys] objectAtIndex:0] isEqualToString:@"text"] &&
                ![[object objectForKey:@"text"] isKindOfClass:[NSDictionary class]]) {
                // this means the object has the key "text" and has no node
                // or array (for multiple values) attached to it.
                [XMLDictionary setObject:[object objectForKey:@"text"] forKey:key];
                [keyArr addObject:key];
            }
            else {
                // go deeper
                [self extractXML:object];
            }
        }
        else if ([object isKindOfClass:[NSArray class]]) {
            // this is an array of dictionaries, iterate
            for (id inArrayObject in (NSArray *)object) {
                if ([inArrayObject isKindOfClass:[NSDictionary class]]) {
                    // if this is a dictionary, go deeper
                    [self extractXML:inArrayObject];
                }
            }
        }
    }
    
    return XMLDictionary;
}

- (NSData*)getJsonDataFromNSDic:(NSDictionary*)dic{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        [kCopyTF setStringValue:@"Get Data is not right XML file... please check the data of my left."];
    } else {
        return jsonData;
    }
    return jsonData;
}

- (NSString*)getJsonFromNSDic:(NSDictionary*)dic{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        [kCopyTF setStringValue:@"Get Data is not right XML file... please check the data of my left."];
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return @"";
}

- (void)initialFileLoader{
    //File Open
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xmlSample" ofType:@"xml"];
    NSString *kContents = [FileLoader fileOpen:path];
//    NSString *kContents = @"1. Enter URL and push the GET or 2. Copy & paste XML Here";
    [kOrgTF setStringValue:kContents];
}

- (void)displayString:(NSString *)title {
    [kOrgTF setStringValue:title];
    [kOrgTF setTextColor:[NSColor blueColor]];
    [[_window contentView] addSubview:kOrgTF];
}

-(NSSize)intrinsicContentSize
{
    
    NSRect frame = [kCopyTF.cell frame];
    
    CGFloat width = frame.size.width;
    
    // Make the frame very high, while keeping the width
    frame.size.height = CGFLOAT_MAX;
    
    // Calculate new height within the frame
    // with practically infinite height.
    CGFloat height = [kCopyTF.cell cellSizeForBounds: frame].height;
    
    return NSMakeSize(width, height);
}


@end
