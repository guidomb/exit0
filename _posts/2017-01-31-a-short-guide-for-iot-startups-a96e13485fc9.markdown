---
layout: post
title:  "A short guide for IoT startups"
date:   2017-01-31 03:00:00 -0300
categories: iot
redirect_from:
  - /a-short-guide-for-iot-startups-a96e13485fc9
---

I was asked to give a talk targeted to investor that didn’t have experience investing in IoT startups. Although I’m far from being an expert on the subject I think I have some notes I can share after 3 years of working on a hardware startup.

Most of the following applies to a *subset* of hardware startups, nowadays called **IoT** or *internet of things*. Which in most cases referrers to consumer electronic devices that are either connected to the internet or to some sort of network of devices. Things like smart light bulbs, smart lighters or connected devices to grow plants and vegetables. Although there are processes and advice that applies to IoT startups and also more “*old-school*” hardware startups. Is not the same to build a smart light bulb as having to build an autonomous robot that can navigate an unknown location.

### Software startups v.s. IoT startups

Although most of the processes and methodologies involved in developing a product on a software startups also apply to IoT startups, there are some differences that need to be noticed.

I think that is important for someone that is entering the world of hardware startups for the first time to know the different stages involved in developing a hardware product and the different risks that they may face during this process.

*I recently found another blog post that also talks about the process of building a hardware product. After reading this one take a look at [this](https://backchannel.com/how-to-build-a-hard-tech-startup-4028d22f2c91#.khrghbt85) other one.*

### Hardware startup product stages

Most hardware startups and in particular IoT startups go through a set of stages when they develop a product. Each stage has different goals and it only makes sense to move forward to the next stage once all or most of the hypothesis for that stage have been validated. This stages usually are:

* Idea

* Proof of concept

* Prototyping

* D.F.M. or design for manufacture

* Production

### Idea

This stage consists mostly of working on your idea, defining the value proposition and your main hypothesis. By the end of this stage you should have a clear idea of what problem you are trying to solve and a rough idea of how you will solve that problem. It is recommended to work on some design concepts, at least at a very high level of how the product would look like and it is useful to have a 3D render of the product. This helps a lot to communicate and visualize your product in order to talk with potential angel investor or to recruit some co-founder or first employees. It is also a good idea to create a landing page and start getting some feedback from potential users.

### Proof of concept

This stage allow you to validate that a rough concept can be made and that the technology is mature enough, at least to demonstrate your product’s core functionality. At this stage engineers usually use development boards and prototyping tools like [Arduino](https://www.arduino.cc/), [Raspberry PI](https://www.raspberrypi.org/) or integrated circuit boards that already come with things like a micro-controller, [IMU sensors](https://en.wikipedia.org/wiki/Inertial_measurement_unit), Bluetooth or WiFi chips. Aesthetics and cost is generally not a concern at this stage.

By the end of this stage you can look for seed investment to be able to go through the next stage. Hopefully you have a working proof of concept that can demonstrate your product’s core value proposition and with a strong pitch you can convince investor to bet on your startup.

*Sometimes it happens that the technology is available but the product cannot be launched because it either fails to satisfy other constrains like size, battery life or production cost is too high. Being able to reach this stage does not mean that all risks have been mitigated. Usually is the other way around, the most risk adverse part is yet to come.*

### Prototyping

After validating that the product’s core functionality can be built you move to the prototyping stage. This stage may consiste of several iterations of the product where you take into consideration production costs, the product’s form factor, aesthetics, materials, etc.

Generally speaking this stage involves the design and manufacture of custom [PCB](https://en.wikipedia.org/wiki/Printed_circuit_board) and a case where that PCB will be held. Engineers usually produce 5 to 20 pieces of each design variation or prototype to test its performance, robustness, different materials and the general user experience. It its recommended at this stage to test the different prototypes with “real” users to try to get as much feedback as possible.

This is a critical a stage for an IoT startup because at this stage is when you lock down how the final product will look like, how it will behave and its core features. That is why is so important not to move forward until you have validated that the prototype you have built has a real value proposition that users are willing to pay for. Also at this stage you will have a pretty good estimate of the final production cost. Although that will be refined in the next stage, at this moment you can estimate how much money you will need for the following stages and you can commit to a retail price.

### D.F.M. or design for manufacture

Here is where you start preparing the design to be able to be manufactured at medium or large scale. This process usually involves talking with factories to know if they are capable of building your product in a cost effective way. This stage may require minor tweaks in the design or changing some components or materials in order to make the manufacturing processes easier. Here is where you also learn if your product will require certain certifications in order to be sold in your target market.

It is recommended to hire an external consultant with experience on manufacturing if this is the first time your team is going through this process. Making sure this stage is well executed is critical for the success of the product. A lot of hardware startups underestimate this stage thinking that going to production from the prototyping stage is just a matter of making more units. It is not. The manufacturing process required to build 20 units is completely different from building 100, 1,000 or 10,000.

Finally, here is when you can lock down the final production costs and know for sure what your retail price and revenue will be. This is the safest stage to start taking pre-orders either by accepting them through your web page or by launching a crowdfunding campaign in sites like [Kickstarter](https://www.kickstarter.com/) or [Indiegogo](https://www.indiegogo.com). Take into account that in order to move to the next stage you will need to be at a point of having to call the factories and tell them to start building your product which will require more cash upfront. Some startups raise another investment round here, something between a seed and series A round. Another options is to launch a crowdfunding campaign then, if the campaign is successful, you may still want to raise a round but in this case (depending of how successful the campaign was) you will stand on a different position.

### Production

This stage varies in complexity depending on the amount of units that will be produced. Different orders of magnitude usually require different production techniques. In general at this stage you have to coordinate with the factory or factories. Once this stage has been reached you cannot make any changes to the product except maybe some minor tweaks here and there to make the production process smoother or to avoid any possible performance problems. Things like replacing non-critical electronic components, minor layout changes on the P.C.B. or shaving a couples of millimeters from the case’s mold.

Once you are sure everything is ready you will need to commit on tooling. This is why this stage requires quite a lot of cash upfront. In general, most IoT product have some sort of [injection molding](https://en.wikipedia.org/wiki/Injection_moulding) case. Which means that a factory will need to produce a mold first. This process varies depending on the complexity of the case, the technique used and the materials but it usually takes 3 to 4 weeks. Once the mold is ready a pre-production run is made, around 150 units. This gives you the chance to fix minor issues, shave some rough edges and do some intensive end-to-end testing.

Some startups use this period and the pre-production units with beta tester who usually are your evangelizer, first users that are really engaged with your product. Getting feedback at this stage is also really important because you can polish some processes like unboxing for example. Check that all the installation instructions are clear. If you provide some sort of software like a mobile application, you can check that the first user flow goes as smooth as possible, that users are able to connect with your device and know how to use it.

### How much money do you need to reach M.V.P?

Another key difference between pure software startups and IoT startups is the amount of cash they need and the time it takes to reach M.V.P. Each of the previous stage requires a significant amount of money and iteration times are way longer than on a pure software product.

### Cash and time per stage

* **Idea:** This could take **1 to 2 months** and maybe around **5k USD** if you need to hire a free lancer to do some sketches, 3D renders or a landing page.

* **Proof of concept:** Around **15k USD** and **1 to 3 months**.

* **Prototyping:** Assuming 3 prototypes iterations with custom P.C.B. and some sort of casing using [CNC](https://en.wikipedia.org/wiki/Numerical_control) or 3D printing. Around **150k USD** and **6 to 8 months**.

* **D.F.M.:** Around **3 months** and **60k to 90k USD**

* **Production:** Depending on the amount of units, but lets say a first production run of 500 to 1000 units. Around **60k USD** and **2 months**.

For what I observed so far and IoT startups usually takes **at least 18 months** to go from idea to production, assuming all stages are executed correctly and there any mayor problems. Again this varies a lot depending on the complexity of the product but **2 years** and **350k to 500k USD** investment seems to be the bare minimum.

### What about risks?

An IoT startups is subject to the same risks most startups face, being the most important building the wrong product and running out of money. But if you come from a pure software startup background there are some things that you should probably consider.

### Certifications, patents and taxes

Most probably if your product requires some sort of wireless connectivity like Bluetooth or WiFi most likely you will have to certify your antenna design. If your product doesn’t have the required certifications you won’t be able to sell it in some markets. This regulations depend on each market, selling a product in Europe may require different certifications than in the U.S. Another option instead of having to go through the certification process is to use pre-certified modules. For example there are modules that you can include in your custom circuit that already include a Bluetooth chip and an antenna. This modules have already been certified by the Bluetooth consortium. This may increase your unit cost but frees you of having to certify your product. Which certifications are needed depends on the specific of your product but take into account that they take time and money. Is usually safe to add **3 weeks** and **5k to 15k USD**.

Another thing to consider is patents, which also applies to pure software startups. This could add another **12k to 20k USD** to your budget. Same as with certifications, they change depending on where you want to sell your product. There are agreements between countries, for example in the case of the EU you only apply for a patent that is valid on all members of the EU.

Also when building a hardware product, chances are that you would require different components or parts that you may not find in the country you are doing the R&D. Depending on the regulations of the country you are based on, importing this components may incur in import feeds that could significantly increase your development costs. Not to mention the bureaucracy and delays.

### Cash flow

Running out of cash is something that all startups have to be concerned of but this problem accelerates with hardware startups due to the amount of cash needed for product development. You not only have to pay for engineers salaries and external consultants fees but you have to pay for tools, materials and everything needed to build your prototypes. Not to mention the required tooling once you are in the production stage.

The risk of running out of cash increases when you are about to make your first production run. Factories usually don’t give you credit, you have to pay them up front both for the tooling costs and the production cost per unit. You pay for product that you will be able to sell and cash in at least 3 months in advanced. Other things can add up quickly, like import / export fees, storage and shipping fees.

After you build a relation with your factory they may give you credit and some times they do it the first time you work with them if they like your product or see some strategic value of working with you.

### Design and manufacturing issues

A couple of things regarding product design that shouldn’t be overlooked:

* Products that have mechanic and moving parts are usually harder to build and add more risk to the manufacturing process.

* Things like shock-proof and water-proof is not something to take lightly. If your product needs be to water-proof and this is the first time that you are working on a product like this, hire an external consultant at least to review your design and help you with manufacturing. There are quite a few cases of startups failing at this promises adding significant delays or even having to recall product that didn’t work in the environment there were supposed to.

### Fulfillment of physical goods

Again, another area that most people that come from a pure software startup background don’t know is dealing with an actual physical product.

Building a product is just one of the many things you need to do. After the product is built, you need to sell it. This is where you need to think which are your distribution channels. Again, this changes depending on the product but if you are selling a consumer electronic type of product you probably want to be on the shelf of most well known retailers. Getting access to big retail chains is not easy. They usually get products that sell well and are proven. They tend to place big orders and expect them to be fulfilled on time. They even put huge penalties for each day you fail to deliver. You’d better be prepared and have all your processes fine-tuned before going for the retailers like Walmart, Target or Best Buy, if your target market is the U.S.

That is why startups usually start by first taking pre-orders on their site or through a crowdfunding campaign, then they move to online orders only and they start working on distribution deals. Take into account that if your product needs to be sold on local shops, going shop by shop across a whole country for usually low volume orders could be close to impossible for startups with low budget and a small team. That is why selling your product to distributors alleviates this problem because they take bigger orders and they deal with managing stock and getting the product to their network of retailers. Remember that managing product stock costs money, you have to store your product somewhere and the logistics behind distribution it not easy.

The downside of retailers and distributors is that they take a significant share of the retail price, usually between **40% and 60% of the retail price.** Selling your product through your website gives you higher margins and chances are that at the beginning you won’t be taken a lot of orders. You can deal with shipping yourself and once it gets out-of-hand you can hire a service that helps you with order fulfillment. Some factories even have deals with fulfillment centers (in the U.S.) and they can ship the product directly to them. No need of having to maintain stock.

### Intellectual property

Intellectual property is a concern specially when dealing with Chinese factories. There are tons of cases of factories coping and selling the product they are making for their customer. After all they know how to make it. Sad news is that there isn’t much you can do about it and to be honest is not worth it.

Chinese factories won’t sign you and [NDA](https://en.wikipedia.org/wiki/Non-disclosure_agreement) or a non-compete, unless your are Apple. Instead of wasting a lot of money on lawyers and patents the smart thing to do is building a company around a product that does not depend on the revenue that it gets by selling the hardware only. Also hardware is getting cheaper and cheaper and production costs are decreasing year after year. Chances are that your product will get commoditized eventually.

That is why it is recommended to use the hardware as a vehicle to unlock certain features and develop other revenue streams. For example if your hardware cannot do much without a companion mobile application, then factories will need to build their own copy cat of your app. Sometimes the technology behind the product is not that cutting edge or innovative but the way it is applied and how is marketed it is. Building a strong brand and providing extra features or value to the hardware through a software component is the safest way to protect you from being copied.

### Revenue streams

One of the most critical parts of a hardware startup to ensure its survival is to know your revenue streams and your costs. Getting the right retail price is really important and is a decision that should be taken with actual information. Pricing is not trivial and users may be willing to pay more o less depending on factors such as how they perceive your brand, the type of product you are selling or the value you are providing.

A good rule of thumb to set a base retail price for your product is to **multiply the unit cost by 4**. This includes actual production cost which you can infer from the [BoM or bill of materials](https://en.wikipedia.org/wiki/Bill_of_materials) plus shipping and packaging costs. This rule gives you enough margin to pay for distributors, retailers, payment processing feeds and some refunds.

As mentioned before when we talked about intellectual property, it is important that you build other sources of revenue. Even old-school traditional hardware companies are adding services, usually through software and in many cases startups don’t make money by selling hardware. They use hardware as way to enable their business and the real money comes from software. It is even a common practice for startups to sell their hardware at a price just to meet the costs or even under the production costs because that is way to improve adoption and increase the entrance barrier for competition. This of course is possible if the hardware enables them to activate other sources of revenue.

### Conclusion

I know, this looks a little bit scary but let me tell you that going through this process is really fun. As an entrepreneur you will need to learn how to wear a lot of new hats. As a investor entering the hardware world for the first time, is good to know the difference between building a hardware and a software product and set the right expectations.

The hardware community is awesome and there is a lot of material out there. Most founders that have gone through this process would love to share their experience and help newcomers. Don’t be afraid of asking.
