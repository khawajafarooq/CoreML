//
//  ViewController.swift
//  MLTest-CoreML
//
//  Created by GIB on 6/14/17.
//  Copyright © 2017 Xmen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let interval = 2.5
    var i = 0
    
    // ML model
    let model = Inceptionv3()
    
    // images to predict
    let images = ["img1.png","img2.png","img3.png","img4.png","img5.png","img6.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.image.image = nil
        self.label.text = ""
        
        // timer to repeatedly call changeImage
        Timer.scheduledTimer(timeInterval: interval, target: self,
                             selector: #selector(ViewController.changeImage(timer:)),
                             userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func changeImage(timer : Timer) {
        
        // get the image name by index
        let idx = (i % images.count)
        let imgName = images[idx]
        
        guard let img = UIImage(named: imgName) else {
            self.image.image = nil
            self.fatalError(error: "Error occurred: Image not found!")
            i = 0
            return
        }
        
        self.image.image = img
        predict(img)
        
        i += 1
    }
    
    fileprivate func predict(_ image: UIImage) {
        
        guard let buffer = image.getCVPixelBuffer() else {
            fatalError(error: "Unkown error occurred!")
            return
        }
        
        if let prediction = try? model.prediction(image: buffer) {
            let resultProb = getPrediction(prediction.classLabelProbs)
            displayResult(resultProb)
        }
        
    }
    
    fileprivate func getPrediction(_ prediction: [String: Double]) -> [Prediction] {
        let sortedProbs = prediction.sorted(by: {$0.1 > $1.1})
        
        var result: [Prediction] = []
        for (key, value) in sortedProbs[0..<5] {
            result.append(Prediction(name: key, probability: value))
        }
        return result
    }
    
    fileprivate func displayResult(_ predictionResult: [Prediction]) {
        
        var result = ""
        for prediction in predictionResult {
            
            result += "Prediction: \(prediction.name)\n"
            result += "Prob: \(prediction.probability.roundTo(places: 2))\n\n"
        }
        
        DispatchQueue.main.async() { [weak self] () -> Void in
            self?.label.text = result
        }
    }
    
    fileprivate func fatalError(error: String) {
        if !error.isEmpty {
            DispatchQueue.main.async() { [weak self] () -> Void in
                self?.label.text = error
            }
        }
    }

}
