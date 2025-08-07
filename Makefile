clean:
	flutter clean
	rm -f pubspec.lock .packages
	cd ios && rm -rf Pods Podfile.lock .symlinks && cd ..

reinstall:
	flutter pub get
	cd ios && pod install && cd ..

run:
	flutter run

all: clean reinstall run

.PHONY: clean reinstall run all
