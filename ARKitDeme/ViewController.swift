//
//  ViewController.swift
//  ARKitDeme
//
//  Created by user131656 on 10/17/17.
//  Copyright © 2017 user131656. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBox()
        addTapGestureToSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // initialization of AR configution for running world tracking
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // parameters are added as a part of implementing of adding multiple objects
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        
        // creating box shape - 1 float = 1 meter
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        // node represents the position and coordinates of and object in a 3D space
        let boxNode = SCNNode()
        // node by itself has no visible content; to make it visible - set node geometry to the box
        boxNode.geometry = box
        // position is relative to camera
        boxNode.position = SCNVector3(x, y, z)
        //boxNode.position = SCNVector3(0, 0, -0.2)
        
        // scene - to be displayed in the view
        let scene = SCNScene()
        // root node in a scene defines the coordinate system of the real world rendered by SceneKit
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene

    }
    
    // adding gesture recognizer to ARSCNView
    func addTapGestureToSceneView() {
        // tap gesture recognizer initialized, action selector set to the custom callback function
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        // adding gesture recognizer object onto the sceneView
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // removing object from ARSCNView
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        
        // retrieving the user's tap location relative to the sceneView
        let tapLocation = recognizer.location(in: sceneView)
        
        // hit test to see if user tapped onto any node(s)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        // safely unwrapping the first node from hitTestResults
        guard let node = hitTestResults.first?.node else {
            
            // adding an object to the feature point if there is on that can be detected
            let  hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultsWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultsWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
            
        }
        // removing the first tapped on node from its parent node
        node.removeFromParentNode()
    }
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
    
}
