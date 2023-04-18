* Minimal package to explore issue in generating example images when the example
  creates an error with ``ragg::agg_png()`` but you've requested the use of ``grDevices::png()`` in ``_pkgdown.yml``.
* `{pgkdown}` seems to first run images with ``ragg::agg_png()`` as active graphics device and then re-generates the images
  with the requested graphics device?
* ``_pkgdown.yml`` figure code:

  ```yaml
  figures:
    dev: grDevices::png
    dev.args:
      type: "cairo"
  ```

* The example uses the "affine transformation" feature introduced in R 4.2 and I want to skip the example
  unless ``print(isTRUE(dev.capabilities()$transformations))``.
* Also created a Dockerfile that 1) install development version of `{pgkdown}`, builds pkgdown documentation for this minimal package, and serves the documentation on port 3000:

  ```bash 
  docker build -t trevorld/pkgdown-png .
  docker run --rm -p 3000:3000 trevorld/pkgdown-png
  ```

  Should be able to example at http://localhost:3000/reference/transformationGrob.html#examples
