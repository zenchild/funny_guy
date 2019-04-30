# FunnyGuy

This was a fun project to work on. I've had a little bit of experience with Markov chains in the past but it was quite awhile ago. It was getting to the point where it felt like something I could keep working on and tweaking but I figured I should probably call it quits for now. I will detail a few of the pieces of code below and discuss my thoughts on them.

## TLDR: Usage

```
# Generate jokes using a 1st order Markov Chain
rake tell_me_a_1st_order_joke

# Generate jokes using a 2nd order Markov Chain
rake tell_me_a_2nd_order_joke

# Clear the jokes db and chain cache
rake clear_db
```

## HTTP Client

The HTTP Client pattern that I've added to this library might be a little overkill of what we're doing here but it is a common pattern that I use for talking to extenal APIs and is quite extensible. It uses Faraday as a base client but allows you to hook into it with yields in various places. It uses this as the basis for the ICanHazDadJoke API but it would be relatively easy to hook in another API.

## Markov Processor and Chain

I decided to split the Markov classes into a `Processor` class and a `Chain` class since it seemed that there were different responsibilites with the processing vs use of the chain.

The `Processor` supports creating chains of the order 1, 2 or 3. This means it will use word keys with either 1, 2 or 3 words. The higher the order the less random the sentence generation will be. If you specify an order outside of this range it will generate an exception.

## FunnyGuy::Generator

The `FunnyGuy::Generator` class is mosty a utility class and has more static methods than I normally like to use but it works well for demonstration purposes. It has methods that will build a `jokesdb` with the available jokes from the ICanHazDadJoke API so it doesn't have to go to the network for each use. It will also cache the Markov chains for each order that you build.

## Enhancements

There are quite a few enhancements that could happen with this. I will list a few below.

* Better bounds checking: While it is doubtful that this would go into a loop I suppose it is possible. There is no limit checking in that respect.
* Better handling of punctuation: The text retrieved from ICanHazDadJoke has punctuation all over the place. This library takes a pretty naive approach with punctuation and could be enhanced.
* tests: ha! sorry. no tests. I thought it would be interesting to benchmark the just-in-time weighted selection vs a one-time computation of the cumulative density function for each key. I think it would be interesting to benchmark various iterations of the Markov chain processor. For instance, the StringScanner vs a simple split of tokens to an Array.
* ???: I'm sure there is much more.
