# Ruby Detect Objects

Some scripts to example how to use ruby to segment a example image and clustering them using ruby-fann

First we need to install the rmagick dependency

```bash
$ sudo apt install libmagickwand-dev
```

Then install the ruby version 3.2.2, and the gems:

```bash
$ bundle install
```

Now you can segment the example image and group them:

```bash
$ ruby sliding_window.rb
$ ruby clustering.rb
```
