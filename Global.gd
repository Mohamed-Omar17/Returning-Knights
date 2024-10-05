extends Node

var attacking = false; 
var canMove = true;
var takeDamage = false;
var inAttackRange = false;

var doorOneOpened = false;

var playerAlive: bool;
var showEnemies: bool;
var gotHit: bool;
var playerGotHit = false;
var onFloor: bool;
var playerHealth = 3;
var enemyHealth = 3;
var playerCanBeHit = false;
var gameStart = false;

var hitFromRight = false;
var hitFromLeft = false;

var playRightHit = false;
var playLeftHit = false;

var paused = false;
