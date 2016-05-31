BOOTSTRAP_VERSION	= 3.3.6
FONT_AWESOME_VERSION	= 4.6.3
JQUERY_VERSION		= 1.12.4
JQUERY_EASING_VERSION	= 1.3

CODE = bootstrap font-awesome fancyBox jquery.min.js jquery.easing.js

default: build

build: $(CODE)


bootstrap: bootstrap-$(BOOTSTRAP_VERSION)-dist.zip
	if [ ! -e $@ ]; then unzip $<; mv $(basename $<) $@; fi

font-awesome: font-awesome-$(FONT_AWESOME_VERSION).zip
	if [ ! -e $@ ]; then unzip $<; mv $(basename $<) $@; fi
	( \
	cd font-awesome/css; \
	sed -i -e "s/url('\.\./url('http:\/\/web.masonkatz.com\/font-awesome/g" font-awesome.css; \
	sed -i -e "s/url('\.\./url('http:\/\/web.masonkatz.com\/font-awesome/g" font-awesome.min.css; \
	rm *-e; \
	)


fancyBox: fancyapps-fancyBox-v2.1.5-0-ge2248f4.zip
	if [ ! -e $@ ]; then unzip $<; mv fancyapps-fancyBox-18d1712 $@; fi

jquery.min.js: jquery-$(JQUERY_VERSION).min.js
	cp $^ $@

jquery.easing.js: jquery.easing.$(JQUERY_EASING_VERSION).js
	cp $^ $@

.PHONY: sync
sync: build
	for code in $(CODE); do s3cmd sync $$code s3://web.masonkatz.com; done

clean:
	-rm -rf $(CODE)
