# Image Classifier App
This app predicts dominant object(s) inside an image using Core ML framework. For current example, I have used an opensource ml model **InceptionV3** which is used for object classification introduced by Apple in [WWDC 2017](https://developer.apple.com/machine-learning/).

## Setup
1. Download the Inception V3 model from [here](https://docs-assets.developer.apple.com/coreml/models/Inceptionv3.mlmodel)
2. Drag & drop the model into [project resrouces](https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app)
![Alt text](/screenshots/sc-2.png?raw=true "Drag & Drop at MLTest-CodeML/Resources/")

## Demo
![Alt text](/screenshots/sc-1.png?raw=true "Top 5 dominant objects predicted by CoreML")

## Compatibility
Verified that this repository's code works in XCode 9.0 beta with Swift 4.0

## Author 🙏🏻
**Web**: [Khawaja Farooq](http://khawajafarooq.github.io)

**Twitter**: [@khfarooq](https://twitter.com/khfarooq)

**Medium**: [@khfarooq](https://medium.com/@khfarooq)
