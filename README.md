![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)
![Language](https://img.shields.io/badge/Swift-4-blue.svg)

# SimpleShimmer

![Img](https://github.com/LeBzul/SimpleShimmer/blob/master/example_images/classic_shimmer.gif)

## Installation

Import SimpleShimmer folder in your project (or use example project)

## Usage 

Activate UIView Shimmer in InterfaceBuilder :


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

### Configure Shimmer 


# License
SimpleShimmer is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
If you use it, I'll be happy to know about it.
