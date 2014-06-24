// Playground - noun: a place where people can play

import Cocoa
import SpriteKit

var currentTime:CFTimeInterval = 1
currentTime % 1 == 0

var enemy = SKSpriteNode(imageNamed: "bird")
enemy.userData = ["life": 10] as NSMutableDictionary
enemy.userData["sample"] = "cert"
var life:Int = enemy.userData["life"] as Int
enemy.userData["life"] = life - 1
var label = SKLabelNode(text: String("hoge"))
label.text
label.name = "label"

enemy.addChild(label)
enemy.children
var label_node = enemy.childNodeWithName("label") as SKLabelNode
label_node.text

