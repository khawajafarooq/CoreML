# CoreML
This app predicts what is inside an image using Core ML framework using InceptionV3 model. InceptionV3 is object classification model which detects dominant objects inside an image. Introduced by [Apple WWDC17](https://developer.apple.com/machine-learning/).

## Setup
1. Download the Inception V3 model from [here](https://docs-assets.developer.apple.com/coreml/models/Inceptionv3.mlmodel)
2. [Drag & drop the model into project resrouces](https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app)
![Alt text](/screenshots/sc-2.png?raw=true "Drag & Drop at MLTest-CodeML/Resources/")

## Demo
![Alt text](/screenshots/sc-1.png?raw=true "Top 5 dominant objects predicted by CoreML")

## Compatibility

Verified that this repository's code works in XCode 9.0 beta with Swift 4.0
