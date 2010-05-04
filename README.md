Overview
========

Caboose is an app that loads notifications from the [Boxcar](http://boxcar.io/) service. It provides a reusable class for interacting with the Boxcar service for receiving push notifications.

Dependencies
============

* [TouchJSON](http://code.google.com/p/touchcode/)
* [WebSocket](http://github.com/esad/zimt)
* [AsyncSocket](http://homepage.mac.com/d_j_v/FileSharing4.html)

Install
=======

1. git clone git://github.com/amazingsyco/caboose.git
2. cd caboose
3. git submodule init
4. git submodule update
5. xcodebuild

Set Up
======

In the Terminal:

* `defaults write com.villainware.caboose boxcarEmail john@example.com`
* `defaults write com.villainware.caboose boxcarPassword myPassword`

License
=======

Caboose was written by [Steve Streza](http://stevestreza.com/). This code is licensed under the MIT license. Use it however you want, just provide attribution.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sellcopies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.