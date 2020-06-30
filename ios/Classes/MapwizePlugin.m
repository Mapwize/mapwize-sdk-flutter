#import "MapwizePlugin.h"
#if __has_include(<Mapwize/Mapwize-Swift.h>)
#import <Mapwize/Mapwize-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "Mapwize-Swift.h"
#endif

@implementation MapwizePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMapwizePlugin registerWithRegistrar:registrar];
}
@end
