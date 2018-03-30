---
layout: post
title:  "Usage Driven Development"
date:   2017-04-13 03:00:00 -0300
categories:
redirect_from:
  - /usage-driven-development-a25cc5c50cd0
---

## A brief story of the tools I wish I had

Recently at [Wolox](http://wolox.co) I’ve been working on a Swift library to help us develop applications more rapidly but also having a solid architecture that produces maintainable code. You’ll probably hear more about this in a future post.

Like most software projects, this one started as a rough idea that was rambling inside my head for a long time which eventually manifested as a prototype developed over a weekend. After a couple of days hacking, I had a first version of the library that was able to demonstrate its potential and kind of worked for basic iOS applications. So I decided to start refactoring the code, clean it up and start adding missing core features.

Soon I realized that I was starting to build a relatively complex code base that I knew would have to go over several iterations and refactor cycles until the APIs were polished enough to be able to be used by the widely range of application we build for our clients at Wolox. Although I was able to move fast and add feature after feature, I started to fear that I would hit a wall because I was (and still am) not writing any tests (yet).

Being a guy who always preached about [TDD](https://en.wikipedia.org/wiki/Test-driven_development) and [BDD](https://en.wikipedia.org/wiki/Behavior-driven_development), this was a big issue for me. But I’ve also learned the hard way about committing too early to writing tests for rapidly-changing and unstable code. Tests are also code that has to be maintained and when you are designing a new API that works for you but that also needs to work for a variety of other cases that you cannot even imagine, the maintenance burden can slow you down really hard. That is why I decided that I was going to commit on testing after I was confident that the APIs were stable enough and no mayor changes were going to be needed in the foreseeable future.

Strong BDD advocates would tell me that I am crazy. That I should be driving the design of my API by writing test that would make me discover how those APIs should look like. Although I agree with such approach, I found that discovering the library’s API was much more effective by writing a real application. Just start working on a new app and write the interface you wish you had and then implement it. My [red-green-refactor](http://blog.cleancoder.com/uncle-bob/2014/12/17/TheCyclesOfTDD.html) cycle became:

1. Scaffold the new app feature, discover the API by watching all the compiler errors for types or function that don’t exist yet.

1. Implement those missing types or functions and make the project compile.

1. Once the feature is working see if you can refactor the code, generalize it or clean it. Make sure that the feature is still working.

Applying this same approach in dynamic languages like Javascript or Ruby can be way harder and BDD in those language make more sense. You have to compensate not having a type-system and a compiler that tells you what you have broken after a refactor cycle. This is not the case for Swift. Sure, there are invariants that cannot be expressed in the type-system but in my experience so far those cases can be easily spotted by running the application and doing a quick check.

I know that once the code base reaches certain size and complexity this approach will no longer be valid but it helped me move faster at the beginning. That is why I am preparing for the next phase and the reason I am writing this blog post. Once I decide that the APIs are stable enough and more people starts depending on my library I need to start having strong code coverage, at least for the most important pieces and execution paths. This is were I would like to have better support from my tooling.

The following are a couple of tools I wish I had

A text editor / IDE plugin or chat bot that tells you which pieces should be tested, ordered from the highest to lowest priority. The priority is calculated based on the **source file churn** combined with **runtime execution information** of which code paths or functions are executed more often.
> Runtime information might be hard to collect without having significant performance impact. Maybe by instrumenting LLVM byte code by inserting functions call to a stats collector library every time there is a code jump or an execution branch, e.g., function calls, function returns, if statements. I am not sure if LLVM exposes a plugin mechanism that would make such extension relatively easy to implement

Files with low churn that contain code that is executed more frequently means such code is stable and probably critical or that atleast is shared by most feature flows.

Files with high churn that contain code that is executed more frequently in (*in development builds*) means such code is actively being worked on and there for it might be wiser to test it once the API has been stabilized and the use case validated.

Crash reports is another good source of information to take into account and decide where and when we should put our attention.

It is extremely important that in order for such tool to be useful it must be integrated with your IDE and **it should provide information in real time or when the user decides to “augment” her editing experience**. Contextual information could be provided by the IDE’s UI when the user holds the course after a couple of seconds over a block of code. More frequent execution paths would be highlighted with a stronger color (by changing highlighted area alpha’s property) than less frequent ones. Execution paths that contain lines that are part of a crash report’s stack frame can be highlighted in red.

If the application is using an architecture like the [Elm’s architecture](https://guide.elm-lang.org/architecture/) or something like [Redux](http://redux.js.org/) then when a crash is detected the current state and the last *n* messages are attached to the crash report. The execution path that processes the messages and the state that generated the crash are highlighted by the IDE in real time when the crash occurs or when the user decides to debug a specific crash report.

Going one step further, each message that is processed by the application’s update function could be sent to a cloud service that processes the message in order to analyze and gather metrics from the code execution path. This provides real time runtime execution information without affecting performance and consuming user’s CPU because replicating the message is off-loaded to a background queue and the actual cost of instrumentation is paid by the backend server. This strategy increases data consumption and surely there are a lot of things that I haven’t though but should be technically possible now that Swift can run on Linux.

If someone wants to work in something like this or if such tools already exist please let me know. In the mean time I think I’ll have to settle with intuition and some basic code coverage reporting.

I think that a lot can be done by making developers more productive. People think that in a near feature AI would take over developers jobs and machines will start writing code by themselves. I think such future is still pretty far away. What I do think is that the progress in computing power and AI could be used to develop better and smarter tooling which provides contextual real time information to help developers make better decision. What do you think?
