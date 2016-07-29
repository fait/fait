<h1 align="center">
	<img src="/logo.png" width="200" alt="fait">
</h1>
<h4 align="center">extensible makefiles with npm</h4>

## installation

```sh
npm install --save-dev fait
```

When it installs, if you don't have a `makefile` already, fait copy its bootstrap makefile to your package directory.

## usage

fait doesn't do anything out of the box. It's designed to support modular makefiles installed with npm. It provides a Make macro, `require`, that uses Node's module resolution algorithm to include a makefile. For example, if you have a module called `foo` whose `main` is `index.mk`, then

```make
$(call require, foo)
```

expands to

```make
include node_modules/foo/index.mk
```

fait also sets some helpful defaults and provides useful functions for your makefiles.

## licence

MIT
