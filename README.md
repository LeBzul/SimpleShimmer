![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)
![Language](https://img.shields.io/badge/Swift-4-blue.svg)

# SimpleShimmer

![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/tableview_shimmer_classic.gif)

![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/classic_shimmer.gif)
![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/fade_shimmer.gif)

![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/classic_shimmer_color.gif)
![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/classic_shimmer_color_no_border.gif)



## Installation

Import SimpleShimmer folder in your project (or use example project)

## Usage 

Activate UIView Shimmer in InterfaceBuilder :

![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/activate_shimmer.png)



Or programmatically :
```Swift
myView.withShimmer = true
```

### Start shimmer

For a specific (activated) UIView : 

```Swift
myView.startShimmerAnimation()
myView.stopShimmerAnimation()
```

For all (activated) UIView in UIViewController :

```Swift
startShimmerAnimation()
stopShimmerAnimation()
```

For cell in UITableView or UICollectionView : 
```Swift
myTableView.startShimmerAnimation(withIdentifier: "shimmerCell", numberOfRows: 2, numberOfSections: 5)
myTableView.stopShimmerAnimation()
myCollectionView.startShimmerAnimation(withIdentifier: "collectionShimmerCell", numberOfRows: 2, numberOfSections: 5)
myCollectionView.stopShimmerAnimation()
```

### ShimmerOptions

Change animation type :

```Swift
ShimmerOptions.instance.animationType = .classic
```

| .classic  | .fade |
| ------------- | ------------- |
| ![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/classic_shimmer.gif) | ![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/fade_shimmer.gif) |

##### Animation properties : 

| Properties  | Possible value | Comment |
| ------------- | ------------- |  ------------- |
| animationDuration | CGFloat | Change animation duration |
| animationDelay | CGFloat | Delay to restart animation after end |
| animationAutoReserse | Bool | Reverse animation |
| animationDirection | topBottom, bottomTop, leftRight, rightLeft | Change animation direction (for animation type classic) |
| gradientColor | UIColor | Change gradient color (for animation type classic) |

##### Shimmer style : 

| Properties  | Possible value | Comment |
| ------------- | ------------- |  ------------- |
| gradientColor | UIColor | Change gradient color (for animation type classic) |
| borderWidth | CGFloat | Add border to Shimmer view |
| borderColor | UIColor | Change color to Shimmer view |
| backgroundColor | UIColor | Change background color to Shimmer view |


## Author

Guillian Drouin, drouingui@gmail.com

# License
SimpleShimmer is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
If you use it, I'll be happy to know about it.
