#import "FzxingPlugin.h"
#import <fzxing/fzxing-Swift.h>

@implementation FzxingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFzxingPlugin registerWithRegistrar:registrar];
}
@end
