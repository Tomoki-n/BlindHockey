//
//  GameScene.swift
//  BlindHockey
//
//  Created by Nishinaka Tomoki on 2016/02/20.
//  Copyright (c) 2016年 Nishinaka Tomoki. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation
import Foundation

extension String {
    
    /// String -> NSString に変換する
    func to_ns() -> NSString {
        return (self as NSString)
    }
    
    func substringFromIndex(index: Int) -> String {
        return to_ns().substringFromIndex(index)
    }
    
    func substringToIndex(index: Int) -> String {
        return to_ns().substringToIndex(index)
    }
    
    func substringWithRange(range: NSRange) -> String {
        return to_ns().substringWithRange(range)
    }
    
    var lastPathComponent: String {
        return to_ns().lastPathComponent
    }
    
    var pathExtension: String {
        return to_ns().pathExtension
    }
    
    var stringByDeletingLastPathComponent: String {
        return to_ns().stringByDeletingLastPathComponent
    }
    
    var stringByDeletingPathExtension: String {
        return to_ns().stringByDeletingPathExtension
    }
    
    var pathComponents: [String] {
        return to_ns().pathComponents
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        return to_ns().stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        return to_ns().stringByAppendingPathExtension(ext)
    }
    
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //Player Bar
    let p_width:CGFloat = 100
    let p_height:CGFloat = 20
    var player:SKSpriteNode!
    var x:CGFloat!,y:CGFloat!
    
    //Ball
    let b_width:CGFloat = 8,b_height:CGFloat = 8
    var ball:SKSpriteNode!
    var bx:CGFloat!,by:CGFloat!
    
    //deadzone
    var deadzone : SKSpriteNode!
    var outdeadzone : Bool = true
    
    //outzone
    var outzone : SKSpriteNode!
    var chkoutzone : Bool = false
    
    //flag
    var btnpressd:Bool = true
    var btntag = 99
    var start = false
    var smash = false
    var attack = false
    var turn = false
    
    //CollistonMask
    let blockCategory: UInt32 = 1 << 0
    let ballCategory:  UInt32 = 1 << 1
    let wallCategory:  UInt32 = 1 << 2
    let playerCategory:UInt32 = 1 << 3
    let deadCategory:  UInt32 = 1 << 4
    let outCategory: UInt32 = 1 << 5
    
    var rebone:Bool = false
    var dead:Bool = false
    var life:Int = 5
    var ene_life:Int = 5
    
    //hp
    var hp1_1:SKSpriteNode!
    var hp1_2:SKSpriteNode!
    var hp1_3:SKSpriteNode!
    var hp1_4:SKSpriteNode!
    var hp1_5:SKSpriteNode!
    var hp2_1:SKSpriteNode!
    var hp2_2:SKSpriteNode!
    var hp2_3:SKSpriteNode!
    var hp2_4:SKSpriteNode!
    var hp2_5:SKSpriteNode!
    
    override init(size:CGSize){
        super.init(size: size)
        
        //backbroundcolor
        self.backgroundColor = UIColor.grayColor()
        
        //selfphysics
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect:self.frame)
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.collisionBitMask = wallCategory
        
        if app.firstturn == false{
            outdeadzone = false
            start = true
        }
        //player
        x = CGRectGetMidX(self.frame)
        y = CGRectGetMinY(self.frame) + 100
        player = SKSpriteNode(color:UIColor.whiteColor(),size:CGSizeMake(p_width,p_height))
        player.position = CGPointMake(x,y)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(p_width, p_height))
        player.physicsBody?.dynamic = false
        player.physicsBody?.collisionBitMask = playerCategory
        
        if app.firstturn{
            //ball
            bx = x
            by = y + 20
            ball = SKSpriteNode(color:UIColor.yellowColor(),size:CGSizeMake(b_width, b_height))
            ball.position = CGPointMake(bx, by)
            ball.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(b_width, b_height))
            ball.physicsBody?.usesPreciseCollisionDetection = true
            ball.physicsBody?.collisionBitMask = ballCategory
            ball.physicsBody?.contactTestBitMask = blockCategory|deadCategory|playerCategory
            ball.physicsBody?.allowsRotation = false
            ball.physicsBody?.restitution = 1
            ball.physicsBody?.friction = 0
            ball.physicsBody?.linearDamping = 0
        }
        else{
            
            //ball
            bx = 0
            by = 0
            ball = SKSpriteNode(color:UIColor.yellowColor(),size:CGSizeMake(b_width, b_height))
            ball.position = CGPointMake(bx, by)
            ball.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(b_width, b_height))
            ball.physicsBody?.usesPreciseCollisionDetection = true
            ball.physicsBody?.collisionBitMask = ballCategory
            ball.physicsBody?.contactTestBitMask = blockCategory|deadCategory|playerCategory
            ball.physicsBody?.allowsRotation = false
            ball.physicsBody?.restitution = 1
            ball.physicsBody?.friction = 0
            ball.physicsBody?.linearDamping = 0
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func didMoveToView(view: SKView) {
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        longPressRecognizer.minimumPressDuration = 0.3
        
        let width: CGFloat = self.view!.bounds.size.width
        let height: CGFloat = self.view!.bounds.size.height
        
        
        let leftbtn = UIButton()
        leftbtn.frame = CGRectMake(0,0,width / 4,60)
        leftbtn.backgroundColor = UIColor.greenColor()
        leftbtn.setTitle("←", forState: UIControlState.Normal)
        leftbtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        leftbtn.layer.position = CGPoint(x: (width / 4 ) - (width / 8)  , y:height - 30)
        leftbtn.tag = 0
        leftbtn.addTarget(self, action: "tap:", forControlEvents: .TouchDown)
        leftbtn.addTarget(self, action: "taped:", forControlEvents: .TouchUpInside)
        leftbtn.addGestureRecognizer(longPressRecognizer)
        self.view!.addSubview(leftbtn)
        
        let leftturnbtn = UIButton()
        leftturnbtn.frame = CGRectMake(0,0,width / 2,60)
        leftturnbtn.backgroundColor = UIColor.yellowColor()
        leftturnbtn.setTitle("↑", forState: UIControlState.Normal)
        leftturnbtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        leftturnbtn.layer.position = CGPoint(x:(width / 4 * 2) , y:height - 30)
        leftturnbtn.tag = 1
        leftturnbtn.addTarget(self, action: "tap:", forControlEvents: .TouchDown)
        self.view!.addSubview(leftturnbtn)
        
        
        let rightturnbtn = UIButton()
        rightturnbtn.frame = CGRectMake(0,0,width / 4,60)
        rightturnbtn.backgroundColor = UIColor.redColor()
        rightturnbtn.setTitle("→", forState: UIControlState.Normal)
        rightturnbtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        rightturnbtn.layer.position = CGPoint(x:(width / 4 * 4) - (width / 8), y:height - 30)
        rightturnbtn.tag = 3
        rightturnbtn.addTarget(self, action: "tap:", forControlEvents: .TouchDown)
        rightturnbtn.addTarget(self, action: "taped:", forControlEvents: .TouchUpInside)
        rightturnbtn.addGestureRecognizer(longPressRecognizer)
        self.view!.addSubview(rightturnbtn)
        
        for i in 1...5 {
            var hp1:SKSpriteNode = SKSpriteNode(imageNamed: "p1b.png")
            hp1.position = CGPointMake(CGFloat(i * 30), (self.view?.bounds.height)! - 20)
            self.addChild(hp1)
            var hp2:SKSpriteNode = SKSpriteNode(imageNamed: "p2b.png")
            hp2.position = CGPointMake(CGFloat(i * 30 + 180), (self.view?.bounds.height)! - 20)
            self.addChild(hp2)
        }
        
        hp1_1 = SKSpriteNode(imageNamed: "p1.png")
        hp1_1.position = CGPointMake(CGFloat(1 * 30), (self.view?.bounds.height)! - 20)
        self.addChild(hp1_1)
        hp1_2 = SKSpriteNode(imageNamed: "p1.png")
        hp1_2.position = CGPointMake(CGFloat(2 * 30), (self.view?.bounds.height)! - 20)
        self.addChild(hp1_2)
        hp1_3 = SKSpriteNode(imageNamed: "p1.png")
        hp1_3.position = CGPointMake(CGFloat(3 * 30), (self.view?.bounds.height)! - 20)
        self.addChild(hp1_3)
        hp1_4 = SKSpriteNode(imageNamed: "p1.png")
        hp1_4.position = CGPointMake(CGFloat(4 * 30), (self.view?.bounds.height)! - 20)
        self.addChild(hp1_4)
        hp1_5 = SKSpriteNode(imageNamed: "p1.png")
        hp1_5.position = CGPointMake(CGFloat(5 * 30), (self.view?.bounds.height)! - 20)
        self.addChild(hp1_5)
        
        hp2_1 = SKSpriteNode(imageNamed: "p2.png")
        hp2_1.position = CGPointMake(CGFloat(1 * 30 + 180), (self.view?.bounds.height)! - 20)
        self.addChild(hp2_1)
        hp2_2 = SKSpriteNode(imageNamed: "p2.png")
        hp2_2.position = CGPointMake(CGFloat(2 * 30 + 180), (self.view?.bounds.height)! - 20)
        self.addChild(hp2_2)
        hp2_3 = SKSpriteNode(imageNamed: "p2.png")
        hp2_3.position = CGPointMake(CGFloat(3 * 30 + 180), (self.view?.bounds.height)! - 20)
        self.addChild(hp2_3)
        hp2_4 = SKSpriteNode(imageNamed: "p2.png")
        hp2_4.position = CGPointMake(CGFloat(4 * 30 + 180), (self.view?.bounds.height)! - 20)
        self.addChild(hp2_4)
        hp2_5 = SKSpriteNode(imageNamed: "p2.png")
        hp2_5.position = CGPointMake(CGFloat(5 * 30 + 180), (self.view?.bounds.height)! - 20)
        self.addChild(hp2_5)
        
        self.addChild(player)
        if app.firstturn || app.myturn{
            self.addChild(ball)
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        /*   for touch in touches{
        letlocation = touch.locationInNode(self)
        player.position.x = location.x
        }
        */
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if(!start){
            movingBall()
        }
        
    }
    
    
    func accelerate() {
        ball.physicsBody?.velocity.dx *= 1.01
        ball.physicsBody?.velocity.dy *= 1.01
    }
    
    func movingBall(){
        let rnd = CGFloat(arc4random()%30)
        let ballVel = CGVector(dx:((arc4random()%2 == 0) ? -200-rnd:200+rnd),dy:200+rnd)
        ball.physicsBody?.velocity = ballVel
        start = true
    }
    
    
    
    func tap(sender: UIButton){
        
        switch sender.tag {
        case 0:
            self.player.position.x -= 5
            if !start{
                self.ball.position.x -= 5
            }
            btnpressd = true
            btntag = 0
        case 1:
            if start{
            smash = true
            let upbar:SKAction = SKAction.moveByX(0, y:50, duration: 0.1)
            player.runAction(upbar)
            let downbar:SKAction = SKAction.moveByX(0, y:-50, duration: 0.3)
            player.runAction(downbar,completion: {() -> Void in
                self.smash = false
            })
            }
        case 3:
            self.player.position.x += 5
            if !start{
                self.ball.position.x += 5
            }
            btnpressd = true
            btntag = 3
        default:
            break
        }
        
    }
    
    func taped(sender: UIButton){
        btntag = 99
        btnpressd = false
        
        
        
    }
    
    func go_st(){
        
        
        
    }
    
    func chkposs() -> Bool{
        

        
        
        return true
    }
    
    func rebones(){
        print("func rebone")
        self.life--
        switch self.life {
        case 4 :
           hp1_1.removeFromParent()
        case 3 :
            hp1_2.removeFromParent()

        case 2 :
            hp1_3.removeFromParent()

        case 1 :
            hp1_4.removeFromParent()

        default:
            break
        }
        
     
    }
    
    func deads(){
        print("func dead")
        
        self.app.controller.performSegueWithIdentifier("over", sender: nil)
        
        
        
    }
    
    func ene_deads(){
     print("func enedead")
    
        self.app.controller.performSegueWithIdentifier("clear", sender: nil)
        
    }
    
    func ene_rebones(){
        self.ene_life--
        switch self.ene_life {
        case 4 :
            hp2_1.removeFromParent()
        case 3 :
            hp2_2.removeFromParent()
            
        case 2 :
            hp2_3.removeFromParent()
            
        case 1 :
            hp2_4.removeFromParent()

        default:
            break
        }
        
        
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Began {
            print("longPressed")
            btnpressd = true
            
            
        }
        if sender.state == UIGestureRecognizerState.Ended {
            print("out")
            btntag = 99
            btnpressd = false
            
        }
        
    }
    
    
    //Colision Checking
    func didBeginContact(contact: SKPhysicsContact) {
        var first,second : SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            first = contact.bodyA
            second = contact.bodyB
        }else{
            first = contact.bodyB
            second = contact.bodyA
        }
        if(first.collisionBitMask == deadCategory){
            switch second.collisionBitMask{
            
               
                
            default:
                break
                
            }
        }
        if(first.collisionBitMask == ballCategory){
            //print(ball.physicsBody?.velocity.dx,ball.physicsBody?.velocity.dy)
            
            switch second.collisionBitMask{
            case playerCategory:
                accelerate()
                //self.ball.physicsBody?.affectedByGravity = true
                if smash {
                    print("smash")
                    let ballVel = CGVector(dx:(self.ball.physicsBody?.velocity.dx)! * 0.8  ,dy:(self.ball.physicsBody?.velocity.dy)! + 50 )
                    ball.physicsBody?.velocity = ballVel
                    
                //self.ball.physicsBody?.affectedByGravity = true
                }
              
            default:
                break
            }
            
        }
        
    }
    
    func play(soundName:String,state:Int){
        let soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(soundName)
        let url:NSURL? = NSURL.fileURLWithPath(soundPath)
        var player: AVAudioPlayer!
        do{
            player = try AVAudioPlayer(contentsOfURL: url!, fileTypeHint: nil)
            
        }catch{
            
        }// Optional Chainingを使う。
        if let thePlayer = player {
            
            if(state==1){thePlayer.numberOfLoops = -1}
            thePlayer.prepareToPlay()
            thePlayer.play()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        // print(self.ball.position.y)
        
        if app.ene_dead{
            //view遷移　win
            app.ene_dead = false
            ene_deads()
        }
        
        if app.ene_rebone{
            //相手1減らす
            ene_rebones()
            app.ene_rebone = false
            print("func enerebone")
          
        }
        
        if dead{
            //view遷移　lose
            deads()
            dead = false
            app.controller.sendMes("dead")
        }
      
        if rebone {
            //自分1減らす
            rebone = false
            start = false
            
            rebones()
           
            
            bx = x
            by = y + 20
            ball = SKSpriteNode(color:UIColor.yellowColor(),size:CGSizeMake(b_width, b_height))
            ball.position = CGPointMake(bx, by)
            ball.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(b_width, b_height))
            ball.physicsBody?.usesPreciseCollisionDetection = true
            ball.physicsBody?.collisionBitMask = ballCategory
            ball.physicsBody?.contactTestBitMask = blockCategory|deadCategory|playerCategory
            ball.physicsBody?.allowsRotation = false
            ball.physicsBody?.restitution = 1
            ball.physicsBody?.friction = 0
            ball.physicsBody?.linearDamping = 0
            self.turn = false
            
            x = CGRectGetMidX(self.frame)
            y = CGRectGetMinY(self.frame) + 100
            player.position = CGPointMake(x,y)
            
            self.addChild(ball)
            
            app.controller.sendMes("rebone")
            
        }
        
        
        if app.getdata{
            print((self.view?.bounds.width)!,(self.view?.bounds.height)!)
            app.getdata = false
            let dx:CGFloat = ((self.view?.bounds.width)! * ( 1 - app.posx))
            let dy:CGFloat = (self.view?.bounds.height)!
            print(dx,dy)
            self.ball.position = CGPointMake(dx,dy - 10)
            self.ball.physicsBody?.velocity.dx = app.balldx
            self.ball.physicsBody?.velocity.dy = -app.balldy
            print(self.ball.physicsBody?.velocity)
            outdeadzone = false
            print("getdata")
            self.addChild(ball)
        }
        if self.ball.position.y <= ((self.view?.bounds.height)! - 50) {
            if !outdeadzone {
                outdeadzone = true
                print("change param")
            }
            
        }
        
        if self.ball.position.y <= 30 && app.myturn && !turn{
            self.turn = true
            if(life > 1){
                rebone = true
            }else{
                dead = true
            }
            self.ball.removeFromParent()
            
        }
        if self.ball.position.y >= ((self.view?.bounds.height)! - 10) && outdeadzone {
            print("delete")
            print((self.ball.physicsBody?.velocity.dx)!)
            print((self.ball.physicsBody?.velocity.dy)!)
            print(self.ball.position.x / (self.view?.bounds.width)! )
            self.ball.removeFromParent()
            let dposx = (self.ball.position.x / (self.view?.bounds.width)! )
            app.myturn = false
            app.controller.sendMes("\((self.ball.physicsBody?.velocity.dx)!)" + "," + "\((self.ball.physicsBody?.velocity.dy)!)" +   ","  +  "\(dposx)" )
            //print("dx:" + "\((self.ball.physicsBody?.velocity.dx)!)" + "dy:" + "\((self.ball.physicsBody?.velocity.dy)!)" +   "posx:" +  "\((self.ball.position.x / (self.view?.bounds.width)! ))")
            print(self.ball.position.x,self.ball.position.y)
            ball.position = CGPointMake(0,0)
            self.ball.physicsBody?.velocity.dx = 0
            self.ball.physicsBody?.velocity.dy = 0
            self.app.myturn = false
        }
        
        
        if btnpressd {
            
            switch self.btntag {
            case 0:
                self.player.position.x -= 5
                if !start{
                    self.ball.position.x -= 5
                }
            case 3:
                self.player.position.x += 5
                if !start{
                    self.ball.position.x += 5
                }
            default:
                break
            }
            
            
        }
        
    }
    
    
}
