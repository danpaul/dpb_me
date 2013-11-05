---
published: true
---
I created a "new sketch":https://github.com/danpaul/sand/blob/master/sketches/006.rb with "Sand":https://github.com/danpaul/sand. I will summarize what I was trying to do by quoting directly from the source:

<pre>
# create array of waves
# have all waves play the same tone
# split the group into two groups
# shift group A up
# shift group B down

# recursively repeat this process until each 
#	tone has been differentiated
</pre>

I need to write a function that does this splitting of the audio array recursively but hacking together a manual test version late at night gave me some restults. I'm intrested in trying to create the intereference waves that occur when two wave are being played at a very close frequency. This was really apparent when the waves were just starting to split at 12 and 24 seconds.

<a href="/img/2013_11_04_split_wave.png"><img src="/img/2013_11_04_split_wave.png" style="width:100%"/></a>

I also learned quickly that an increase in tone results in an apparent increase in volume. The lower tones quickly become inaudible as the lower tones get louder.

"Split Wave":/audio/131104_split_wave.mp3