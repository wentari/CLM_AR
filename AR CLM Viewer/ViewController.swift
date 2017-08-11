//
//  ViewController.swift
//  AR CLM Viewer
//
//  Created by Peter Yeung on 8/1/17.
//  Copyright © 2017 Wentari. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var gridMaterial : SCNMaterial!
    var counter : Decimal!
    var initialDetect : Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize variables used for demo flow
        gridMaterial = SCNMaterial()
        counter = 0
        initialDetect = false
        
        // Set the view's delegate
        sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // not interested in multi touch
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            // convert from 2d to 3d
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if !results.isEmpty {
                print("touched the plane")
                if (counter == 0) {
                    gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/slide2.jpg")
                    
                } else if (counter == 1) {
                        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/slide3.jpg")
                        
                    
                } else if (counter == 2) {
 
                    //-----------------------------------
                    // Fade in the heart
                    //-----------------------------------
                    let geoScene = SCNScene(named: "art.scnassets/Heart.dae")
                    let heartNode = (geoScene?.rootNode.childNode(withName: "Heart", recursively: true))
                    heartNode?.position = SCNVector3(0, 0, -0.2)
                    heartNode?.runAction(
                        SCNAction.rotateBy(x: 0, y: 800, z: 0, duration: 1500)
                    )
                    heartNode?.opacity = 0
                    heartNode?.runAction(
                        SCNAction.fadeIn(duration: 2))
                    sceneView.scene.rootNode.addChildNode((geoScene?.rootNode.childNode(withName: "Heart", recursively: true))!)
                    print ("Added heard node!")
                    
                    
                } else if (counter == 3){
                    // remove the slide
                    let slideNode = (sceneView.scene.rootNode.childNode(withName: "Slide", recursively: true))
                    slideNode?.runAction(
                        SCNAction.fadeOut(duration: 2))
                    print ("removing slide")
                    
                } else if (counter == 4) {
                    // remove the heart
                    //sceneView.scene.rootNode.childNode(withName: "Heart", recursively: true)?.removeFromParentNode()
                    //print ("removing heart")
                    
                    let heartNode = (sceneView.scene.rootNode.childNode(withName: "Heart", recursively: true))
                    heartNode?.runAction(
                        SCNAction.fadeOut(duration: 2))
                    print ("removing heart")
                    // reset counter so this loops
                    counter = 1
                }
                
                counter = counter + 1
                
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeNode = SCNNode()
            planeNode.name = "Slide"
            planeNode.position = SCNVector3(x: planeAnchor.center.x - 1, y: 0, z: planeAnchor.center.z )
            planeNode.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let matrixMaterial = SCNMaterial()
            matrixMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [matrixMaterial]
            planeNode.geometry = plane
            
            
            
            //-----------------------------------
            // Do one at 90 degree angle
            //-----------------------------------
            let planeNode2 = SCNNode()
            let plane2 = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            planeNode2.name = "Slide"
            //planeNode2.transform = SCNMatrix4MakeRotation(-Float.pi/2, 0, 1, 0)
            planeNode2.transform = SCNMatrix4MakeRotation(0, 0, 1, 0)
            //planeNode2.position = SCNVector3(x: planeAnchor.center.x - 100 , y: planeAnchor.center.y - 100, z: planeAnchor.center.z - 500 )
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/slide1.jpg")
            plane2.materials = [gridMaterial]
            planeNode2.geometry = plane2
            planeNode2.opacity = 0
            planeNode2.runAction(
                SCNAction.fadeIn(duration: 2))
            node.addChildNode(planeNode2)
            

            
        } else {
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
