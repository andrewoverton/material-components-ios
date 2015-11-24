import UIKit

// This viewcontroller contains a subview that has an MDCShadowLayer.
// A gesture recognizer allows the user to adjust the elevation of the
// shadowed view by pressing it, and move it by dragging it.

class ViewController: UIViewController {

  @IBOutlet weak var blueView: ShadowedView!

  // The elevation of the view affects the size of its shadow.
  // The following elevations indicate to the user if the view
  // is pressed or not.
  let kMDCRestingCardElevation: CGFloat = 2.0
  let kMDCSelectedCardElevation: CGFloat = 8.0

  // A UILongPressGestureRecognizer handles the changing of elevation
  // and location of the shadowedView.
  let longPressRecogniser = UILongPressGestureRecognizer()

  // We store the offset from the initial touch to the center of the
  // view to properly update its location when dragged.
  var movingViewOffset = CGPointZero

  override func viewDidLoad() {
    super.viewDidLoad()

    self.blueView.setElevation(kMDCRestingCardElevation)

    longPressRecogniser.addTarget(self, action: "longPressedInView:")
    longPressRecogniser.minimumPressDuration = 0.0
    self.blueView.addGestureRecognizer(longPressRecogniser)
  }

  func longPressedInView(sender:UILongPressGestureRecognizer) {
    // Elevation of the view is changed to indicate that it has been pressed or released.
    // view.center is changed to follow the touch events.
    if (sender.state == .Began) {
      self.blueView.setElevation(kMDCSelectedCardElevation)

      let selfPoint = sender.locationInView(self.view)
      movingViewOffset.x = selfPoint.x - self.blueView.center.x
      movingViewOffset.y = selfPoint.y - self.blueView.center.y
    } else if (sender.state == .Changed) {
      let selfPoint = sender.locationInView(self.view)
      let newCenterPoint =
          CGPoint(x: selfPoint.x - movingViewOffset.x, y: selfPoint.y - movingViewOffset.y)
      self.blueView.center = newCenterPoint
    } else if (sender.state == .Ended) {
      self.blueView.setElevation(kMDCRestingCardElevation)

      movingViewOffset = CGPointZero
    }
  }

}
