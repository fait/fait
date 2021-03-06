<h1 align="center">
	<img src="/logo.png" width="200" alt="fait">
</h1>
<h4 align="center">Twenty-first century Makefiles</h4>

fait is a toolkit for writing modular, maintainable, modern makefiles.

## Installation

```sh
npm install --save-dev fait
```

When it installs, if you don't have a `makefile` already, fait copies its bootstrap makefile to your package directory.

## Usage

fait doesn't do anything out of the box. It's designed to support modular makefiles installed with npm. It provides a macro, `require`, that uses Node's module resolution algorithm to include a makefile. So, if you have a module called `foo` whose `main` is `index.mk`, then

```make
$(call require, foo)
```

expands to

```make
include node_modules/foo/index.mk
```

fait also sets some helpful defaults and provides useful functions for your makefiles.

When somebody first clones your repo, they won't have fait installed locally. The default bootstrap takes care of that for you by installing fait from npm when trying to `include` it.

## Licence

MIT
