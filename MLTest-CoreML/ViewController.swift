//
//  ViewController.swift
//  MLTest-CoreML
//
//  Created by GIB on 6/14/17.
//  Copyright © 2017 Xmen. All rights reserved.
//

import UIKit

enum LoadingState {
    case Loading
    case Finished
}

class ViewController: UIViewController, ActivityIndicatorPresenter {
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    // ivars
    var i = 0
    var predictionResult: [Prediction] = []
    var state: LoadingState = .Finished
    
    // ML model
    let model = Inceptionv3()
    
    // images to predict
    let images = ["img1.png","img2.png","img3.png","img4.png","img5.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.image.image = nil
        self.headerLabel.text = ""
        
        loadUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func loadUI() {
        self.showActivityIndicator()
        if let img = loadNextImage() {
            
            DispatchQueue.global(qos: .default).async { [weak self] () -> Void in
                guard let prediction = self?.predict(img) else {
                    self?.updateUIState()
                    return
                }
                
                DispatchQueue.main.async() { [weak self] () -> Void in
                    self?.image.image = img
                    self?.displayResult(prediction)
                    self?.updateUIState()
                }
            }
        }
    }
    
    fileprivate func updateUIState() {
        self.enableButton(flag: true)
        self.state = .Finished
        self.hideActivityIndicator()
    }
    
    fileprivate func loadNextImage() -> UIImage? {
        
        // get the image name by index
        let idx = (i % images.count)
        let imgName = images[idx]
        
        guard let img = UIImage(named: imgName) else {
            self.image.image = nil
            self.fatalError(error: "Error occurred: Image not found!")
            i = 0
            return nil
        }
        
        i += 1
        return img
    }
    
    fileprivate func predict(_ image: UIImage) -> Inceptionv3Output? {
        
        guard let buffer = image.getCVPixelBuffer() else {
            fatalError(error: "Unkown error occurred!")
            return nil
        }
        
        guard let prediction = try? model.prediction(image: buffer) else {
            return nil
        }
        
        return prediction
    }
    
    fileprivate func getPrediction(_ prediction: [String: Double]) -> [Prediction] {
        let sortedProbs = prediction.sorted(by: {$0.1 > $1.1})
        
        var result: [Prediction] = []
        for (key, value) in sortedProbs[0..<5] {
            result.append(Prediction(name: key, probability: value))
        }
        return result
    }
    
    fileprivate func displayResult(_ prediction: Inceptionv3Output) {
        
        let headerText = "I think it's a \(prediction.classLabel)"
        self.predictionResult = getPrediction(prediction.classLabelProbs)
        self.headerLabel.text = headerText
        self.tableView.reloadData()
        
    }
    
    fileprivate func fatalError(error: String) {
        if !error.isEmpty {
            DispatchQueue.main.async() { [weak self] () -> Void in
                self?.headerLabel.text = error
            }
        }
    }

    @IBAction func nextBtnAction(_ sender: Any) {
        
        enableButton(flag: false)
        if self.state == .Finished {
            self.state = .Loading
            loadUI()
        }
    }
    
    fileprivate func enableButton(flag: Bool) {
        self.nextButton.isEnabled = flag
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MLPredictionCell", for: indexPath)
        
        let predictionItem = predictionResult[indexPath.row]
        cell.textLabel?.text = predictionItem.name
        cell.detailTextLabel?.text = "Prob: \(predictionItem.probability.roundTo(places: 2))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top 5 Predictions"
    }
    
}
