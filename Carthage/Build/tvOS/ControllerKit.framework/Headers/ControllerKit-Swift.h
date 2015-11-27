// Generated by Apple Swift version 2.1 (swiftlang-700.1.101.6 clang-700.1.76)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import Foundation;
@import Dispatch;
#endif

#import <ControllerKit/ControllerKit.h>

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

SWIFT_CLASS("_TtC13ControllerKit11ButtonInput")
@interface ButtonInput : NSObject
@property (nonatomic, copy) void (^ __nullable valueChangedHandler)(float, BOOL);
@property (nonatomic, readonly) float value;
@property (nonatomic, readonly) BOOL pressed;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class Controller;
@class NSNetService;
@class NSNetServiceBrowser;
@class NSNumber;
@protocol ClientDelegate;

SWIFT_CLASS("_TtC13ControllerKit6Client")
@interface Client : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate>
@property (nonatomic, weak) id <ClientDelegate> __nullable delegate;
- (nonnull instancetype)initWithName:(NSString * __nonnull)name serviceIdentifier:(NSString * __nonnull)serviceIdentifier controllers:(NSArray<Controller *> * __nonnull)controllers OBJC_DESIGNATED_INITIALIZER;
- (void)addController:(Controller * __nonnull)controller;
- (void)removeController:(Controller * __nonnull)controller;
- (void)start;
- (void)stop;
- (void)connect:(NSNetService * __nonnull)service;
- (void)netServiceBrowser:(NSNetServiceBrowser * __nonnull)browser didFindService:(NSNetService * __nonnull)service moreComing:(BOOL)moreComing;
- (void)netServiceBrowser:(NSNetServiceBrowser * __nonnull)browser didRemoveService:(NSNetService * __nonnull)service moreComing:(BOOL)moreComing;
- (void)netServiceBrowser:(NSNetServiceBrowser * __nonnull)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> * __nonnull)errorDict;
- (void)netServiceDidResolveAddress:(NSNetService * __nonnull)sender;
- (void)netService:(NSNetService * __nonnull)sender didNotResolve:(NSDictionary<NSString *, NSNumber *> * __nonnull)errorDict;
@end

@class NSError;

SWIFT_PROTOCOL("_TtP13ControllerKit14ClientDelegate_")
@protocol ClientDelegate
- (void)client:(Client * __nonnull)client discoveredService:(NSNetService * __nonnull)service;
- (void)client:(Client * __nonnull)client lostService:(NSNetService * __nonnull)service;
- (void)client:(Client * __nonnull)client connectedToService:(NSNetService * __nonnull)service;
- (void)client:(Client * __nonnull)client disconnectedFromService:(NSNetService * __nonnull)service;
- (void)client:(Client * __nonnull)client encounteredError:(NSError * __nonnull)error;
@end

typedef SWIFT_ENUM(NSInteger, ConnectionStatus) {
  ConnectionStatusDisconnected = 0,
  ConnectionStatusConnecting = 1,
  ConnectionStatusConnected = 2,
};

@class JoystickInput;

SWIFT_CLASS("_TtC13ControllerKit10Controller")
@interface Controller : NSObject
@property (nonatomic, readonly) uint16_t index;
@property (nonatomic, readonly, copy) NSString * __nullable name;
@property (nonatomic, readonly) enum ConnectionStatus status;
@property (nonatomic, readonly, strong) JoystickInput * __nonnull dpad;
@property (nonatomic, readonly, strong) ButtonInput * __nonnull buttonA;
@property (nonatomic, readonly, strong) ButtonInput * __nonnull buttonB;
@property (nonatomic, readonly, strong) ButtonInput * __nonnull buttonX;
@property (nonatomic, readonly, strong) ButtonInput * __nonnull buttonY;
@property (nonatomic, readonly, strong) JoystickInput * __nonnull leftThumbstick;
@property (nonatomic, readonly, strong) JoystickInput * __nonnull rightThumbstick;
@property (nonatomic, readonly, strong) ButtonInput * __nonnull leftShoulder;
@property (nonatomic, readonly, strong) ButtonInput * __nonnull rightShoulder;
@property (nonatomic, readonly, strong) ButtonInput * __nonnull leftTrigger;
@property (nonatomic, readonly, strong) ButtonInput * __nonnull rightTrigger;
@end

@class GCDAsyncSocket;
@class NSData;
@protocol ControllerBrowserDelegate;

SWIFT_CLASS("_TtC13ControllerKit17ControllerBrowser")
@interface ControllerBrowser : NSObject <NSNetServiceDelegate, GCDAsyncSocketDelegate>
@property (nonatomic, readonly, copy) NSString * __nonnull name;
@property (nonatomic, readonly, copy) NSString * __nonnull serviceIdentifier;
@property (nonatomic, weak) id <ControllerBrowserDelegate> __nullable delegate;
@property (nonatomic, readonly, copy) NSArray<Controller *> * __nonnull controllers;
- (nonnull instancetype)initWithName:(NSString * __nonnull)name;
- (void)start;
- (void)stop;
- (void)netServiceDidPublish:(NSNetService * __nonnull)sender;
- (void)netService:(NSNetService * __nonnull)sender didNotPublish:(NSDictionary<NSString *, NSNumber *> * __nonnull)errorDict;
- (void)netServiceDidStop:(NSNetService * __nonnull)sender;
- (void)socket:(GCDAsyncSocket * __null_unspecified)sock didAcceptNewSocket:(GCDAsyncSocket * __null_unspecified)newSocket;
- (dispatch_queue_t __null_unspecified)newSocketQueueForConnectionFromAddress:(NSData * __null_unspecified)address onSocket:(GCDAsyncSocket * __null_unspecified)sock;
@end

enum ControllerType : NSInteger;

SWIFT_PROTOCOL("_TtP13ControllerKit25ControllerBrowserDelegate_")
@protocol ControllerBrowserDelegate
- (void)controllerBrowser:(ControllerBrowser * __nonnull)browser controllerConnected:(Controller * __nonnull)controller type:(enum ControllerType)type;
- (void)controllerBrowser:(ControllerBrowser * __nonnull)browser controllerDisconnected:(Controller * __nonnull)controller;
- (void)controllerBrowser:(ControllerBrowser * __nonnull)browser encounteredError:(NSError * __nonnull)error;
@end

typedef SWIFT_ENUM(NSInteger, ControllerType) {
  ControllerTypeMFi = 0,
  ControllerTypeHID = 1,
  ControllerTypeRemote = 2,
};


SWIFT_CLASS("_TtC13ControllerKit13JoystickInput")
@interface JoystickInput : NSObject
@property (nonatomic, copy) void (^ __nullable valueChangedHandler)(float, float);
@property (nonatomic, readonly) float xAxis;
@property (nonatomic, readonly) float yAxis;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface NSTimer (SWIFT_EXTENSION(ControllerKit))
+ (NSTimer * __nonnull)setTimeout:(NSTimeInterval)timeout repeats:(BOOL)repeats callback:(void (^ __nonnull)(void))callback;
@end

#pragma clang diagnostic pop