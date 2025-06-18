#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "splash-fallback" asset catalog image resource.
static NSString * const ACImageNameSplashFallback AC_SWIFT_PRIVATE = @"splash-fallback";

/// The "splash-fallback 1" asset catalog image resource.
static NSString * const ACImageNameSplashFallback1 AC_SWIFT_PRIVATE = @"splash-fallback 1";

#undef AC_SWIFT_PRIVATE
