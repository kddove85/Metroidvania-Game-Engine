# simple_game

# Hierarchy
This engine has several scenes, some of which inherit from other scenes. The following is an explanation
for the hierarchy.

The main scene in the engine is the Game Manager scene. This scene will spawn all the necessary other
scenes to be used. For instance, upon starting the game, the game manager will spawn the menu. If 'New Game'
is selected, then the game manager will free the menu scene and open with the AreaA scene, and so on.

## Actor
The Actor class will have variables for speed, gravity, tile size (basically a speed factor) as well as
a sprite, hurtboxes, and a stats object. The stats object as of now only contains hit points. The actor 
class also has functions relating to i-frames.

## Player
The Player class inherits from the Actor class. In addition to the aforementioned inherited functions and
properties, the player has an enum for States, current state, a camera, projectile spawn point (for 
spawning Player Projectiles), and several new functions.

## Enemy
The Enemy class inherits from the Actor class as well. In addition to the inherited functions and properties
from Actor, the enemy also has the ability to scan for the player node. This allows for the ability to search
for the player node and attack, or attack in the player's general direction.

## Boss
The Boss class inherits from the Enemy class. Work in Progress

## Area
The actual game is made up of Areas. Each Area will have a tile map, several rooms, several collectibles,
"bonfires", connectors from one area to another, player spawn points, a boss spawn point, and NPCs. Each 
area will also have its own music to set ambience for each individual area.

## Generic Projectiles
WIP

## Player Projectiles
WIP

## Enemy Projectiles
WIP





# Music Contributions
"Mysterious Anomaly" by Eric Matyas Soundimage.org \
"Spooky Forest" by Bendzer OpenGameArt.org \
"Boss Theme" by Cleyton Kauffman - https://soundcloud.com/cleytonkauffman