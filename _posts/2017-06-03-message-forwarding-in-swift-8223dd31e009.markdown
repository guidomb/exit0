---
layout: post
title:  "Message forwarding in Swift"
date:   2017-06-03 03:00:00 -0300
categories: swift
redirect_from:
  - /message-forwarding-in-swift-8223dd31e009
---

One of the features I really liked about Ruby that is also present in Objective-C is the ability to forward messages.

In Ruby you can use the `Forwardable` module

```ruby
class LineItem
  extend Forwardable

  def_delegators :@product, :sku, :name, :description, :price

  attr_reader :product

  def initialize(product)
    @product = product
  end
end
```

In Objective-C you can do something like

```objc
- (id)negotiate {
    if ([someOtherObject respondsTo:@selector(negotiate)]) {
	      return [someOtherObject negotiate];
    } else {
    	  return self;
    }
}
```
> If you want to know more about message forwarding in Objective-C you can read [Apple’s documentation](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtForwarding.html)

This is one of those features that you rarely use but sometimes they help you avoid lots of boilerplate. In the case of Objective-C it leverages its run-time in order to dispatch messages dynamically. Something that cannot be done with pure Swift objects unless you made them inherit from `NSObject`.

Today I found myself in a situation when writing Swift code were message forwarding was a good solution to avoid some clutter and made me think about how could I accomplish something similar using pure Swift.

While working on [Portal](https://github.com/guidomb/Portal), a library that implements the [Elm’s architecture](https://guide.elm-lang.org/architecture/) in Swift, I needed to implement the following protocol.

```swift
public protocol ApplicationRenderer {

    associatedtype MessageType
    associatedtype RouteType: Route
    associatedtype NavigatorType: Equatable

    typealias ViewType = View<RouteType, MessageType, NavigatorType>
    typealias ActionType = Action<RouteType, MessageType>

    var mailbox: Mailbox<ActionType> { get }

    func render(view: ViewType, completion: @escaping () -> Void)

    func present(view: ViewType, completion: @escaping () -> Void)

    func presentModal(view: ViewType, completion: @escaping () -> Void)

    func dismissCurrentNavigator(completion: @escaping () -> Void)

    func rewindCurrentNavigator(completion: @escaping () -> Void)

}
```

The implementation that I was working on was the one responsible of rendering Portal’s view using UIKit. The conforming class is called [UIKitApplicationRenderer](https://github.com/guidomb/Portal/blob/d49495b517a78c50e4bd6eee62e9226f259d9208/Portal/UIKit/UIKitApplicationRenderer.swift). The tricky thing about implementing this protocol is that because of how UIKit works, all of its methods must be executed on the main thread. But the caller could already be running on the main thread or it may be running on a different thread.

My first attempt implementing this protocol looked something like this

```swift
func present(view: ViewType, completion: @escaping () -> Void) {
    	DispatchQueue.main.async {
	// code that presented the view
	}
}
```

The first thing that I wanted to change was to avoid dispatching work to the main dispatch queue if the method was already being called on the main thread. So I added the following helper method

```swift
fileprivate extension UIKitApplicationRenderer {

    fileprivate func executeInMainThread(_ code: @escaping @escaping () -> Void) {
        if Thread.isMainThread {
            code()
        } else {
            DispatchQueue.main.async { code() }
        }
    }

}
```

Then I made every method from the protocol call `executeInMainThread` . Every method looked something like

```swift
func present(view: ViewType, completion: @escaping () -> Void) {
    	executeInMainThread {
	// code that presented the view
	}
}
```

I could have call it a day and move to the next task. But I didn’t like how the code looked like. By having to use a closure to implement the actual logic on each method I was using self all over the place. I didn’t like that. That is when I thought that it would be nice to be able to forward methods.

What I ended up doing was creating a new class, [MainThreadUIKitApplicationRenderer](https://github.com/guidomb/Portal/blob/d49495b517a78c50e4bd6eee62e9226f259d9208/Portal/UIKit/UIKitApplicationRenderer.swift#L112) that implemented the `ApplicationRenderer` protocol assuming that all of its method will be called on the main thread.

The next thing was updating `executeInMainThread` to make it simpler to pass a block of code to execute that would only contain one method call by making the closure parameter `@autoclosure`. This would have the benefit of avoiding to have to wrap each method invocation with a closure.
> If you want to know more about ``@autoclosure` and some cool ways of using it, check [this](https://www.swiftbysundell.com/posts/using-autoclosure-when-designing-swift-apis) blog post.

Finally all I needed to do was to add a forwardee property in UKitApplicationRenderer that would hold a reference to an object of type `MainThreadUIKitApplicationRenderer` to which all methods would be forwarded after making sure that the method invocation would be executed on the main thread. `UIKitApplicationRenderer` ended up looking something like

```swift
public func render(view: ViewType, completion: @escaping () -> Void) {
    executeInMainThread(self.forwardee.render(view: view, completion: completion))
}

public func present(view: ViewType, completion: @escaping () -> Void) {
    executeInMainThread(self.forwardee.present(view: view, completion: completion))
}

public func presentModal(view: ViewType, completion: @escaping () -> Void) {
    executeInMainThread(self.forwardee.presentModal(view: view, completion: completion))
}

public func dismissCurrentNavigator(completion: @escaping () -> Void) {
    executeInMainThread(self.forwardee.dismissCurrentNavigator(completion: completion))
}

public func rewindCurrentNavigator(completion: @escaping () -> Void) {
    executeInMainThread(self.forwardee.rewindCurrentNavigator(completion: completion))
}
```

Which I think reads better. Obviously compared to Objective-C or Ruby you still have to manually forward each method but that is something that may be solved by using some meta-programming with [Sourcery](https://github.com/krzysztofzablocki/Sourcery). I imagine that such solution would require defining a `Forwardable` protocol that could look something like

```swift
protocol Forwardable {

	associatedtype ForwardeeType

	var forwardee: ForwardeeType { get }

}
```

Then Sourcery could check all classes that conform to Forwardable and by using [Sourcery source annotations](https://cdn.rawgit.com/krzysztofzablocki/Sourcery/master/docs/writing-templates.html) you could tell it which is the protocol that you want to conform to and Sourcery could then generate an extension with all the boilerplate necessary to forward each method. I leave that as an exercise for the reader.
> There is a similar example in Sourcery documentation to implement decorators using metaprogramming. Check the example [here](https://cdn.rawgit.com/krzysztofzablocki/Sourcery/master/docs/decorator.html).

Do you find this useful? Did you find yourself in a similar situation? What did you do then? Let me know by dropping a comment.
