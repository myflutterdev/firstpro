#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@interface AppDelegate ()
@property (nonatomic, strong) FlutterViewController *fvc;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    FlutterViewController *rvc = (FlutterViewController *)self.window.rootViewController;
    _fvc = rvc;
    UINavigationController *naviTest = [[UINavigationController alloc] initWithRootViewController:rvc];
    naviTest.navigationBarHidden = YES;
    self.window.rootViewController = naviTest;
    [self handleChannelComeWithFlutter];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)handleChannelComeWithFlutter {
    FlutterMethodChannel *channelJump = [FlutterMethodChannel methodChannelWithName:@"test.flutter.io/jump" binaryMessenger:_fvc];
    __weak AppDelegate *ws = self;
    [channelJump setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SEL method = NSSelectorFromString(call.method);
            if ([ws respondsToSelector:method]) {
                id ret = [ws performSelector:method withObject:call.arguments];
                result(ret);
            }
        });
        // [ws.fvc popRoute];
    }];
    
}

- (id)jumpFromFlutter:(id)params {
    sleep(4);
    return @{@"tk" : @"tv"};
}


@end
