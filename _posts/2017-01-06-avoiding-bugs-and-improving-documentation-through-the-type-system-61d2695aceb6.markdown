---
layout: post
title:  "Avoiding bugs and improving documentation through the type system"
date:   2017-01-06 03:00:00 -0300
categories: swift
redirect_from:
  - /avoiding-bugs-and-improving-documentation-through-the-type-system-61d2695aceb6
---

*Always try to reduce functions and methods domain. Improve documentation by using narrower types which enforce pre-conditions. Give the compiler more information. Watch [this](https://www.youtube.com/watch?v=DU7Je1rdXk0) video.*

Today I was reviewing a pull request and I found the following piece of code that was added

```swift
public final class UserSessionService {

	public init(withTimeout timeout: NSTimeInterval) {
		// Initialization logic
	}

}
```

Although the code was working fine and followed all of our best practices I felt that there was something there that could still be improved. The first thing that triggered this thought was actually a “cosmetic” issue. I thought, what if the parameter’s label, instead of being **withTimeout** is changed to with. That change would imply that creating a new instance of **UserSerssionService** would change from

```swift
let userSessionService = UserSessionService(withTimeout: 10)
```

to

```swift
let userSessionService = UserSessionService(with: 10)
```

Clearly not a good idea. Although it is less verbose, it makes understanding what is actually happening way harder. What does it mean to create a user session service **“with 10”**. The original solution at least clarifies that the given number is a timeout. It reads as, “create a user session service with timeout 10”. But the problem with it is that is not much clearer than that. A timeout for what? My next thought was to suggest changing the initializer to

```swift
public init(withRequestTimeout requestTimeout: NSTimeInterval)
```

Which clarifies that timeout is related to the requests this service makes. **UserSessionService** exposes methods to login and sign up. The thing with this solution is that it’s worse than the original one regarding the length of the label. Obviously not a big deal, but this is what was bothering me in the first place.

If you read [Swift’s API design guidelines](https://swift.org/documentation/api-design-guidelines/#naming) didn’t help much either. Except from some tips like
> func move(from start: Point, to end: Point)
> Choose parameter names to serve documentation. Even though parameter names do not appear at a function or method’s point of use, they play an important explanatory role.

and
> func move(from start: Point, to end: Point)

I realized that the problem was actually with type of the parameter, **requestTimeout**. If the type had a more descriptive name the method signature could read better and be less verbose. For example

```swift
typealias RequestTimeout = NSTimeInterval

/// Return a `UserSessionRepository` that limits login and sign up
/// requests to the given `requestTimeout`.
public init(with requestTimeout: RequestTimeout)
```

This “felt” better but it had the same issue as not being clear enough when used. Which led me to change the type alias to a concrete type.

```swift
struct RequestTimeout {

	let value: NSTimeInterval

	init(_ value: NSTimeInterval) {
		self.value = value
	}

}

public final class UserSessionService {

	public init(with timeout: RequestTimeout) {
		// initialization logic
	}

}
```

Which implies the following change when creating a new user session service

```swift
let userSessionService = UserSessionService(with: RequestTimeout(10))
```

Although the amount of “verbosity” remains almost the same, this solution felt superior. I’ve realized that by introducing a type I was improving readability and documentation and also making sure that whoever created a new instance of **UserSessionService** got a compiler error if the appropriate type wasn’t used. Having a more “narrower” type helps you catch error earlier. For example when a parameter is not a literal value in the code but something that is passed to you. Sure, in this case you could create a **RequestTimeout** with any given **NSTimeInterval** (which is just a type alias to Double). But having to do that explicitly makes you think twice about what you are doing and makes it more clear in code reviews in order for reviewers to double check if the type promotion is correct.

It didn’t end there. Then I thought, “wait, I can create a **RequestTimeout** given any number, clearly -45.345 is not a valid **RequestTimeout**”. The easiest way to solve this is by using [fail-able initializers](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html).

```swift
struct RequestTimeout {

	let value: Double

	init?(_ value: Double) {
		guard value > 0 else { return nil }

		self.value = value
	}

}
```

Now we need to safely unwrap the option.

```swift
if let requestTimeout = RequestTimeout(10) {
  let userSessionService = UserSessionService(with: requestTimeout)
}
```

Depending on how you are creating the **RequestTimeout** object and where that initialization takes place, using *if-let* syntax may not be necessary. For example, lets say to you only need to create the user session service once and you do it in the application’s delegate.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

  let userSessionService = UserSessionService(with: RequestTimeout(10)!)

  // The rest of the UIApplicationDelegate methods

}
```

In such case I think that explicitly unwrapping the **RequestTimeout** value is OK because worst case scenario you’ll get a crash the moment you open the application. If you have at least one test, that error will get caught really early. Not as good as a compiler error but good enough.

I was about to move on but I decided to show all this to my co-workers to get their opinion. All of them agreed with this but one pointed out that it could be improved a little bit by communicating the time unit used for the request timeout. Because **RequestTimeout(10)** does not saying anything about whether the request timeout is in minutes, seconds, milliseconds or whatever. Because the request timeout is in seconds I changed the its initializer to

```swift
struct RequestTimeout {

	let value: Double

	init?(seconds value: Double) {
		guard value > 0 else { return nil }

		self.value = value
	}

}
```

which reads like

```swift
if let requestTimeout = RequestTimeout(seconds: 10) {
  let userSessionService = UserSessionService(with: requestTimeout)
}
```

### Conclusion

I think that providing documentation through the type system is the best way of designing code. Being able to empower the compiler by giving it more information helps you catch future bugs. I came to this conclusion by trying to improve a minor style issue which as a matter of fact it was pretty subjective (an probably only fueled by my [OCD](https://en.wikipedia.org/wiki/Obsessive%E2%80%93compulsive_disorder) with code). That led to further challenging my assumptions and the end result was better code.

After all this review process and once I had the solution I felt comfortable with, I decided to look about this on the internet and found the following video explaining this same concept from [Chris Eidhof](twitter.com/chriseidhof) and [Florian Kugler](https://twitter.com/floriankugler).

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/DU7Je1rdXk0" frameborder="0" allowfullscreen></iframe></center>

Also found this Twitter thread by [Ole Begemann](https://twitter.com/olebegemann)


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">The same goes for other quantities. Your animation API has a duration parameter? Don’t use TimeInterval, use Measurement&lt;UnitDuration&gt;.</p>&mdash; Ole Begemann (@olebegemann) <a href="https://twitter.com/olebegemann/status/816312282560995328?ref_src=twsrc%5Etfw">January 3, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


and a his [blog post](https://oleb.net/blog/2016/07/measurements-and-units/) about the Foundation’s Measurement type.
