# nestrun
smart home fitness game

## What is it?

Nest Run is an app remarkable in at least two respects. First, it makes extensive use of your home cameras which otherwise remains mostly useless. Second, it is a fun fitness multiplayer game which yore family and friends will definitely love to play!

Game rules are simple. Each round called 'run' you have to run (no surprise) from your current location to the target location marked on the floor plan (our game field) by a blue dot.

When we say 'run' we meant it, you have to run physically and not tap the screen of your iPhone (as you probably expect from a decent mobile game).

While running, you have to avoid 'red zones.' Touching a 'red zone' decrements scores you can earn for the run. Sometimes red zones are unavoidable, but you always can try to trick your cameras moving slowly and making no noise.

Time of the 'run' is limited. If you got to the target in time, you get the full scores. Delay decrements your run scores with each second, but while it is above zero, it is ok to be late.  If you haven't made it before the target score drops to zero, you left one 'life'. You have only three lives to run out of.

Since you play literally with a security system of your house, it is not a good idea to install the app on every iPhone even though it is your best friend's iPhone. That's why the app implements so-called 'hot seat' mode. Your friend can take your phone, activate his account and play for himself.

Another (not yet supported) possibility would be to authorize for a game only users which are physically in the house now. This approach will allow implementing another, even more, fun game mechanics, for example, team-run, hide-and-seek and alike.

## Current state?

The app is on very early development stage. It's rather a mockup with a functional Nest networking core tested only with Nest simulator and with a prototype gameplay controller working with statically defined game level.

## How does it work?

To observe player's movement through a house, the app establishes a persistent network connection with Nest cameras (using REST Streaming protocol) and listens to camera events. Events in spaces with the target spot and 'red zones' trigger gameplay events, other camera events ignored.

## Links

How it looks in runtime: https://youtu.be/RvsQCec0lck
