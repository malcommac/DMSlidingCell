# DMSlidingCell

DMSlidingCell is a simple Slide-To-Reveal implementation of UITableViewCell found in Twitter and many other applications.
It uses blocks and Core Animation so it requires iOS 4.x or later.

Daniele Margutti, <http://www.danielemargutti.com>

![DMSlidingCell Example Project](http://danielemargutti.com/wp-content/uploads/2012/06/prova.png)


## How to get started

* Just use this cell as base class for your sliding UITableViewCell subclass
* Put frontmost visible content on cell's contentView and hidden content inside the backgroundView
* Set allowed swipe-to-reveal directions (cell.swipeDirection) and you're done! The magic is here, with a great animation too!
* You can handle slide events by using eventHandler block

## Change log

### June 30, 2012

* First version

## Donations

If you found this project useful, please donate.
There’s no expected amount and I don’t require you to.

<a href='https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GS3DBQ69ZBKWJ'>CLICK THIS LINK TO DONATE USING PAYPAL</a>

## License (MIT)

Copyright (c) 2012 Daniele Margutti

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.