---
title: Measuring Voice Or Video Quality
---

# Measuring Voice Or Video Quality

The overall quality of a voice or video stream is often depicted through a metric called [*Mean Opinion Score (MOS)*](https://en.wikipedia.org/wiki/Mean_opinion_score).

It is common that MOS is represented as a rational number between 1 and 5, with the following scale: 
> 5 - Excellent, 4 - Good, 3 - Fair, 2 - Poor, 1 - Bad.

Frequently, MOS higher than 4 reflects a satisfying quality. For MOS higher than 4.3, the human senses cannot usually perceive an increase in quality. On the lower side, when MOS is lower than 3.5, commonly the quality isn’t sufficient, especially for communication purposes.


### How is MOS calculated?

The MOS is calculated using an [agreed upon formula](https://docs.telcobridges.com/tbwiki/MOS), which utilizes multiple features of the data steam passed over the network. Among those features, the ones with the most significant impact are: 
* Packet loss - the amount of data packets that never made it from the sender to the receiver
* Latency - the time it takes a data packet to get from the sender to the receiver, and back to the sender
* Jitter - the difference between the latency of one data flow to the other. In other words, how delayed was a received data packet, comparing to the previous received data packet

An R-value is calculated based on those factors and is later used to calculate the final MOS, by this well unknown formula:  
> MOS = 1 + 0.035R + ((R - 60) * (100 – R) * 0.000007R)

