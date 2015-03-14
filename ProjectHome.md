asModular is intended to ease the playback and real-time modification of sound samples using the Sound object in the flash player 10.

Syntax might be very simple, like in this example
(that plays, filters and shapes an mp3 sound file) :

```
var player:MP3Player = new MP3Player();
player.load( 'sample.mp3' );

var filter:SimpleFilter = new SimpleFilter()
filter.addSource( player );
filter.frequency = .3;
filter.resonance = .7;

var shaper:WaveShaper = new WaveShaper();
shaper.addSource( filter );
shaper.amount = .5;

var mixer:AudioMixerOutput = new AudioMixerOutput();
mixer.addSource( shaper );

mixer.play();
```


---


You might aslo want to hear an example at the following url :
http://panoptic.be/boblemarin/morefx/
(view source is enabled)


---


Still in an early and experimental stage,
it is hard to tell what this project will turn to.

In the future, there might be sound generation and a lot more.
