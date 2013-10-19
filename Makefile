default: test
	
test:
	xcodebuild -workspace Qwirkle.xcworkspace -scheme Qwirkle -sdk iphonesimulator7.0 test
