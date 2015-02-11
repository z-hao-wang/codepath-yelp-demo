import UIKit

struct Utils {
    /**
    * There is a bug in setImageWithURLRequest.
    * When a image is already loading, call setImageWithURLRequest will fail.
    * To fix this, we queue the loading image, and set the value after loading is done.
    */
    static var urlsPending = Dictionary<String, Array<UIImageView>> ()
    static var urlsLoading = Dictionary<String, Bool> () // TODO: Find out the correct method to init an empty dictionary
    static func setImageWithUrl(urlString: String, imageView: UIImageView, placeHolerImg: UIImage?, success: (imageData: UIImage) -> (), fail: () -> ()) {
        if self.urlsLoading[urlString] == true {
            //attach to callback
            if self.urlsPending[urlString] == nil {
                self.urlsPending[urlString] = [imageView]
            } else {
                self.urlsPending[urlString]! += [imageView]
            }
        } else {
            //start loading
            self.urlsLoading[urlString] = true
            let imageURL = NSURL(string: urlString)!
            imageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: placeHolerImg, success: { (a, b, imageData) -> Void in
                imageView.image = imageData
                self.urlsLoading[urlString] = false
                if let pendings = self.urlsPending[urlString] {
                    //found callback, set to image data
                    for imgView in pendings {
                        imgView.image = imageData
                    }
                }
                success(imageData: imageData)
                }, failure: { (a, b, c) -> Void in
                    self.urlsLoading[urlString] = false
                    fail()
                    println(a)
            })
        }
    }
    static func setImageWithUrlFromThumbnailToLarge(urlString: String, imageView: UIImageView, successCallback: ((step: String) -> ())?) {
        //if the url is still loading
        self.setImageWithUrl(urlString, imageView: imageView, placeHolerImg: nil, success: { (imageData) -> () in
            if let cb = successCallback? {
                cb(step: "thumbnail")
            }
            //load original image, use thumbnail image as placeholder
            let originalImgURLStr = urlString.stringByReplacingOccurrencesOfString("tmb.jpg", withString: "ori.jpg")
            self.setImageWithUrl(originalImgURLStr, imageView: imageView, placeHolerImg: imageData, success: {(imageData2) -> () in
                if let cb = successCallback? {
                    cb(step: "original")
                }
                }, fail:{});
            }, fail: {})
    }
}