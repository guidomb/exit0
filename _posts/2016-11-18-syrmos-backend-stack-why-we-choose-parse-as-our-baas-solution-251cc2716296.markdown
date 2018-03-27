---
layout: post
title:  "Syrmo’s backend stack: Why we choose Parse as our BaaS solution?"
date:   2016-11-18 03:00:00 -0300
categories: syrmo
redirect_from:
  - /syrmos-backend-stack-why-we-choose-parse-as-our-baas-solution-251cc2716296
---

*This is the first post of the series about the technology behind Syrmo. The choices we made, the good, the bad and the ugly.*

### tl; dr

*Parse is a really good solution for prototyping and getting an MVP quickly into the market. It has an active community behind it and it is well documented. It serves well as a CRUD application with authentication and authorization out of the box. It has nice SDKs for iOS, Android and Javascript. It is really easy to deploy and the mayor IaaS and PaaS providers have support for it.*

*If you have a small team, tight deadlines and an application that does not require backend business logic. Parse is a really good option.If you do have some backend business logic you can use AWS Lambda.*

*Parse + AWS Lambda = 💙 💚 💛*

### A little bit of background

When we started working on [Syrmo](http://syrmo.com), a performance tracker for skateboarders, we didn’t start working on the end user iOS app first. There were a lot of unknowns and technical problems that we needed to solve before we can design how the end user experience will be like using Syrmo’s mobile app. Things like:

* How the Bluetooth LE protocol works and if it was well suited for our particular use case.

* Validate that the sensors we were planning to use were accurate enough to gather the date we needed in order to be a able infer different metrics about a skateboard trick.

* Learn about 3D rending technology and choose a cross-platform stack that will let us generate 3D animated replay of each skateboard trick based on the data recorded using our tracking device.

* Develop a set of high-performant algorithms that will run on the tracking device and could detect when a user performed a skateboard trick discarding “noise” data.

Of course, as any other bootstrapping startup out there, we needed to figure out all this with an under staffed team, in the least amount of time and spending as few money as possible. Working on the backend was (and still is) really down in the list of priorities.

Once we tackled down most of our critical unknowns and started to show progress we began working on the end user mobile app. After a couple of discussions on what Syrmo’s main value proposition was, we realized that its core feature needed to work without an internet connection. Skateboarders should be able to record a new skating session without needing to be connected to the internet. Obviously they need to be connected if they want to share their latest cool trick with their friends, check what their favorites skaters are doing or look for the hottest skateboarding spots near their location.

Did I say that we were understaffed? Well, for a long period of time I was the only software engineer in the team. I didn’t want to spend time with the hassles of developing and maintaining a backend application. All I needed was CRUD application and an easy way to access the models over HTTP. There was almost no business logic that needed to run in the backed.

After doing some research I found [Parse](http://parse.com). It had everything I needed. It was a backend as a service. No need to provision machines, setup databases, design REST API or develop a networking layer. Parse had a

* Mobile SDK for Android and iOS.

* Blob storage.

* A database model similar to MongoDB (which I had experience with).

* Authentication and authorization out of the box.

* Ability to execute custom business logic using [CloudCode](https://parseplatform.github.io/docs/cloudcode/guide/).

I did a quick prototype to test that all the features advertised by Parse worked as expected. After a couple of days I was really happy with the developer experience and what I could a accomplish in such a short time. Nevertheless I was still hesitant about Parse. I had a lot of experience with Ruby on Rails. I knew I could solve any problem with it.

Using a new technology is always fun and challenging but it comes with the associated cost of learning it. No matter how promising the new technology is, you will move slower first. Also when you look at the docs and the tutorials they always show you the happy paths. But what happens when you need to do something that nobody did before and when you cannot find a similar example? Ruby on Rails has 10 plus years of development and a huge community. Chances are that somebody already found the solution to your problem.

By the time we needed to start integrating a backend to our app the team got bigger. Two developers started to work with me on the iOS app. The catch was that they didn’t have any experience on iOS nor Ruby on Rails. Which made my decision between Parse or Ruby on Rails quite easy. I decided to go with Parse.

Basically I didn’t have the time to teach them both iOS and Rails. Also, as any other startup, we want to minimize our costs and engineers are one of the biggest source of cost. Not only because you have to pay them a salary, but also because they need to learn about the product, how the business works and in this case learn a new technology. Not to mention that when you add more people to a team you gain new problems. People’s personal issues, coordination, communication, egos, etc. All this can slow you down.

### About our experience with Parse

After a couple of months working with Parse, we were pretty happy with it. Most of the issues we encountered were related with how the data model works. If you come with traditional SQL database background there are some things that may look weird to you. For example how you model relations between object and the performance cost you may face. Sometimes is better to denormalize data to avoid joins. In Parse, joins are performed at the application level, meaning that they are not supported by the database, which means that in order to fetch relations you need several round trips to the database. This translates into higher latency and memory consumption.

Another problem that we have to solve was related with the offline feature. As I mentioned before Syrmo’s core feature needs to work without an internet connection. We need to be able to store each trick’s movement data and all the session’s metadata (like location and duration) in the user’s local database and then sync it back with the server when a connection is available. Parse offers a way to save objects into the client’s local datastore (they call it *object pinning*). But there is a limitation with objects that have relations. If those relations were not persisted in the backend, saving the parent object won’t save the child objects. There is another feature that lets you “save objects eventually”. This feature saves object asynchronously and if the operation fails it stores the object inside an on-disk cache. The problem with this feature is that the cache has a fixed size (10MB according to the docs) that when reached it deletes old unsaved objects. Also once the objects are saved they are removed from the cache.

We ended up rolling out our solution to store objects on disk first and then using the save eventually feature to sync the local data with the backend. This solution is still far from ideal and it was the main source of bugs and complexity. A lot of bugs started to appear once we decided to add the possibility to edit and delete this objects. I could write a separate blog post about this (and probably will), but I can tell you now that maintaining consistency between the application’s local store and the backend while being fault tolerant and making sure that you won’t loose any data, is not a task to take lightly. There are companies which have dedicated products to solve this problems. You need to design your application with this constrains in mind from the start. Otherwise, adding offline support after the fact is going to be hard.

Bottom line, if you only need to store some non-critical objects the features provided by Parse are good enough but I wouldn’t recommend it for any advanced offline-first application.

*If your application requires real time collaboration and offline support you may find Firebase or Realm’s mobile platform a better option. I don’t have production experience with them. I only made some toy applications with Firebase but their collaboration and offline feature seems to be better designed than Parse’s.*

### Parse shutdown

Everything was going smoothly until [Parse announced they were shutting down the service](http://blog.parse.com/announcements/moving-on/). This was a big surprise and something that I couldn’t anticipate. One of the reason I picked Parse in favor of other BaaS was that it had Facebook behind it.

The timing couldn’t be worse. We had already invested significant amount of time on Parse. Making a transition to another service or writing our custom backend would incur in significant delays. I immediately started to evaluate different alternatives. After some research my options were:

1. Keep using Parse and eventually transition to the open source version.

1. Move to Firebase.

1. Move to AWS Mobile platform (a combination of Labmda, Dynamo, Cognito, S3).

1. Move to a custom Ruby on Rails application.

I decided not to go with AWS Mobile, due to the complexity of managing AWS services and that some glue code was required in order to make everything work. Also with AWS there is no simple way of having a local development environment. (Parse didn’t have a local development enviroment but it was super easy and free to a get one instance per developer).

Then I spent two weeks reading Firebase’s documentation and making a [super simple Twitter-like app](https://github.com/guidomb/FirebaseFeed). I really liked what I could do with Firebase. Even more their realtime features are awesome. I knew that Firebase had everything I needed to implement all required features for Syrmo. But again, migrating to Firebase would require time that we didn’t have.

Before jumping to a new boat I decided to give Parse a new chance. A couple of months after the shutdown announcement, the community appeared to be really responsive about the open source version of Parse. A lot of issues were being solved, new features got added and the documentation and migration plans were really good. I was still reluctant to having to maintain my own server, at least at this stage but I said to myself: “If the migration to the open source version of Parse works as smooth as the docs say and after a month there aren’t any mayor issues, we’ll keep using Parse”. And so it was.

We now have our open source version of Parse server deployed to AWS Beanstalk. Let me tell you that the actual [setup](https://aws.amazon.com/blogs/mobile/how-to-set-up-parse-server-on-aws-using-aws-elastic-beanstalk/) took me less than half an hour.

### What about Parse CloudCode?

So far everything was working fine but there was an issue that needed to be solved. One of the feature that I liked about Parse was the possibility to execute custom code. This is a pretty important feature if you need to run some business logic in the backend. Although most of our logic is driven by the client, there are some features that are way simpler and more efficient to implement in the backend. Such as the user’s feed. Similar to Twitter’s feed, users can have a list of skate tricks shared by their friends in real time. Details on how we implemented this will be shared in a future blog post.

We needed a simple way to execute logic in the server. Something simple that will make a couple of queries to Parse, create some files in S3 and then create some models and save them back to Parse. I wanted something simple and didn’t want to deal with provisioning, designing REST endpoints, and choosing web frameworks. I just wanted to run a simple function, like I could do with CloudCode.

Thankfully there is a service that does exactly that (and even more), [AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html). Using [Parse’s Javascript SDK](https://github.com/ParsePlatform/Parse-SDK-JS) the integration between AWS Lambda and our server was a piece of cake.

### Conclusion

I could say that I am pretty happy with the choice I’ve made. Parse helped us focus on our client application and by using AWS Lambda we have the flexibility of writing custom code without having to worry about all the hassles of setting up a web service.

Would I choose Parse again? Maybe. Depending on what needs to be done. If a need to make a product as fast as I can where most of the logic is driven by the client, then yes. I already know how Parse works and I can be productive from day one. But there are other BaaS and open source backends out there that may be as good. If you want real time features and don’t want to deal with provisioning, [Firebase](https://firebase.google.com) might be a good choice. Similar to Firebase but open source is [Horizon](https://horizon.io/), which like Parse decided to shutdown their paid service and release it as an open source project. Finally, [Realm](https://realm.io/products/realm-mobile-platform/) has recently announced a service that helps you build real time apps.

Not all products and teams are the same. There is no rule of thumb but I am sure that if I am working on a new product with a small team and time-to-market is a concern, not having to worry about a backend it’s a pretty good idea.

Something that I learned over the last two years of working on Syrmo is that at an early stage startup you don’t have to worry to much about scalability, vendor lock-in, programming language, architecture design and all those things we software engineers love to deal with. All it matters is getting a product that works and proves that it has a valid value proposition and that there is a market willing to pay for that product.

Focus on discovering what the right product is and what your business model is. Choose the technology that enables you to accomplish that in the fastest way possible. If that means using technology that you are productive with but is not “cool enough”, go for it. Making shortcuts at this stage is OK. If you do a good job, then you will have the opportunity to sit down a make more informed decisions on which is the best technology and architecture for your product.

I our case Parse gave us the chance to avoid having to think too much about our backend and focus our resources to develop a good app experience.

*If you have experience using Parse in production, feel free to share your experience in the comments or reach out to me on Twitter @guidomb*
